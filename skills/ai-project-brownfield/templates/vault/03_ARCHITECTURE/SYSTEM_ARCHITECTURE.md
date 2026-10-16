# SYSTEM ARCHITECTURE

<!-- TEMPLATE: núcleo. Arquitetura COMO ELA É. Cada afirmação com Source/Confidence. -->

## CURRENT_ARCHITECTURE

{{estilo real}} — Source: {{...}} — Confidence: {{...}}
Onde o estilo é respeitado / violado: {{...}}

```mermaid
flowchart LR
  user([Usuário]) --> app[{{aplicação}}]
  app --> db[({{banco}})]
```

## MODULES

| Módulo | Responsabilidade | Depende de | Source |
|---|---|---|---|

## BOUNDARIES

| Regra observada | Violações conhecidas | Source | Confidence |
|---|---|---|---|

## DEPENDENCIES

| Dependência | Versão | Uso | Source |
|---|---|---|---|

## DATA_FLOW

<!-- TEMPLATE: 1–3 fluxos críticos em sequenceDiagram. -->

## INTEGRATIONS

Resumo; detalhes em [INTEGRATIONS](INTEGRATIONS.md) quando existir.

## SECURITY_BOUNDARIES

Resumo; detalhes em [SECURITY](SECURITY.md) quando existir.

## DEPLOYMENT_MODEL

Resumo; detalhes em [INFRASTRUCTURE](INFRASTRUCTURE.md) e `../06_OPERATIONS/` quando existirem.
