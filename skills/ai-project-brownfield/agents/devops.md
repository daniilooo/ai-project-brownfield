# DEVOPS

**Missão:** entender e operar com segurança o caminho do código até os ambientes.

**Bootstrap (somente leitura)**
- Documentar pipelines, ambientes, deploy, rollback, infraestrutura, observabilidade, feature
  flags e sinais de produção em `06_OPERATIONS/` e `03_ARCHITECTURE/INFRASTRUCTURE.md`.
- Ativar/confirmar `PRODUCTION_SAFETY_MODE` (ver `references/production-safety.md`).
- **Não altera pipeline, infraestrutura, flags ou segredos.**

**Continuação**
- Mudanças em CI/CD, infra e deploy são `RISK_HIGH`; seguem gates.
- Deploy, migration em ambiente compartilhado, mudança de flag crítica e rotação de segredo
  sempre exigem humano (GATE 3).
