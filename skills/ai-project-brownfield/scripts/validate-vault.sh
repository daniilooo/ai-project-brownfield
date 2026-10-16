#!/usr/bin/env bash
# ai-project-brownfield — validate-vault.sh
#
# Valida o resultado do bootstrap no projeto alvo.
#
#   validate-vault.sh [--partial] [raiz]      (padrão: diretório atual)
#
# Verifica:
#   - arquivos núcleo do Vault presentes (exceto com --partial);
#   - nenhum arquivo do Vault vazio ou só com títulos;
#   - nenhum placeholder {{...}} ou marcador "<!-- TEMPLATE" remanescente;
#   - nenhum padrão óbvio de segredo;
#   - CURRENT_STATE.md (≤ 120 linhas) e NEXT_ACTION.md (≤ 80 linhas) com todas as seções;
#   - .ai/HANDOFF.md (se existir) ≤ 60 linhas e com todos os campos;
#   - AGENTS.md aponta para o Vault; CLAUDE.md (se existir) é fino e referencia AGENTS.md.
#
# Saída: 0 = OK; 1 = erros; 2 = erro de uso.

set -u
export LC_ALL=C

PARTIAL=0
ROOT="."
while [ "$#" -gt 0 ]; do
  case "$1" in
    --partial) PARTIAL=1; shift ;;
    -h|--help) sed -n '2,17p' "$0"; exit 0 ;;
    *) ROOT="$1"; shift ;;
  esac
done
cd "$ROOT" 2>/dev/null || { echo "ERRO: raiz inexistente: $ROOT" >&2; exit 2; }

MAX_STATE="${BROWNFIELD_MAX_STATE_LINES:-120}"
MAX_NEXT="${BROWNFIELD_MAX_NEXT_LINES:-80}"
MAX_HANDOFF="${BROWNFIELD_MAX_HANDOFF_LINES:-60}"
MAX_CLAUDE="${BROWNFIELD_MAX_CLAUDE_LINES:-40}"

CORE="vault/00_HOME/START_HERE.md
vault/00_HOME/PROJECT_MAP.md
vault/02_BUSINESS/BUSINESS_RULES.md
vault/03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md
vault/04_DEVELOPMENT/AI_WORKFLOW.md
vault/04_DEVELOPMENT/GITFLOW.md
vault/04_DEVELOPMENT/TEST_STRATEGY.md
vault/05_STATE/CURRENT_STATE.md
vault/05_STATE/NEXT_ACTION.md
vault/05_STATE/GAP_ANALYSIS.md
vault/05_STATE/TECHNICAL_DEBT.md
vault/05_STATE/KNOWN_RISKS.md
vault/05_STATE/OPEN_DECISIONS.md
vault/11_ROADMAP/DEVELOPMENT_PLAN.md"

STATE_KEYS="PROJECT ARCHITECTURE REPOSITORIES CURRENT_BRANCHES CURRENT_RELEASE ENVIRONMENTS PRODUCTION_STATUS COMPLETED IN_PROGRESS BLOCKERS IMPORTANT_DEBT RISKS NEXT_ACTION"
NEXT_KEYS="CURRENT_GOAL WHY SCOPE OUT_OF_SCOPE ACCEPTANCE_CRITERIA RISKS AFFECTED_AREAS VALIDATION HUMAN_GATES"
HANDOFF_KEYS="PROJECT CURRENT_STATE CURRENT_BRANCH CURRENT_GOAL LAST_COMPLETED_ACTION NEXT_ACTION BLOCKERS RISKS HUMAN_DECISIONS_PENDING"

errors=0
warns=0
err()  { echo "ERROR: $*"; errors=$((errors + 1)); }
warn() { echo "WARN:  $*"; warns=$((warns + 1)); }

has_key() { # $1 arquivo ; $2 chave -> heading "## KEY" ou linha "KEY:"
  grep -Eq "^#{1,6}[[:space:]]+$2([[:space:]]|$)|^$2:" "$1"
}

lines() { wc -l < "$1" | tr -d ' '; }

echo "# VALIDATE VAULT — ai-project-brownfield"

if [ ! -d vault ]; then
  err "diretório vault/ não encontrado"
  echo "RESULT: FAIL — $errors erro(s)"; exit 1
fi

if [ "$PARTIAL" -eq 0 ]; then
  for f in $CORE; do [ -f "$f" ] || err "arquivo núcleo ausente: $f"; done
  [ -f AGENTS.md ] || err "AGENTS.md ausente (adapter neutro)"
fi

