# CONTRATOS DE AGENTE

Objetivo: comunicação curta, estruturada e verificável entre Orchestrator e agentes, com o
mínimo de contexto suficiente.

## TASK (Orchestrator → agente)

```yaml
ROLE:            # papel (ex.: explorer)
OBJECTIVE:       # uma frase, resultado esperado
CONTEXT:         # 3–8 linhas; links para o Vault, não conteúdo colado
SCOPE:           # caminhos/módulos/repos dentro do escopo
INPUTS:          # arquivos, diffs, perguntas específicas
CONSTRAINTS:     # ex.: somente leitura; PRODUCTION_SAFETY_MODE ON; não rodar testes
DO_NOT_TOUCH:    # caminhos/ações proibidos (sempre inclui código de produto no bootstrap)
EXPECTED_OUTPUT: # formato e limite (ex.: tabela Item|Source|Evidence|Confidence, ≤ 40 linhas)
```

## RESULT (agente → Orchestrator)

```yaml
STATUS:          # DONE | PARTIAL | BLOCKED
SUMMARY:         # ≤ 5 linhas
FILES:           # lidos/alterados (alterados só quando autorizado)
DECISIONS:       # decisões tomadas dentro do escopo (normalmente nenhuma em bootstrap)
TESTS:           # executados e resultado, ou "não executados" e por quê
RISKS:           # riscos observados
BLOCKERS:        # o que impediu, e o que destravaria
RECOMMENDATION:  # próximo passo sugerido
```

Achados factuais vêm com `Source | Evidence | Confidence` (ver `references/evidence-model.md`).
O agente não promove `INFERRED` a `CONFIRMED` e não decide sobre regra de negócio, arquitetura
ou produção — ele reporta e recomenda.

## Exemplo

```yaml
ROLE: explorer
OBJECTIVE: Identificar como pagamentos são autorizados no repo billing-api.
CONTEXT: Bootstrap brownfield, modo DEEP. Ver vault/03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md.
SCOPE: billing-api/src/main/**/payment/**, billing-api/src/test/**/payment/**
INPUTS: Pergunta — quais validações ocorrem antes de capturar um pagamento?
CONSTRAINTS: somente leitura; não executar build/testes.
DO_NOT_TOUCH: todo o repositório (somente leitura)
EXPECTED_OUTPUT: tabela Regra|Source|Evidence|Confidence, ≤ 30 linhas
```
