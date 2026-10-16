#!/usr/bin/env bash
# Cria ou atualiza no GitHub os rulesets versionados em .github/rulesets/*.json.
#
#   scripts/github/apply-rulesets.sh [owner/repo]
#
# Requer GitHub CLI autenticado (gh auth login) com permissão de administrador no
# repositório. Rulesets são aplicados em repositórios públicos em qualquer plano;
# em repositórios privados exigem GitHub Pro/Team/Enterprise.

set -eu

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
ROOT="$(git rev-parse --show-toplevel)"

for file in "$ROOT"/.github/rulesets/*.json; do
  name="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$file")"
  id="$(gh api "repos/$REPO/rulesets" --jq ".[] | select(.name == \"$name\") | .id")"
  if [ -n "$id" ]; then
    gh api --method PUT "repos/$REPO/rulesets/$id" --input "$file" >/dev/null
    echo "atualizado: $name (#$id)"
  else
    gh api --method POST "repos/$REPO/rulesets" --input "$file" >/dev/null
    echo "criado:     $name"
  fi
done