# Conteúdo de todos os .md do Vault
find vault -type f -name '*.md' | sort > "${TMPDIR:-/tmp}/bf-vault.$$"
while IFS= read -r f; do
  # Conta linhas de conteúdo real: ignora títulos, comentários, separadores de tabela,
  # linhas de tabela com células vazias e cabeçalhos de tabela.
  body=$(awk '
    { l[NR] = $0 }
    END {
      n = 0
      for (i = 1; i <= NR; i++) {
        x = l[i]
        if (x ~ /^[[:space:]]*$/ || x ~ /^[[:space:]]*#/ || x ~ /^[[:space:]]*<!--.*-->[[:space:]]*$/) continue
        if (x ~ /^[|: -]+$/ || x ~ /^\|([[:space:]]*\|)+[[:space:]]*$/) continue
        if (x ~ /^\|/ && i < NR && l[i + 1] ~ /^[|: -]+$/) continue
        n++
      }
      print n
    }' "$f")
  [ "$body" -eq 0 ] && err "arquivo vazio ou só com títulos (não crie arquivo para cumprir template): $f"
done < "${TMPDIR:-/tmp}/bf-vault.$$"

SCAN_LIST="$(cat "${TMPDIR:-/tmp}/bf-vault.$$"; for f in AGENTS.md CLAUDE.md .ai/HANDOFF.md; do [ -f "$f" ] && echo "$f"; done)"
rm -f "${TMPDIR:-/tmp}/bf-vault.$$"

echo "$SCAN_LIST" | while IFS= read -r f; do
  [ -z "$f" ] && continue
  grep -n '{{' "$f" | head -n 3 | sed "s#^#PLACEHOLDER $f:#"
  grep -n '<!-- TEMPLATE' "$f" | head -n 3 | sed "s#^#TEMPLATE_MARKER $f:#"
  grep -nE 'AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[0-9A-Za-z-]{10,}|gh[pousr]_[0-9A-Za-z]{30,}|://[^/[:space:]:@]+:[^/[:space:]@]+@' "$f" | head -n 3 | sed -E "s#^([0-9]+):.*#SECRET $f:\1 (valor omitido)#"
  grep -niE '(password|passwd|senha|secret|token|api[_-]?key)[[:space:]]*[:=][[:space:]]*["'\'']?[A-Za-z0-9/+_.-]{8,}' "$f" \
    | grep -viE '[:=][[:space:]]*["'\'']?(\$\{|<|\*{3}|xxx|changeme|example|placeholder|UNKNOWN|NONE|N/A)' \
    | head -n 3 | sed -E "s#^([0-9]+):.*#SECRET $f:\1 (valor omitido)#"
done > "${TMPDIR:-/tmp}/bf-scan.$$"
while IFS= read -r line; do err "$line"; done < "${TMPDIR:-/tmp}/bf-scan.$$"
rm -f "${TMPDIR:-/tmp}/bf-scan.$$"

f=vault/05_STATE/CURRENT_STATE.md
if [ -f "$f" ]; then
  [ "$(lines "$f")" -le "$MAX_STATE" ] || err "$f tem $(lines "$f") linhas (máx. $MAX_STATE): mantenha curto"
  for k in $STATE_KEYS; do has_key "$f" "$k" || err "$f sem seção $k"; done
  grep -q 'PRODUCTION_SAFETY_MODE' "$f" || err "$f não declara PRODUCTION_SAFETY_MODE"
fi

f=vault/05_STATE/NEXT_ACTION.md
if [ -f "$f" ]; then
  [ "$(lines "$f")" -le "$MAX_NEXT" ] || err "$f tem $(lines "$f") linhas (máx. $MAX_NEXT)"
  for k in $NEXT_KEYS; do has_key "$f" "$k" || err "$f sem seção $k"; done
  n=$(grep -cE '^#{1,6}[[:space:]]+CURRENT_GOAL' "$f" || true)
  [ "$n" -le 1 ] || err "$f tem $n CURRENT_GOAL: NEXT_ACTION representa UMA ação"
  grep -qE 'RISK_(LOW|MEDIUM|HIGH)' "$f" || warn "$f sem RISK_LEVEL (RISK_LOW|RISK_MEDIUM|RISK_HIGH)"
fi

f=.ai/HANDOFF.md
if [ -f "$f" ]; then
  [ "$(lines "$f")" -le "$MAX_HANDOFF" ] || err "$f tem $(lines "$f") linhas (máx. $MAX_HANDOFF): handoff deve ser curto"
  for k in $HANDOFF_KEYS; do has_key "$f" "$k" || err "$f sem campo $k"; done
elif [ "$PARTIAL" -eq 0 ]; then
  warn ".ai/HANDOFF.md ausente"
fi

if [ -f AGENTS.md ]; then
  grep -q 'vault/00_HOME/START_HERE.md' AGENTS.md || err "AGENTS.md não aponta para vault/00_HOME/START_HERE.md"
  grep -q 'AI_WORKFLOW' AGENTS.md || err "AGENTS.md não aponta para AI_WORKFLOW"
fi
if [ -f CLAUDE.md ]; then
  grep -q 'AGENTS.md' CLAUDE.md || err "CLAUDE.md não importa/referencia AGENTS.md (evite regras duplicadas)"
  [ "$(lines CLAUDE.md)" -le "$MAX_CLAUDE" ] || warn "CLAUDE.md tem $(lines CLAUDE.md) linhas: adapter deve ser fino"
fi

if grep -RqE 'CONFIRMED|INFERRED|CONFLICTING|UNKNOWN' vault 2>/dev/null; then :; else
  warn "nenhum marcador de confiança (CONFIRMED/INFERRED/CONFLICTING/UNKNOWN) no Vault"
fi

if [ "$errors" -gt 0 ]; then
  echo "RESULT: FAIL — $errors erro(s), $warns aviso(s)"
  exit 1
fi
echo "RESULT: OK — $warns aviso(s)"
