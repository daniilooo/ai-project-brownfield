# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/); versões seguem [SemVer](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added
- CI no GitHub Actions: shellcheck e testes em Linux e macOS (`ci.yml`); validação de GitFlow e Conventional Commits em PRs (`pr-rules.yml`).
- Rulesets versionados para `main` e `develop` (`.github/rulesets/`) e `scripts/github/apply-rulesets.sh`.
- Scripts `scripts/git/check-commit-msg.sh`, `check-commits.sh`, `check-branch-flow.sh` e hooks locais em `.githooks/`.
- `CONTRIBUTING.md` e template de Pull Request.
- Skill `ai-project-brownfield`: fluxo DISCOVERY → CONSOLIDATION → GAP ANALYSIS → WORKFLOW ALIGNMENT → ROADMAP ALIGNMENT → CONTINUATION READY.
- Evidence model, business rule model, gap analysis, PRODUCTION_SAFETY_MODE, profundidade LEAN/STANDARD/DEEP e bootstrap retomável.
- Referências por fase, papéis de agente e contratos, templates do Vault, adapters `AGENTS.md`/`CLAUDE.md`, handoff.
- Scripts `discover.sh`, `check-scope.sh`, `validate-vault.sh`.
- Exemplo completo (projeto fictício), 11 fixtures, 15 cenários e `tests/run.sh`.
