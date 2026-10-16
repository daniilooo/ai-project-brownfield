#!/usr/bin/env bash
# ai-project-brownfield — check-scope.sh
#
# Verifica que o bootstrap alterou SOMENTE material de suporte ao desenvolvimento.
#
#   check-scope.sh [--base <ref>] [raiz]      (padrão: diretório atual)
#
# Considera: commits da branch atual desde a base (merge-base), alterações staged,
# não staged e arquivos não rastreados (respeitando .gitignore).
#
# Base: --base, ou $BROWNFIELD_BASE, ou a primeira existente entre origin/HEAD, main,
# master, develop, origin/main, origin/master, origin/develop. Sem base: só a working tree.
#
# Permitido (padrão): vault/ docs/ .ai/ .claude/ .agents/ .codex/ agents/ skills/
#                     AGENTS.md CLAUDE.md
# Extra: BROWNFIELD_ALLOW='<regex ERE>' (ex.: '^GEMINI\.md$|^\.cursor/').
# Sempre violação, mesmo em pasta permitida: arquivos de segredo (.env, *.pem, *.key, ...).
#
# Saída: 0 = OK; 1 = violação; 2 = erro de uso.

set -u
export LC_ALL=C

BASE="${BROWNFIELD_BASE:-}"
ROOT="."
while [ "$#" -gt 0 ]; do
  case "$1" in
    --base) BASE="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,21p' "$0"; exit 0 ;;
    *) ROOT="$1"; shift ;;
  esac
done

cd "$ROOT" 2>/dev/null || { echo "ERRO: raiz inexistente: $ROOT" >&2; exit 2; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "ERRO: $ROOT não é repositório Git" >&2; exit 2; }
cd "$(git rev-parse --show-toplevel)" || exit 2

ALLOW='^(vault|docs|\.ai|\.claude|\.agents|\.codex|agents|skills)/|^(AGENTS|CLAUDE)\.md$'
[ -n "${BROWNFIELD_ALLOW:-}" ] && ALLOW="$ALLOW|${BROWNFIELD_ALLOW}"
SECRET='(^|/)\.env(\.[^/]*)?$|\.(pem|key|p12|pfx|jks|keystore)$|(^|/)id_(rsa|dsa|ecdsa|ed25519)$'
SECRET_OK='\.(example|sample|template|dist)$'

if [ -z "$BASE" ]; then
  for c in origin/HEAD main master develop origin/main origin/master origin/develop; do
    if git rev-parse --verify -q "$c" >/dev/null; then BASE="$c"; break; fi
  done
fi

TMP="$(mktemp "${TMPDIR:-/tmp}/brownfield-scope.XXXXXX")"
DEL="$(mktemp "${TMPDIR:-/tmp}/brownfield-scope-del.XXXXXX")"
trap 'rm -f "$TMP" "$DEL"' EXIT

{
  if [ -n "$BASE" ]; then
    MB="$(git merge-base "$BASE" HEAD 2>/dev/null || true)"
    [ -n "$MB" ] && git diff --name-only "$MB" HEAD
  fi
  git diff --name-only --cached
  git diff --name-only
  git ls-files -o --exclude-standard
} 2>/dev/null | sort -u | grep . > "$TMP" || true

{
  if [ -n "$BASE" ] && [ -n "${MB:-}" ]; then git diff --name-only --diff-filter=D "$MB" HEAD; fi
  git diff --name-only --diff-filter=D --cached
  git diff --name-only --diff-filter=D
} 2>/dev/null | sort -u | grep . > "$DEL" || true

echo "# CHECK SCOPE — ai-project-brownfield"
echo "Base: ${BASE:-(nenhuma; apenas working tree)} · Arquivos alterados: $(grep -c . "$TMP" || true)"

violations=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if echo "$f" | grep -Eiq "$SECRET" && ! echo "$f" | grep -Eiq "$SECRET_OK"; then
    echo "VIOLATION (segredo): $f"; violations=$((violations + 1)); continue
  fi
  if ! echo "$f" | grep -Eq "$ALLOW"; then
    echo "VIOLATION (fora do escopo de suporte): $f"; violations=$((violations + 1)); continue
  fi
  case "$f" in
    .claude/settings*.json|.codex/*.toml) echo "WARN (revisar hooks/permissões): $f" ;;
  esac
done < "$TMP"

while IFS= read -r f; do
  [ -n "$f" ] && echo "WARN (arquivo removido; brownfield preserva documentação existente): $f"
done < "$DEL"

if [ "$violations" -gt 0 ]; then
  echo "RESULT: FAIL — $violations violação(ões). Reverta-as antes de declarar CONTINUATION READY."
  exit 1
fi
echo "RESULT: OK — somente material de suporte alterado."
