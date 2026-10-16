# GAP ANALYSIS

UPDATED: 2026-10-10

## Resumo

| Severity | Qtd |
|---|---|
| CRITICAL | 0 |
| HIGH | 2 |
| MEDIUM | 2 |
| LOW | 1 |
| INFO | 0 |

### GAP-TESTING-001 — Cancelamento de pedido sem teste
DESCRIPTION: BR-ORDER-002 implementada sem teste nem documentação.
EVIDENCE: `OrderService.java:142`; nenhuma referência em `src/test`.
IMPACT: regressão silenciosa em fluxo financeiro.
SEVERITY: HIGH
RECOMMENDATION: testes de caracterização (NEXT_ACTION).
HUMAN_DECISION_REQUIRED: no

### GAP-BUSINESS_RULE-001 — Prazo de estorno divergente
DESCRIPTION: código usa 72h; FAQ de suporte diz 7 dias.
EVIDENCE: `PaymentService.java:88`; `docs/faq-suporte.md:5`.
IMPACT: atendimento promete o que o sistema recusa.
SEVERITY: HIGH
RECOMMENDATION: decisão de produto sobre o prazo correto.
HUMAN_DECISION_REQUIRED: yes (DEC-001)

### GAP-DOCUMENTATION-001 — README cita MySQL
DESCRIPTION: README de setup descreve MySQL; compose e configs usam PostgreSQL.
EVIDENCE: `README.md:30`; `docker-compose.yml:12`; `application.yml:8`.
IMPACT: onboarding confuso; LLM pode sugerir dialeto errado.
SEVERITY: MEDIUM
RECOMMENDATION: corrigir README (fora do bootstrap: arquivo de produto).
HUMAN_DECISION_REQUIRED: yes (DEC-002)

### GAP-TESTING-002 — E2E fora do CI
DESCRIPTION: 6 cenários Playwright existem mas não rodam em pipeline.
EVIDENCE: `orderly-web/e2e/`; ausência em `ci.yml`.
IMPACT: regressões de UI só detectadas em hml.
SEVERITY: MEDIUM
RECOMMENDATION: job opcional no CI (mudança de pipeline = RISK_HIGH, fora do bootstrap).
HUMAN_DECISION_REQUIRED: yes

### GAP-ARCHITECTURE-001 — Controller acessa repository
DESCRIPTION: `PaymentController` viola fronteira de ADR-0002.
EVIDENCE: `PaymentController.java:27`.
IMPACT: lógica de pagamento fora do service.
SEVERITY: LOW
RECOMMENDATION: mover para `PaymentService` quando o módulo for tocado.
HUMAN_DECISION_REQUIRED: no
