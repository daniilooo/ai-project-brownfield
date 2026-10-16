#!/usr/bin/env bash
# Valida uma mensagem de commit no padrão Conventional Commits 1.0.0.
#
#   check-commit-msg.sh <arquivo-da-mensagem>     (uso pelo hook commit-msg)
#   check-commit-msg.sh -m "<mensagem>"           (uso pelo CI e por check-commits.sh)
#
# Formato do cabeçalho:  <tipo>[(escopo)][!]: <descrição>
# Tipos aceitos:          feat fix docs style refactor perf test build ci chore revert
# Limite do cabeçalho:    100 caracteres
# Aceitos sem validação:  mensagens geradas pelo Git ("Merge ...", "Revert \"...\"")
#                         e commits fixup!/squash! (serão reescritos antes do merge).
#
# Saída: 0 = válida; 1 = inválida; 2 = erro de uso.

set -u

TYPES='feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert'
MAX_HEADER=100

case "${1:-}" in
  -m) MSG="${2:-}" ;;
  -h|--help|"") sed -n '2,13p' "$0"; [ -z "${1:-}" ] && exit 2; exit 0 ;;
  *) [ -f "$1" ] || { echo "ERRO: arquivo não encontrado: $1" >&2; exit 2; }; MSG="$(cat "$1")" ;;
esac

# Primeira linha que não é comentário do Git
HEADER="$(printf '%s\n' "$MSG" | grep -v '^#' | grep -m1 . || true)"

if printf '%s' "$HEADER" | grep -Eq '^(Merge |Revert ")|^(fixup|squash|amend)! '; then
  exit 0
fi

fail() {
  echo "✖ Mensagem de commit inválida: $1" >&2
  echo "  Cabeçalho: \"$HEADER\"" >&2
  echo "  Formato:   <tipo>[(escopo)][!]: <descrição>" >&2
  echo "  Tipos:     ${TYPES//|/, }" >&2
  echo "  Exemplos:  feat(skill): add discovery wave support" >&2
  echo "             fix(scripts)!: change check-scope exit codes" >&2
  echo "  Ver CONTRIBUTING.md." >&2
  exit 1
}

[ -n "$HEADER" ] || fail "mensagem vazia"
[ "${#HEADER}" -le "$MAX_HEADER" ] || fail "cabeçalho com ${#HEADER} caracteres (máx. $MAX_HEADER)"
printf '%s' "$HEADER" | grep -Eq "^($TYPES)(\([a-z0-9._/-]+\))?!?: [^[:space:]].*$" \
  || fail "não segue Conventional Commits"
printf '%s' "$HEADER" | grep -Eq '\.$' && fail "a descrição não deve terminar com ponto"

# Linha 2, se existir, deve ser vazia (separa cabeçalho do corpo)
SECOND="$(printf '%s\n' "$MSG" | grep -v '^#' | sed -n '2p')"
[ -z "$SECOND" ] || fail "deixe uma linha em branco entre o cabeçalho e o corpo"

exit 0
