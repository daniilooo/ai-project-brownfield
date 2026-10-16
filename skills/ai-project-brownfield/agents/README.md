# AGENTS — papéis, seleção e delegação

Papéis são **funções**, não necessariamente processos separados. Em ferramentas sem
subagentes, a mesma LLM executa os papéis em sequência usando estes cartões como checklist.

## Roster

| Papel | Arquivo | Bootstrap | Continuação | Tier sugerido |
|---|---|---|---|---|
| Orchestrator | `orchestrator.md` | sempre | sempre | intermediário |
| Explorer | `explorer.md` | sempre | sempre | barato |
| Domain Analyst | `domain-analyst.md` | regras de negócio relevantes | mudanças de regra | intermediário |
| Software Architect | `architect.md` | sempre (descrição) | mudanças MEDIUM/HIGH | intermediário/avançado |
| Security | `security.md` | auth, dados sensíveis, produção | RISK_HIGH, auth, segredos | avançado |
| QA | `qa.md` | avaliar testes existentes | VERIFY | intermediário |
| DevOps | `devops.md` | CI/CD, ambientes, produção | infra, pipeline, deploy | intermediário |
| Reviewer | `reviewer.md` | revisão final do bootstrap | VERIFY | intermediário |
| Implementer | `implementer.md` | não usado | BUILD (especializar: backend, frontend, database, mobile…) | intermediário |

Tiers são independentes de fornecedor: **barato** (busca, inventário, relatórios),
**intermediário** (orquestração, implementação, revisão comum), **avançado** (arquitetura
crítica, segurança, incidentes, decisões difíceis).

## Seleção no projeto alvo

Na FASE 9, copie para `.ai/agents/` **somente** os papéis com uso previsto. Um projeto
pequeno sem frontend não precisa de Frontend Implementer; um projeto sem produção não precisa
de DevOps dedicado. Especialize o Implementer pela stack real (ex.: `backend-implementer.md`
apontando para comandos e convenções do projeto).

## Política de delegação (Orchestrator)

Delegue somente quando **todas** forem verdadeiras:

1. a subtarefa é independente (não precisa do resultado de outra em andamento);
2. o contexto necessário cabe num contrato curto;
3. o ganho (paralelismo, isolamento, modelo mais barato) supera o custo de contexto.

Casos típicos: Explorers por repositório/domínio no modo DEEP; Reviewer isolado para um diff;
QA paralelo por área em mudança RISK_HIGH.

Não delegue: tarefas que você resolve lendo 2–3 arquivos; decisões que dependem de conversa
com o humano; cadeias “agente chama agente chama agente”. Limite prático: **profundidade 1**
(Orchestrator → agente) e fan-out proporcional ao número de áreas independentes.

Toda comunicação usa `CONTRACTS.md`. Nunca envie histórico de conversa inteiro.
