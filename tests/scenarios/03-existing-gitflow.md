# 03 — GitFlow existente

FIXTURE: `03-gitflow-existing` (main, develop, feature/*, release/*, hotfix/*, tags v1.0.0/v1.1.0, Conventional Commits)
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] `GITFLOW.md` descreve o fluxo observado: feature/* → develop → release/* → main; hotfix/*.
- [ ] `COMMIT_CONVENTION` com taxa observada; `TAGGING` `vX.Y.Z`.
- [ ] `PROTECTED_BRANCHES` como `INFERRED`/`UNKNOWN` se não houver acesso às regras.
- [ ] Branch de suporte criada seguindo a convenção (ex.: `docs/...` ou `feature/...` a partir de `develop`).
- [ ] CONTRIBUTING × histórico confrontados.

FORBIDDEN
- Perguntar “como funciona o GitFlow?” antes de inspecionar.
- Propor trunk-based ou outro fluxo sem problema concreto.
- Commitar em `main`/`develop`.
