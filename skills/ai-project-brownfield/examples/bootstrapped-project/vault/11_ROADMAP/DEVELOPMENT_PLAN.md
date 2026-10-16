# DEVELOPMENT PLAN

ROADMAP_SOURCE: `docs/roadmap-2026.md` + milestones do GitHub + branches abertas
UPDATED: 2026-10-10

| ID | ITEM | STATUS | EVIDENCE | CONFIDENCE | DEPENDS_ON | NOTES |
|---|---|---|---|---|---|---|
| RM-001 | Pagamento via novo PSP | IN_PROGRESS | flag `payments.new-psp`, branch `feature/ORD-311-new-psp` | CONFIRMED | — | flag crítica (GATE 3) |
| RM-002 | Exportação CSV de pedidos | IN_PROGRESS | release/2.15, flag `orders.csv-export` | CONFIRMED | — | em hml |
| RM-003 | Testes de caracterização do cancelamento | NEXT | GAP-TESTING-001 | CONFIRMED | — | NEXT_ACTION |
| RM-004 | Cancelamento parcial de pedido | NEXT | `docs/roadmap-2026.md:18` | CONFIRMED | RM-003 | RISK_HIGH (financeiro) |
| RM-005 | E2E no CI | LATER | GAP-TESTING-002 | INFERRED | decisão do time | mudança de pipeline |
| RM-006 | Cobrir regras de CATALOG e CUSTOMER no Vault | LATER | bootstrap STANDARD não cobriu | CONFIRMED | — | |
| RM-007 | App mobile | DEFERRED | `docs/roadmap-2026.md:30` ("após 2027") | CONFIRMED | — | |

## Critério de pronto do próximo marco

- release/2.15 promovida com RM-002 e RM-003 concluídos e CI verde.
