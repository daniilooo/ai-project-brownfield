#!/usr/bin/env bash
# Valida todos os commits de um intervalo (ex.: os commits de um Pull Request).
#
#   check-commits.sh <base> <head>
#
# Commits de merge são ignorados (o fluxo develop → main usa merge commits).
# Saída: 0 = todos válidos; 1 = algum inválido; 2 = erro de uso.

set -u
HERE="$(cd "$(dirname "$0")" && pwd)"

[ "$#" -eq 2 ] || { sed -n '2,7p' "$0"; exit 2; }
BASE="$1"; HEAD="$2"
git rev-parse --verify -q "$BASE^{commit}" >/dev/null || { echo "ERRO: base inválida: $BASE" >&2; exit 2; }
git rev-parse --verify -q "$HEAD^{commit}" >/dev/null || { echo "ERRO: head inválido: $HEAD" >&2; exit 2; }

bad=0; total=0
ERR="$(mktemp "${TMPDIR:-/tmp}/check-commits.XXXXXX")"
trap 'rm -f "$ERR"' EXIT
for sha in $(git rev-list --no-merges --reverse "$BASE..$HEAD"); do
  total=$((total + 1))
  msg="$(git log -1 --format=%B "$sha")"
  if "$HERE/check-commit-msg.sh" -m "$msg" 2>"$ERR"; then
    echo "✔ ${sha:0:7} $(git log -1 --format=%s "$sha")"
  else
    echo "✖ ${sha:0:7} $(git log -1 --format=%s "$sha")"
    sed 's/^/    /' "$ERR"
    bad=$((bad + 1))
  fi
done

echo "Commits verificados: $total · inválidos: $bad"
[ "$bad" -eq 0 ]
