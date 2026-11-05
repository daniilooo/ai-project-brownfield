# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/); versões seguem [SemVer](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added
- Modo `REFRESH` (`references/refresh.md`): ressincroniza um Vault existente pelo drift desde a `BASELINE_COMMIT`, reverificando só as afirmações afetadas.
- `scripts/check-evidence.sh`: verifica se arquivos, linhas e links citados no Vault existem e aponta `STALE`/`UNCOVERED` desde a baseline (`--since`, `--strict`, multirepo).
- `validate-vault.sh` valida o evidence model: `CONFIDENCE` com valor permitido e `CONFIRMED` sempre com `SOURCE`.
- `BASELINE_COMMIT` e `Refresh log` em `.ai/BOOTSTRAP_STATUS.md`; cenário 16 (refresh) e suíte G em `tests/run.sh`.

### Changed
- `description` da skill cobre refresh e explicita quando **não** usar (features, bugs, dúvidas pontuais).
- `SKILL.md`: tabela de modos `NEW`/`CONSOLIDATE`/`REFRESH`, critério de saída nas fases 1–4, `check-evidence.sh` na FASE 10 e `HOW_TO_CONTINUE` reescrito.

### Changed
- GitFlow: `hotfix/*` pode abrir PR direto para `main` (correção urgente), com sincronização obrigatória de volta para `develop`.

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
