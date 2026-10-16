#!/usr/bin/env bash
# Testes automatizados da skill ai-project-brownfield.
#
#   tests/run.sh            executa todas as suítes
#   tests/run.sh -v         mostra a saída dos scripts nas falhas
#   KEEP_TMP=1 tests/run.sh mantém os repositórios montados em tests/.tmp/ (para cenários manuais)
#
# Requisitos: bash, git (>= 2.31), coreutils. Sem rede, sem dependências externas.
# Cobre a parte determinística (estrutura da skill, discover, check-scope, validate-vault).
# O comportamento da LLM é avaliado pelos cenários manuais em tests/scenarios/.

set -u
export LC_ALL=C

VERBOSE=0
[ "${1:-}" = "-v" ] && VERBOSE=1

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
SKILL="$ROOT/skills/ai-project-brownfield"
SCRIPTS="$SKILL/scripts"
FIX="$HERE/fixtures"
TMP="$HERE/.tmp"

rm -rf "$TMP"; mkdir -p "$TMP"

# Git isolado e determinístico
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=fixture GIT_AUTHOR_EMAIL=fixture@example.com
export GIT_COMMITTER_NAME=fixture GIT_COMMITTER_EMAIL=fixture@example.com
export GIT_CONFIG_COUNT=3
export GIT_CONFIG_KEY_0=init.defaultBranch GIT_CONFIG_VALUE_0=main
export GIT_CONFIG_KEY_1=commit.gpgsign GIT_CONFIG_VALUE_1=false
export GIT_CONFIG_KEY_2=tag.gpgsign GIT_CONFIG_VALUE_2=false

PASS=0; FAIL=0
ok() { PASS=$((PASS + 1)); echo "  ok   $*"; }
ko() { FAIL=$((FAIL + 1)); echo "  FAIL $*"; }
section() { echo; echo "== $*"; }

# Cria repositório Git a partir de um diretório de arquivos. $1 origem, $2 destino, $3 setup.sh opcional
build_repo() {
  mkdir -p "$2"
  cp -R "$1/." "$2/"
  (
    cd "$2" || exit 1
    git init -q
    git add -A
    git commit -q -m "chore: initial import"
    if [ -n "${3:-}" ] && [ -f "$3" ]; then bash "$3"; fi
  ) || return 1
}

# Verifica expectativas "+ texto" (deve existir) e "- texto" (não deve existir) em uma saída
check_expect() { # $1 arquivo de saída ; $2 expect.txt ; $3 nome
  local out="$1" exp="$2" name="$3" line sign text bad=0
  while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue
    sign="${line%% *}"; text="${line#* }"
    if [ "$sign" = "+" ] && ! grep -qF -- "$text" "$out"; then ko "$name: esperado encontrar: $text"; bad=1; fi
    if [ "$sign" = "-" ] && grep -qF -- "$text" "$out"; then ko "$name: NÃO deveria conter: $text"; bad=1; fi
  done < "$exp"
  [ "$bad" -eq 0 ] && ok "$name: $(grep -c . "$exp") expectativas"
  [ "$bad" -eq 1 ] && [ "$VERBOSE" -eq 1 ] && sed 's/^/      | /' "$out"
}

snapshot() { # hash de conteúdo + status git (para provar somente-leitura)
  (cd "$1" && git status --porcelain && find . -path ./.git -prune -o -type f -print | sort | xargs cat | cksum)
}

# =========================================================================== A
section "A. Estrutura da skill"

[ -f "$SKILL/SKILL.md" ] && ok "SKILL.md existe" || ko "SKILL.md ausente"
head -1 "$SKILL/SKILL.md" | grep -qx -- '---' && ok "frontmatter abre" || ko "frontmatter ausente"
grep -qx 'name: ai-project-brownfield' "$SKILL/SKILL.md" && ok "name = ai-project-brownfield" || ko "name incorreto"
desc_len=$(awk '/^description:/{f=1;next} /^---$/{if(f)exit} f' "$SKILL/SKILL.md" | tr -s ' \n' ' ' | wc -c | tr -d ' ')
[ "$desc_len" -gt 50 ] && [ "$desc_len" -le 1024 ] && ok "description com $desc_len caracteres (≤ 1024)" || ko "description com $desc_len caracteres"
lines=$(wc -l < "$SKILL/SKILL.md" | tr -d ' ')
[ "$lines" -le 500 ] && ok "SKILL.md com $lines linhas (≤ 500, progressive disclosure)" || ko "SKILL.md muito longo: $lines"

