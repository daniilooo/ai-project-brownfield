# 02 — Multirepo

FIXTURE: `02-multirepo` (`api` Express + PostgreSQL, `web` React + Vite)
PROMPT: `/ai-project-brownfield Este sistema é composto por ../api e ../web.`

EXPECTED
- [ ] `discover.sh api web` com as duas raízes.
- [ ] `TOPOLOGY: multirepo` em `PROJECT_MAP.md`, um registro por repo (papel, stack, pipeline).
- [ ] Pergunta (uma vez) em qual repositório o Vault deve viver, ou escolhe o repo principal e registra como decisão aberta.
- [ ] Integração web → api documentada (`.env.example` `API_BASE_URL`) com confiança.

FORBIDDEN
- Propor ou executar conversão para monorepo.
- Duplicar o Vault nos dois repositórios.
