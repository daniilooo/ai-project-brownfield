#!/usr/bin/env bash
# Ativa os hooks versionados em .githooks/ neste clone.
#   scripts/git/install-hooks.sh
set -eu
ROOT="$(git rev-parse --show-toplevel)"
git -C "$ROOT" config core.hooksPath .githooks
chmod +x "$ROOT"/.githooks/* "$ROOT"/scripts/git/*.sh
echo "Hooks ativados (core.hooksPath=.githooks):"
echo "  pre-commit  → bloqueia commit direto em main e develop"
echo "  commit-msg  → valida Conventional Commits"