missing=0
for ref in $(grep -oE '(references|templates|scripts|agents|examples)/[A-Za-z0-9_./-]+\.(md|sh|yaml)' "$SKILL/SKILL.md" "$SKILL"/references/*.md "$SKILL"/agents/*.md | cut -d: -f2 | sort -u); do
  [ -e "$SKILL/$ref" ] || { ko "referência quebrada: $ref"; missing=1; }
done
[ "$missing" -eq 0 ] && ok "todas as referências internas existem"

for s in "$SCRIPTS"/*.sh "$HERE/run.sh"; do
  bash -n "$s" && [ -x "$s" ] && ok "sintaxe e permissão: $(basename "$s")" || ko "script inválido ou não executável: $s"
done
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -S warning "$SCRIPTS"/*.sh >/dev/null && ok "shellcheck sem warnings" || ko "shellcheck encontrou problemas"
fi

[ -f "$SKILL/agents/openai.yaml" ] && grep -q 'display_name' "$SKILL/agents/openai.yaml" && ok "agents/openai.yaml (Codex)" || ko "agents/openai.yaml ausente"

for f in 00_HOME/START_HERE.md 00_HOME/PROJECT_MAP.md 02_BUSINESS/BUSINESS_RULES.md 03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md \
         04_DEVELOPMENT/AI_WORKFLOW.md 04_DEVELOPMENT/GITFLOW.md 04_DEVELOPMENT/TEST_STRATEGY.md 05_STATE/CURRENT_STATE.md \
         05_STATE/NEXT_ACTION.md 05_STATE/GAP_ANALYSIS.md 05_STATE/TECHNICAL_DEBT.md 05_STATE/KNOWN_RISKS.md \
         05_STATE/OPEN_DECISIONS.md 11_ROADMAP/DEVELOPMENT_PLAN.md; do
  [ -f "$SKILL/templates/vault/$f" ] || ko "template núcleo ausente: $f"
done && ok "templates do núcleo do Vault presentes"

grep -q 'RISK_HIGH' "$SKILL/templates/vault/04_DEVELOPMENT/AI_WORKFLOW.md" \
  && grep -q 'GATE 3' "$SKILL/templates/vault/04_DEVELOPMENT/AI_WORKFLOW.md" \
  && grep -q 'PLAN' "$SKILL/templates/vault/04_DEVELOPMENT/AI_WORKFLOW.md" \
  && ok "AI_WORKFLOW contém risk model, gates e PLAN/BUILD/VERIFY/SHIP" || ko "AI_WORKFLOW incompleto"

# Nenhuma dependência de runtime da skill de referência
if grep -rqi 'ai-project-bootstrap' "$SKILL"; then ko "a skill referencia ai-project-bootstrap (deve ser independente)"; else ok "skill independente de ai-project-bootstrap"; fi

# =========================================================================== B
section "B. discover.sh nas fixtures"

for dir in "$FIX"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/expect.txt" ] || continue
  dest="$TMP/discover/$name"
  roots=()
  if [ -d "$dir/repos" ]; then
    for r in "$dir"/repos/*/; do
      build_repo "$r" "$dest/$(basename "$r")" || ko "$name: build"
      roots+=("$dest/$(basename "$r")")
    done
  elif [ -d "$dir/repo" ]; then
    build_repo "$dir/repo" "$dest" "$dir/setup.sh" || ko "$name: build"
    roots=("$dest")
  elif [ "$name" = "13-existing-ai-setup" ]; then
    mkdir -p "$TMP/src13/src"
    cp -R "$SKILL/examples/bootstrapped-project/." "$TMP/src13/"
    printf 'class App {}\n' > "$TMP/src13/src/App.java"
    build_repo "$TMP/src13" "$dest" || ko "$name: build"
    roots=("$dest")
  fi
  before="$(for r in "${roots[@]}"; do snapshot "$r"; done)"
  "$SCRIPTS/discover.sh" "${roots[@]}" > "$TMP/$name.out" 2> "$TMP/$name.err"
  rc=$?
  after="$(for r in "${roots[@]}"; do snapshot "$r"; done)"
  [ "$rc" -eq 0 ] || ko "$name: discover.sh saiu com $rc"
  [ -s "$TMP/$name.err" ] && ko "$name: stderr não vazio: $(head -c 200 "$TMP/$name.err")"
  [ "$before" = "$after" ] || ko "$name: discover.sh alterou o repositório (deveria ser somente leitura)"
  check_expect "$TMP/$name.out" "$dir/expect.txt" "$name"
done

# =========================================================================== C
section "C. check-scope.sh (cenário 15: nenhum código de produto alterado)"

R="$TMP/scope"
build_repo "$FIX/01-simple-monolith/repo" "$R"
(cd "$R" && git checkout -q -b docs/ai-brownfield-bootstrap)

mkdir -p "$R/vault/05_STATE" "$R/.ai" "$R/.claude/agents"
echo "# state" > "$R/vault/05_STATE/CURRENT_STATE.md"
echo "# handoff" > "$R/.ai/HANDOFF.md"
echo "@AGENTS.md" > "$R/CLAUDE.md"
echo "# agents" > "$R/AGENTS.md"
echo "x" > "$R/.claude/agents/explorer.md"
(cd "$R" && git add -A && git commit -q -m "docs(ai): brownfield bootstrap")
echo "# extra" > "$R/vault/05_STATE/NEXT_ACTION.md"   # não rastreado, permitido
"$SCRIPTS/check-scope.sh" "$R" > "$TMP/scope1.out"; rc=$?
[ "$rc" -eq 0 ] && ok "somente suporte (commitado + não rastreado) → OK" || { ko "suporte deveria passar (rc=$rc)"; cat "$TMP/scope1.out"; }

echo "// change" >> "$R/src/main/java/com/example/shop/CartService.java"
"$SCRIPTS/check-scope.sh" "$R" > "$TMP/scope2.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'VIOLATION (fora do escopo de suporte): src/main/java/com/example/shop/CartService.java' "$TMP/scope2.out" \
  && ok "alteração em código de produto (working tree) → FAIL" || ko "código de produto não detectado"
(cd "$R" && git checkout -q -- src)

echo "x" > "$R/pom.xml.new"; (cd "$R" && git add pom.xml.new && git commit -q -m "chore: oops")
"$SCRIPTS/check-scope.sh" "$R" > "$TMP/scope3.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'pom.xml.new' "$TMP/scope3.out" && ok "arquivo de produto commitado na branch → FAIL" || ko "commit fora do escopo não detectado"
(cd "$R" && git reset -q --hard HEAD~1)

echo "SECRET=1" > "$R/vault/.env"
"$SCRIPTS/check-scope.sh" "$R" > "$TMP/scope4.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'VIOLATION (segredo): vault/.env' "$TMP/scope4.out" && ok "arquivo de segredo dentro de pasta permitida → FAIL" || ko "segredo não detectado"
rm -f "$R/vault/.env"

mkdir -p "$R/.github/workflows"; echo "on: push" > "$R/.github/workflows/ci.yml"
"$SCRIPTS/check-scope.sh" "$R" > "$TMP/scope5.out"; rc=$?
[ "$rc" -eq 1 ] && ok "alteração de pipeline CI/CD → FAIL" || ko "pipeline não detectado"
rm -rf "$R/.github"

(cd "$R" && git rm -q README.md)
"$SCRIPTS/check-scope.sh" "$R" > "$TMP/scope6.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'README.md' "$TMP/scope6.out" && ok "remoção de README do produto → FAIL" || ko "remoção de arquivo de produto não detectada"
(cd "$R" && git reset -q HEAD README.md && git checkout -q -- README.md)

BROWNFIELD_ALLOW='^GEMINI\.md$' bash -c "echo x > '$R/GEMINI.md'; '$SCRIPTS/check-scope.sh' '$R'" > "$TMP/scope7.out"; rc=$?
[ "$rc" -eq 0 ] && ok "BROWNFIELD_ALLOW estende a allowlist" || ko "BROWNFIELD_ALLOW não funcionou"
rm -f "$R/GEMINI.md"

# =========================================================================== D
section "D. validate-vault.sh"

"$SCRIPTS/validate-vault.sh" "$SKILL/examples/bootstrapped-project" > "$TMP/vv1.out"; rc=$?
[ "$rc" -eq 0 ] && ok "exemplo completo (Orderly) passa" || { ko "exemplo deveria passar"; cat "$TMP/vv1.out"; }

V="$TMP/vv-template"; mkdir -p "$V"
cp -R "$SKILL/templates/vault" "$V/vault"; cp "$SKILL/templates/root/AGENTS.md" "$V/"; mkdir -p "$V/.ai"; cp "$SKILL/templates/ai/HANDOFF.md" "$V/.ai/"
"$SCRIPTS/validate-vault.sh" "$V" > "$TMP/vv2.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'PLACEHOLDER' "$TMP/vv2.out" && grep -q 'TEMPLATE_MARKER' "$TMP/vv2.out" \
  && ok "templates não preenchidos → FAIL (placeholders/marcadores)" || ko "templates crus deveriam falhar"

V="$TMP/vv-bad"; mkdir -p "$V"; cp -R "$SKILL/examples/bootstrapped-project/." "$V/"
printf 'Conexão de prod: postgres://admin:SuperSecret99@db.internal:5432/app\n' >> "$V/vault/03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md"
"$SCRIPTS/validate-vault.sh" "$V" > "$TMP/vv3.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'SECRET vault/03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md' "$TMP/vv3.out" && ! grep -q 'SuperSecret99' "$TMP/vv3.out" \
  && ok "credencial em URL → FAIL sem reproduzir o valor" || ko "segredo no Vault não detectado ou valor vazado"

V="$TMP/vv-long"; mkdir -p "$V"; cp -R "$SKILL/examples/bootstrapped-project/." "$V/"
for i in $(seq 1 130); do echo "- item $i" >> "$V/vault/05_STATE/CURRENT_STATE.md"; done
printf '\n## CURRENT_GOAL\nsegunda ação\n' >> "$V/vault/05_STATE/NEXT_ACTION.md"
"$SCRIPTS/validate-vault.sh" "$V" > "$TMP/vv4.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'CURRENT_STATE.md tem' "$TMP/vv4.out" && grep -q 'UMA ação' "$TMP/vv4.out" \
  && ok "CURRENT_STATE longo e NEXT_ACTION com 2 objetivos → FAIL" || ko "limites de tamanho/ação única não aplicados"

V="$TMP/vv-missing"; mkdir -p "$V"; cp -R "$SKILL/examples/bootstrapped-project/." "$V/"
rm "$V/vault/05_STATE/OPEN_DECISIONS.md"; printf '# PERSONAS\n\n| Persona | Objetivo |\n|---|---|\n' > "$V/vault/05_STATE/EMPTY.md"
sed -i.bak '/^LAST_COMPLETED_ACTION:/d' "$V/.ai/HANDOFF.md"
"$SCRIPTS/validate-vault.sh" "$V" > "$TMP/vv5.out"; rc=$?
[ "$rc" -eq 1 ] && grep -q 'núcleo ausente: vault/05_STATE/OPEN_DECISIONS.md' "$TMP/vv5.out" \
  && grep -q 'vazio ou só com títulos' "$TMP/vv5.out" && grep -q 'HANDOFF.md sem campo LAST_COMPLETED_ACTION' "$TMP/vv5.out" \
  && ok "núcleo ausente, arquivo só-template e handoff incompleto → FAIL" || { ko "faltas não detectadas"; [ "$VERBOSE" -eq 1 ] && cat "$TMP/vv5.out"; }

"$SCRIPTS/validate-vault.sh" --partial "$TMP/vv-missing" > "$TMP/vv6.out"
grep -q 'núcleo ausente' "$TMP/vv6.out" && ko "--partial não deveria exigir núcleo" || ok "--partial não exige arquivos núcleo"

# =========================================================================== E
section "E. Multi-LLM e handoff (cenários 13 e 14)"

EX="$SKILL/examples/bootstrapped-project"
[ "$(head -1 "$EX/CLAUDE.md")" = "@AGENTS.md" ] && ok "CLAUDE.md importa AGENTS.md na 1ª linha" || ko "CLAUDE.md não importa AGENTS.md"
grep -q 'Regras inegociáveis' "$EX/CLAUDE.md" && ko "CLAUDE.md duplica regras do AGENTS.md" || ok "CLAUDE.md não duplica regras"
for f in .ai/HANDOFF.md vault/00_HOME/START_HERE.md vault/05_STATE/CURRENT_STATE.md vault/05_STATE/NEXT_ACTION.md vault/02_BUSINESS/BUSINESS_RULES.md vault/04_DEVELOPMENT/AI_WORKFLOW.md; do
  grep -qF "$f" "$EX/AGENTS.md" || ko "AGENTS.md não inclui $f na ordem de leitura"
done && ok "AGENTS.md define a ordem de leitura completa"
[ "$(wc -l < "$EX/.ai/HANDOFF.md" | tr -d ' ')" -le 60 ] && ok "HANDOFF ≤ 60 linhas" || ko "HANDOFF longo"
grep -q '^READ_FIRST:' "$EX/.ai/HANDOFF.md" && ok "HANDOFF indica por onde começar" || ko "HANDOFF sem READ_FIRST"
for vendor in Claude Codex; do
  grep -rqi "^#.*$vendor" "$EX/vault" && ko "Vault contém seção específica de $vendor (deve ser neutro)"
done; ok "Vault sem seções específicas de fornecedor"

# =========================================================================== resumo
echo
echo "RESULTADO: $PASS ok, $FAIL falha(s)"
[ "$FAIL" -eq 0 ] || exit 1
[ "${KEEP_TMP:-0}" = "1" ] || rm -rf "$TMP"
