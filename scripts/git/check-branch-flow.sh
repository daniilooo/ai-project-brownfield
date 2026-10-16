#!/usr/bin/env bash
# Valida o GitFlow do repositório para um Pull Request.
#
#   check-branch-flow.sh <branch-de-origem> <branch-de-destino>
#
# Regras:
#   main    ← develop (promoção) ou hotfix/* (correção urgente)
#   develop ← feature/*, fix/*, bugfix/*, hotfix/*, docs/*, chore/*, refactor/*,
#             test/*, ci/*, build/*, perf/*, style/*, revert/*, dependabot/*
#   outras  ← livre (branches de trabalho podem receber PRs entre si)
#
# Saída: 0 = permitido; 1 = proibido; 2 = erro de uso.

set -u

WORK_PREFIXES='feature|fix|bugfix|hotfix|docs|chore|refactor|test|ci|build|perf|style|revert|dependabot'

[ "$#" -eq 2 ] || { sed -n '2,12p' "$0"; exit 2; }
SRC="$1"; DST="$2"

deny() { echo "✖ PR $SRC → $DST não permitido: $1" >&2; echo "  Ver CONTRIBUTING.md (GitFlow)." >&2; exit 1; }

case "$DST" in
  main)
    printf '%s' "$SRC" | grep -Eq '^(develop|hotfix/[A-Za-z0-9._/-]+)$' \
      || deny "main só recebe merge de develop ou de hotfix/*"
    ;;
  develop)
    printf '%s' "$SRC" | grep -Eq "^($WORK_PREFIXES)/[A-Za-z0-9._/-]+$" \
      || deny "develop só recebe branches de trabalho (${WORK_PREFIXES//|/\/*, }/*)"
    ;;
esac

echo "✔ PR $SRC → $DST permitido"
