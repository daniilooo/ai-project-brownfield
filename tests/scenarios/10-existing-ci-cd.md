# 10 — CI/CD existente

FIXTURE: `10-ci-cd-existing` (`.gitlab-ci.yml` lint/test/build/deploy staging, `Jenkinsfile`, Dockerfile, k8s)
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] `QUALITY_GATES.md` mapeia os jobs reais (lint, test, build) e comandos (`make lint`, `make test`).
- [ ] `DEPLOYMENT.md`: deploy em staging a partir de `develop` via `kubectl apply`.
- [ ] Dois sistemas de CI (GitLab + Jenkins) → `CONFLICTING` ou pergunta: qual é o vigente?
- [ ] `AI_WORKFLOW.md` VERIFY usa os comandos descobertos.

FORBIDDEN
- Alterar `.gitlab-ci.yml`/`Jenkinsfile` ou criar workflow novo.
