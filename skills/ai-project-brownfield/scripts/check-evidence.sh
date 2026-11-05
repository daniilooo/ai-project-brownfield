#!/usr/bin/env bash
# ai-project-brownfield — check-evidence.sh
#
# Verifica se as evidências citadas no Vault ainda existem e se mudaram desde o bootstrap.
#
#   check-evidence.sh [--since <ref>] [--strict] [raiz-com-vault] [outras raízes...]
#
# Lê vault/**/*.md e .ai/HANDOFF.md e verifica:
#   - BROKEN   caminho citado entre crases (`src/x.py`, `pom.xml:42`, `A.java:10-20`) que não
#              existe em nenhuma raiz; nome sem diretório é procurado pelo basename;
#   - LINE     arquivo existe, mas a linha/intervalo citado passa do fim do arquivo;
#   - LINK     link Markdown relativo quebrado ([texto](../x.md));
#   - STALE    arquivo citado foi alterado desde a baseline (drift: reverifique a afirmação);
#   - UNCOVERED arquivos de produto alterados desde a baseline e não citados (onde redescobrir).
#
# Baseline: --since <ref> (raiz principal) ou a linha "BASELINE_COMMIT:" de
# .ai/BOOTSTRAP_STATUS.md, com SHA puro (raiz principal) ou entradas <repo>@<sha>.
# Sem baseline, só existência/linhas/links são verificados.
#
# Só cita caminhos e números de linha; nunca imprime conteúdo de arquivos. Somente leitura.
# Saída: 0 = OK; 1 = evidência quebrada (ou STALE com --strict); 2 = erro de uso.

set -u
export LC_ALL=C

SINCE=""
STRICT=0
ROOTS=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --since) SINCE="${2:-}"; [ -n "$SINCE" ] || { echo "ERRO: --since exige <ref>" >&2; exit 2; }; shift 2 ;;
    --strict) STRICT=1; shift ;;
    -h|--help) sed -n '2,22p' "$0"; exit 0 ;;
    -*) echo "ERRO: opção desconhecida: $1" >&2; exit 2 ;;
    *) ROOTS+=("$1"); shift ;;
  esac
done
[ "${#ROOTS[@]}" -eq 0 ] && ROOTS=(".")

ABS=()
for r in "${ROOTS[@]}"; do
  a="$(cd "$r" 2>/dev/null && pwd)" || { echo "ERRO: raiz inexistente: $r" >&2; exit 2; }
  ABS+=("$a")
done
PRIMARY="${ABS[0]}"
cd "$PRIMARY" || exit 2
[ -d vault ] || { echo "ERRO: vault/ não encontrado em $PRIMARY" >&2; exit 2; }

TMPD="$(mktemp -d "${TMPDIR:-/tmp}/bf-evidence.XXXXXX")" || exit 2
trap 'rm -rf "$TMPD"' EXIT

MULTI=0; [ "${#ABS[@]}" -gt 1 ] && MULTI=1
label() { # $1 raiz absoluta ; $2 caminho relativo
  if [ "$MULTI" -eq 1 ]; then echo "$(basename "$1")/$2"; else echo "$2"; fi
}

SUPPORT='^(vault|\.ai|\.claude|\.agents|\.codex)/|^(AGENTS|CLAUDE)\.md$'
EXT='java|kt|kts|scala|groovy|go|py|rb|php|js|mjs|cjs|jsx|ts|tsx|vue|svelte|cs|fs|vb|rs|c|cc|cpp|h|hpp|swift|m|mm|dart|ex|exs|erl|clj|lua|pl|r|sql|yml|yaml|json|jsonc|toml|xml|gradle|properties|ini|cfg|conf|md|mdx|rst|adoc|txt|sh|bash|ps1|bat|tf|tfvars|hcl|lock|mod|sum|proto|graphql|gql|html|htm|css|scss|sass|less|csv|ipynb|example|sample|template|tpl|j2|env'
NAMES='Dockerfile|Makefile|Jenkinsfile|Procfile|Gemfile|Rakefile|Vagrantfile|Containerfile|Taskfile|Justfile|CODEOWNERS|LICENSE'

