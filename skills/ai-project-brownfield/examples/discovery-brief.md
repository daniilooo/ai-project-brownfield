# DISCOVERY BRIEF — Orderly (exemplo)

PROJECT: Orderly — gestão de pedidos B2B
TOPOLOGY: multirepo (orderly-api, orderly-web) — preservado; Vault em orderly-api
STACK: Java 21 / Spring Boot 3.3 / PostgreSQL / Flyway / Kafka · React 18 / TS / Vite
ARCHITECTURE: monolito em camadas por domínio + SPA (ADR-0002) [CONFIRMED]
PRODUCTION_SAFETY_MODE: ON — `deploy-prod.yml`, `values-prod.yaml`, tags v2.x
DEPTH: STANDARD

TOP_FINDINGS
1. GitFlow existente: feature → develop → release → main, Conventional Commits (82%).
2. Unleash com 2 flags; `payments.new-psp` é crítica.
3. Testes fortes em pedidos/isolamento; fracos em pagamentos (31%).
4. E2E Playwright existe mas não roda no CI.
5. 4 ADRs válidos em `docs/adr/`.

CONFLICTS
- Banco: README diz MySQL × compose/config PostgreSQL → tratamos PostgreSQL como vigente [CONFIRMED pelo código], README como desatualizado.
- Prazo de estorno: código 72h × FAQ 7 dias.

TOP_GAPS
- GAP-TESTING-001 (HIGH) cancelamento sem teste · GAP-BUSINESS_RULE-001 (HIGH) estorno divergente
- GAP-DOCUMENTATION-001 (MEDIUM) README · GAP-TESTING-002 (MEDIUM) E2E fora do CI · GAP-ARCHITECTURE-001 (LOW)

QUESTIONS (bloqueantes; o bootstrap continua enquanto isso)
1. Prazo de estorno correto é 72h (código) ou 7 dias (FAQ)? Impacto: regra financeira BR-PAY-001.
2. Posso registrar o README como desatualizado e propor correção em PR separado? (o bootstrap não altera README)
3. Merge em develop: squash (CONTRIBUTING) ou merge commit (histórico)? Impacto: instruções de SHIP.
