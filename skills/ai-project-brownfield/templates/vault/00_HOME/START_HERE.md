# START HERE — {{PROJECT_NAME}}

<!-- TEMPLATE: mapa principal. ≤ 80 linhas. Responde em 1 minuto: o que é, estado, onde está cada coisa, regras inegociáveis. -->

**O que é:** {{uma ou duas frases}}
**Estado:** {{uma linha}} → [CURRENT_STATE](../05_STATE/CURRENT_STATE.md)
**Próxima ação:** {{uma linha}} → [NEXT_ACTION](../05_STATE/NEXT_ACTION.md)
**Produção:** `PRODUCTION_SAFETY_MODE: {{ON|OFF}}`

## Ordem de leitura para um novo executor

1. [CURRENT_STATE](../05_STATE/CURRENT_STATE.md)
2. [NEXT_ACTION](../05_STATE/NEXT_ACTION.md)
3. [BUSINESS_RULES](../02_BUSINESS/BUSINESS_RULES.md) — domínios tocados
4. [AI_WORKFLOW](../04_DEVELOPMENT/AI_WORKFLOW.md)

## Mapa do Vault

| Pergunta | Onde |
|---|---|
| Onde está cada repo/módulo? | [PROJECT_MAP](PROJECT_MAP.md) |
| Quais regras não posso quebrar? | [BUSINESS_RULES](../02_BUSINESS/BUSINESS_RULES.md) |
| Como o sistema é construído? | [SYSTEM_ARCHITECTURE](../03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md) |
| Como trabalhar (risco, gates)? | [AI_WORKFLOW](../04_DEVELOPMENT/AI_WORKFLOW.md) |
| Como funciona o Git aqui? | [GITFLOW](../04_DEVELOPMENT/GITFLOW.md) |
| Como testar? | [TEST_STRATEGY](../04_DEVELOPMENT/TEST_STRATEGY.md) |
| O que falta / está em conflito? | [GAP_ANALYSIS](../05_STATE/GAP_ANALYSIS.md), [OPEN_DECISIONS](../05_STATE/OPEN_DECISIONS.md) |
| Para onde vamos? | [DEVELOPMENT_PLAN](../11_ROADMAP/DEVELOPMENT_PLAN.md) |

<!-- TEMPLATE: acrescente linhas somente para arquivos condicionais que existirem. -->

## Documentação pré-existente (fora do Vault)

| Documento | Conteúdo | Confiança / divergências |
|---|---|---|

## Regras inegociáveis

- Gates humanos e produção: [AI_WORKFLOW §6–7](../04_DEVELOPMENT/AI_WORKFLOW.md)
- Sem segredos no Vault; somente nomes de variáveis.
