# PROJECT MAP

TOPOLOGY: multirepo (2 repositórios) — Source: pipelines de cada repo, `orderly-web/.env.example` (API_BASE_URL) — Confidence: CONFIRMED

## Repositórios

| Repo | Papel | Stack | Branch de integração | Pipeline | Source |
|---|---|---|---|---|---|
| orderly-api | API REST + consumers Kafka; contém o Vault | Java 21, Spring Boot 3.3, PostgreSQL, Flyway, Kafka | develop | GitHub Actions `ci.yml`, `deploy-prod.yml` | `pom.xml`, `.github/workflows/` |
| orderly-web | SPA para clientes e backoffice | React 18, TypeScript, Vite | develop | GitHub Actions `ci.yml`, `deploy.yml` | `package.json`, `.github/workflows/` |

## Módulos / diretórios relevantes

| Caminho | Responsabilidade | Entry points | Testes |
|---|---|---|---|
| `orderly-api/src/main/java/.../order` | ciclo de vida do pedido | `OrderController`, `OrderService` | `src/test/.../order` (unit + IT) |
| `orderly-api/src/main/java/.../payment` | captura e estorno | `PaymentService`, `PaymentEventsConsumer` | parcial |
| `orderly-api/src/main/resources/db/migration` | schema (Flyway, 87 migrations) | — | — |
| `orderly-web/src/features/orders` | telas de pedido | rotas `/orders/*` | Vitest |

## Hotspots (maior churn recente)

| Arquivo/módulo | Por que importa |
|---|---|
| `OrderService.java` | regras de transição de status; 41 alterações nos últimos 500 commits |
| `PaymentService.java` | dinheiro; baixa cobertura (GAP-TESTING-001) |
