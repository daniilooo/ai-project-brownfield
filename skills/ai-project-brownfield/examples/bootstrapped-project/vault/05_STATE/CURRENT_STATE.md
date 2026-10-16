# CURRENT STATE

UPDATED: 2026-10-10 by Claude Code (bootstrap ai-project-brownfield)

## PROJECT
Orderly — plataforma B2B de gestão de pedidos.

## ARCHITECTURE
Monolito em camadas (Spring Boot 3, PostgreSQL, Kafka) + SPA React → [SYSTEM_ARCHITECTURE](../03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md)

## REPOSITORIES
orderly-api (Vault), orderly-web → [PROJECT_MAP](../00_HOME/PROJECT_MAP.md)

## CURRENT_BRANCHES
develop (integração) · release/2.15 (estabilização em hml) · docs/ai-brownfield-bootstrap (este bootstrap)

## CURRENT_RELEASE
v2.14.0 (2026-09-28) em produção

## ENVIRONMENTS
dev, hml, prod → [ENVIRONMENTS](../06_OPERATIONS/ENVIRONMENTS.md)

## PRODUCTION_STATUS
PRODUCTION_SAFETY_MODE: ON · EVIDENCE: `deploy-prod.yml`, `values-prod.yaml`, tags v2.x · CONFIDENCE: CONFIRMED

## COMPLETED
- Bootstrap brownfield (Vault núcleo, workflow, GitFlow, gaps, roadmap, adapters).

## IN_PROGRESS
- release/2.15: exportação CSV de pedidos (RM-002) — flag `orders.csv-export` desligada.

## BLOCKERS
- Nenhum.

## IMPORTANT_DEBT
- TD-001 Pagamentos com baixa cobertura · TD-002 `PaymentController` acessa repository → [TECHNICAL_DEBT](TECHNICAL_DEBT.md)

## RISKS
- RISK-001 Regressão no cancelamento (regra sem teste) · RISK-002 Estorno com prazo divergente → [KNOWN_RISKS](KNOWN_RISKS.md)

## NEXT_ACTION
Teste de caracterização do cancelamento (BR-ORDER-002) → [NEXT_ACTION](NEXT_ACTION.md)