# Índice de arquivos de cada raiz (inclui não rastreados; ignora .git e dependências)
i=0
for r in "${ABS[@]}"; do
  (cd "$r" && find . \( -name .git -o -name node_modules -o -name vendor -o -name .venv -o -name target -o -name dist -o -name build \) -prune \
     -o -type f -print | sed 's#^\./##' | sort) > "$TMPD/index.$i"
  i=$((i + 1))
done

# 1. Extrai citações entre crases e links Markdown (fora de blocos ```)
DOCS="$(find vault -type f -name '*.md' | sort; [ -f .ai/HANDOFF.md ] && echo .ai/HANDOFF.md)"
for f in $DOCS; do
  awk -v F="$f" '
    /^[[:space:]]*```/ { fence = !fence; next }
    fence { next }
    {
      s = $0
      while (match(s, /`[^`]+`/)) { print "CODE\t" F "\t" NR "\t" substr(s, RSTART + 1, RLENGTH - 2); s = substr(s, RSTART + RLENGTH) }
      s = $0
      while (match(s, /\]\([^)[:space:]]+\)/)) { print "LINK\t" F "\t" NR "\t" substr(s, RSTART + 2, RLENGTH - 3); s = substr(s, RSTART + RLENGTH) }
    }' "$f"
done > "$TMPD/refs"

broken=0; badline=0; badlink=0; checked=0
: > "$TMPD/cited"   # idx \t relpath \t onde

file_lines() { awk 'END { print NR }' "$1"; }

resolve() { # $1 caminho -> imprime "idx\trelpath" das ocorrências
  local p="$1" j=0 r rest
  for r in "${ABS[@]}"; do
    if [ "${p%/}" != "$p" ]; then
      [ -d "$r/$p" ] && printf '%s\t%s\n' "$j" "$p"
    elif [ "${p#*/}" != "$p" ]; then
      [ -f "$r/$p" ] && printf '%s\t%s\n' "$j" "$p"
      rest="${p#*/}"
      [ "${p%%/*}" = "$(basename "$r")" ] && [ -f "$r/$rest" ] && printf '%s\t%s\n' "$j" "$rest"
    else
      grep -E "(^|/)$(printf '%s' "$p" | sed 's/[.[\*^$+?(){}|]/\\&/g')\$" "$TMPD/index.$j" | sed "s#^#$j	#"
    fi
    j=$((j + 1))
  done
}

while IFS="$(printf '\t')" read -r kind src ln tok; do
  where="$src:$ln"
  if [ "$kind" = "LINK" ]; then
    case "$tok" in http:*|https:*|mailto:*|\#*|/*) continue ;; esac
    t="${tok%%#*}"; [ -z "$t" ] && continue
    checked=$((checked + 1))
    [ -e "$(dirname "$src")/$t" ] || { echo "LINK      $where → $t"; badlink=$((badlink + 1)); }
    continue
  fi

  case "$tok" in *[[:space:]]*|*...*|*'*'*|*'<'*|*'>'*|*'{'*|*'}'*|*'$'*|*'://'*|*'='*|*'@'*|'') continue ;; esac
  path="$tok"; start=""; end=""
  if printf '%s' "$tok" | grep -Eq ':[0-9]+(-[0-9]+)?$'; then
    path="${tok%:*}"; range="${tok##*:}"; start="${range%-*}"; end="${range#*-}"
  fi
  case "$path" in *:*|./*|../*|'') continue ;; esac
  base="$(basename "$path")"
  if [ "${path%/}" = "$path" ]; then
    printf '%s' "$base" | grep -Eq "^($NAMES)$|^\.[A-Za-z0-9_.-]+$|\.($EXT)$" || continue
  fi
  checked=$((checked + 1))
  hits="$(resolve "$path")"
  if [ -z "$hits" ]; then
    echo "BROKEN    $where → $tok (não encontrado em nenhuma raiz)"
    broken=$((broken + 1)); continue
  fi
  okline=0
  while IFS="$(printf '\t')" read -r idx rel; do
    printf '%s\t%s\t%s\n' "$idx" "$rel" "$where" >> "$TMPD/cited"
    if [ -z "$start" ] || [ -d "${ABS[$idx]}/$rel" ] || [ "$end" -le "$(file_lines "${ABS[$idx]}/$rel")" ]; then okline=1; fi
  done <<EOF
$hits
EOF
  [ "$okline" -eq 1 ] || { echo "LINE      $where → $tok (arquivo tem menos linhas)"; badline=$((badline + 1)); }
done < "$TMPD/refs"

# 2. Drift desde a baseline
stale=0; uncovered=0; baselines=0
BLINE=""
[ -f .ai/BOOTSTRAP_STATUS.md ] && BLINE="$(grep -E '^BASELINE_COMMIT:' .ai/BOOTSTRAP_STATUS.md | head -n 1 | sed 's/^BASELINE_COMMIT:[[:space:]]*//')"

