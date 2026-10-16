# START HERE — Orderly

**O que é:** plataforma B2B de gestão de pedidos: clientes empresariais criam pedidos, pagam e
acompanham entrega.
**Estado:** em produção (v2.14.0); desenvolvimento contínuo em `develop` → [CURRENT_STATE](../05_STATE/CURRENT_STATE.md)
**Próxima ação:** teste de caracterização do cancelamento de pedido → [NEXT_ACTION](../05_STATE/NEXT_ACTION.md)
**Produção:** `PRODUCTION_SAFETY_MODE: ON`

## Ordem de leitura para um novo executor

1. [CURRENT_STATE](../05_STATE/CURRENT_STATE.md)
2. [NEXT_ACTION](../05_STATE/NEXT_ACTION.md)
3. [BUSINESS_RULES](../02_BUSINESS/BUSINESS_RULES.md) — domínios tocados
4. [AI_WORKFLOW](../04_DEVELOPMENT/AI_WORKFLOW.md)

## Mapa do Vault

| Pergunta | Onde |
|---|---|
| Onde está cada repo/módulo? | [PROJECT_MAP](PROJECT_MAP.md) |
| Quais regras não posso quebrar? | [BUSINESS_RULES](../02_BUSINESS/BUSINESS_RULES.md), [STATES_AND_TRANSITIONS](../02_BUSINESS/STATES_AND_TRANSITIONS.md) |
| Como o sistema é construído? | [SYSTEM_ARCHITECTURE](../03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md) |
| Como trabalhar (risco, gates)? | [AI_WORKFLOW](../04_DEVELOPMENT/AI_WORKFLOW.md) |
| Como funciona o Git aqui? | [GITFLOW](../04_DEVELOPMENT/GITFLOW.md) |
| Como testar? | [TEST_STRATEGY](../04_DEVELOPMENT/TEST_STRATEGY.md) |
| Ambientes e flags | [ENVIRONMENTS](../06_OPERATIONS/ENVIRONMENTS.md), [FEATURE_FLAGS](../06_OPERATIONS/FEATURE_FLAGS.md) |
| O que falta / está em conflito? | [GAP_ANALYSIS](../05_STATE/GAP_ANALYSIS.md), [OPEN_DECISIONS](../05_STATE/OPEN_DECISIONS.md) |
| Para onde vamos? | [DEVELOPMENT_PLAN](../11_ROADMAP/DEVELOPMENT_PLAN.md) |

## Documentação pré-existente (fora do Vault)

| Documento | Conteúdo | Confiança / divergências |
|---|---|---|
| `orderly-api/README.md` | setup local | CONFLICTING: cita MySQL; código usa PostgreSQL (DEC-002) |
| `orderly-api/docs/adr/` | 4 ADRs (0001–0004) | CONFIRMED; referenciados no local original (não copiados) |
| `orderly-api/docs/api/openapi.yaml` | contrato REST v2 | CONFIRMED (gerado no build) |

## Regras inegociáveis

- Gates humanos e produção: [AI_WORKFLOW §6–7](../04_DEVELOPMENT/AI_WORKFLOW.md)
- Sem segredos no Vault; somente nomes de variáveis.
