# NEXT ACTION

UPDATED: 2026-10-10 · ROADMAP_ITEM: RM-003 · RISK_LEVEL: RISK_LOW (somente testes)

## CURRENT_GOAL
Proteger BR-ORDER-002 com testes de caracterização do cancelamento de pedido.

## WHY
A regra só existe no código (INFERRED) e `OrderService` é o maior hotspot; RM-004 vai mexer no cancelamento.

## SCOPE
- Testes unitários de `OrderService.cancel` para todos os status de `OrderStatus`.

## OUT_OF_SCOPE
- Alterar o comportamento do cancelamento ou da regra.

## ACCEPTANCE_CRITERIA
- [ ] Um teste por status de origem documentando o comportamento atual.
- [ ] `./mvnw test` verde; nenhum arquivo de `src/main` alterado.
- [ ] BR-ORDER-002 aponta para o novo teste (continua INFERRED_RULE até DEC humana).

## RISKS
- Baixo: somente testes.

## AFFECTED_AREAS
- `orderly-api/src/test/.../order`; BR-ORDER-002.

## VALIDATION
- `./mvnw test`, `./mvnw spotless:check`.

## HUMAN_GATES
- GATE 1 implícito (RISK_LOW); GATE 2 resumo; GATE 3 para merge em develop.