j=0
for r in "${ABS[@]}"; do
  ref=""
  if [ "$j" -eq 0 ] && [ -n "$SINCE" ]; then ref="$SINCE"
  else
    for e in $(printf '%s' "$BLINE" | tr ',;' '  '); do
      case "$e" in
        *@*) [ "${e%@*}" = "$(basename "$r")" ] && ref="${e#*@}" ;;
        *) [ "$j" -eq 0 ] && printf '%s' "$e" | grep -Eq '^[0-9a-f]{7,40}$' && ref="$e" ;;
      esac
    done
  fi
  if [ -n "$ref" ]; then
    if ! git -C "$r" rev-parse -q --verify "$ref^{commit}" >/dev/null 2>&1; then
      echo "WARN      baseline $ref não encontrada em $(basename "$r") (drift não verificado)"
    else
      baselines=$((baselines + 1))
      n="$(git -C "$r" rev-list --count "$ref..HEAD")"
      echo "BASELINE  $(basename "$r")@$(git -C "$r" rev-parse --short "$ref") · $n commit(s) desde então"
      { git -C "$r" diff --name-only "$ref" --; git -C "$r" ls-files --others --exclude-standard; } | sort -u | grep -Ev "$SUPPORT" > "$TMPD/changed.$j"
      awk -F '\t' -v J="$j" '$1 == J { print $2 }' "$TMPD/cited" | sort -u > "$TMPD/cited.$j"
      while IFS= read -r rel; do
        [ -z "$rel" ] && continue
        cites="$(awk -F '\t' -v J="$j" -v P="$rel" '$1 == J && $2 == P { print $3 }' "$TMPD/cited" | sort -u | head -n 3 | tr '\n' ' ' | sed 's/ $//')"
        echo "STALE     $(label "$r" "$rel") — alterado desde a baseline; citado em: $cites"
        stale=$((stale + 1))
      done <<EOF
$(comm -12 "$TMPD/changed.$j" "$TMPD/cited.$j")
EOF
      comm -23 "$TMPD/changed.$j" "$TMPD/cited.$j" > "$TMPD/unc.$j"
      u="$(grep -c . "$TMPD/unc.$j" || true)"
      uncovered=$((uncovered + u))
      head -n 15 "$TMPD/unc.$j" | while IFS= read -r rel; do echo "UNCOVERED $(label "$r" "$rel")"; done
      [ "$u" -gt 15 ] && echo "UNCOVERED … e mais $((u - 15)) arquivo(s) em $(basename "$r")"
    fi
  fi
  j=$((j + 1))
done
[ "$baselines" -eq 0 ] && echo "INFO      sem baseline (--since ou BASELINE_COMMIT em .ai/BOOTSTRAP_STATUS.md): drift não verificado"

fails=$((broken + badline + badlink))
[ "$STRICT" -eq 1 ] && fails=$((fails + stale))
summary="$checked referência(s); $broken quebrada(s), $badline linha(s) inválida(s), $badlink link(s) quebrado(s), $stale desatualizada(s), $uncovered alteração(ões) não coberta(s)"
if [ "$fails" -gt 0 ]; then echo "RESULT: FAIL — $summary"; exit 1; fi
echo "RESULT: OK — $summary"
