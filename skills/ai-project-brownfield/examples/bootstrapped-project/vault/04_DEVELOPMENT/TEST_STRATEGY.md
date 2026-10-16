# TEST STRATEGY

## Inventário

| Tipo | Existe? | Onde | Comando | Source | Confidence |
|---|---|---|---|---|---|
| unit | sim | `orderly-api/src/test`, `orderly-web/src/**/*.test.tsx` | `./mvnw test`, `npm test` | ci.yml | CONFIRMED |
| integration | sim | `*IT.java` (Testcontainers PostgreSQL/Kafka) | `./mvnw verify` | `pom.xml:95` | CONFIRMED |
| contract | não | — | — | busca por pact/contract | CONFIRMED (ausente) |
| e2e | parcial | `orderly-web/e2e` (Playwright, 6 cenários) | `npm run e2e` | `package.json` | CONFIRMED; não roda no CI (GAP-TESTING-002) |
| migration | implícito | Flyway aplicado nos IT | `./mvnw verify` | IT | INFERRED |
| security | não | — | — | — | UNKNOWN |
| performance | não | — | — | — | UNKNOWN |

Cobertura: JaCoCo 64% linhas (relatório do CI) — informação secundária.

## Fluxos e invariantes críticos × proteção

| Fluxo / Regra (ID) | Protegido por | Lacuna |
|---|---|---|
| BR-ORDER-001 total | `OrderTotalTest` | — |
| BR-ORDER-002 cancelamento | nenhum teste | GAP-TESTING-001 |
| BR-ORDER-004 isolamento por empresa | `OrderSecurityIT` | — |
| BR-PAY-002 idempotência | `PaymentIdempotencyTest` | sem IT com Kafka real |

## Estratégia para novas mudanças

- Regra BR-* alterada ou tocada exige teste no service de domínio.
- Repositórios e consumers: IT com Testcontainers.
