# Análise da referência — ai-project-bootstrap

Referência estudada: `daniilooo/ai-project-bootstrap` (README, `skills/ai-project-bootstrap/SKILL.md`
com 59 seções, `agents/openai.yaml`). Ela **não foi modificada** e **não é dependência** desta
skill: nada aqui a importa, referencia em runtime ou exige que esteja instalada.

## 1. O que a referência faz

`IDEA → INTAKE → FOUNDATION → ROADMAP → IMPLEMENTATION READY`. Um prompt-mestre único conduz
um Intake em blocos (produto, MVP, regras, stack, arquitetura, LLMs, MCPs, hooks, GitFlow),
depois gera monorepo, Vault Obsidian, `.ai/` (workflow, agentes, contratos, skills, hooks,
adapters), roadmap com HTML, dashboard do sistema de IA, manual e README.

## 2. Princípios reaproveitados (adaptados)

| Conceito da referência | Como aparece aqui | Adaptação brownfield |
|---|---|---|
| Vault versionado como fonte única da verdade | `vault/` | Consolida e **referencia** docs existentes em vez de criar tudo; arquivos núcleo × condicionais |
| Conhecimento independente do chat/fornecedor | `AGENTS.md` + Vault | igual |
| `CLAUDE.md`/`AGENTS.md` como adapters finos | templates `root/` | `CLAUDE.md` usa `@AGENTS.md` (import) → zero duplicação; mesclar quando já existirem |
| Contratos de agente (task/result) | `agents/CONTRACTS.md` | campos pedidos (ROLE…EXPECTED_OUTPUT / STATUS…RECOMMENDATION) + exigência de `Source/Confidence` |
| Contexto mínimo suficiente | §8 do SKILL.md | + inventário e hotspots de churn para direcionar leitura em bases grandes |
| Orchestrator / Explorer (barato, factual, referenciado) | `agents/` | política explícita anti-delegação excessiva (profundidade 1) |
| Architect, QA, DevOps, Reviewer, Security | `agents/` | modo bootstrap = **somente leitura/descrição** |
| “Não criar agentes para parecer sofisticado” | `agents/README.md` | seleção por projeto; papéis podem ser executados em sequência sem subagentes |
| Hierarquia de modelos por custo (tiers) | `agents/README.md` | igual, independente de fornecedor |
| Gates humanos | `AI_WORKFLOW.md` | reduzidos a 3 gates + lista fechada de paradas; matriz por risco |
| Estado + handoff para trocar de LLM | `CURRENT_STATE`, `NEXT_ACTION`, `.ai/HANDOFF.md` | handoff com campos fixos e limite de 60 linhas, validado por script |
| Roadmap com fases finitas / anti “túnel infinito” | `DEVELOPMENT_PLAN.md` | reconciliação `DONE/IN_PROGRESS/NEXT/LATER/DEFERRED` preservando o roadmap do time |
| “Documentar o que será reutilizado; evitar burocracia” | princípios 4–6 | reforçado com profundidade `LEAN/STANDARD/DEEP` |
| Segurança: nada de segredo no Vault | §9 + `validate-vault.sh` | detecção automática de padrões de segredo; inventário nunca imprime valores |
| Não começar a codificar; parar ao final | regra de ouro + FASE 11 | reforçada com guard automatizado (`check-scope.sh`) |
| Instalação Claude (`~/.claude/skills`) e Codex (`~/.agents/skills`), `agents/openai.yaml` | README, `agents/openai.yaml` | igual |
| Mermaid para diagramas | templates de arquitetura/estado | igual |

## 3. Conceitos que **não** fazem sentido em brownfield

| Conceito da referência | Por que não se aplica | Substituto |
|---|---|---|
| Intake por perguntas antes de tudo | o projeto já responde a maioria; perguntar primeiro é o problema que esta skill resolve | **DISCOVER BEFORE ASKING** + DISCOVERY BRIEF com ≤ 7 perguntas bloqueantes |
| Monorepo obrigatório | topologia existente tem razões e custos de migração | preservar topologia; nunca converter |
| Escolher stack/arquitetura | já existem | descrever o que existe com evidência |
| Definir GitFlow pelo Intake | já existe um fluxo (formal ou de fato) | descobrir pelo histórico, branches, tags, pipelines |
| Criar estrutura de repositório, `.env.example`, hooks de git | altera o produto | proibido no bootstrap; vira recomendação |
| Gerar skills de commit/Jira/deploy automaticamente | cerimônia antes de entender o projeto | fora do escopo; o time decide depois |
| HTML do roadmap e dashboard do sistema de IA | duplicam o Markdown sem sincronização determinística (a própria referência aponta isso) | Markdown como única fonte; HTML pode ser gerado depois se o time quiser |
| `Definition of MVP Done` / filosofia IDEA→MVP | produto já existe, muitas vezes em produção | `NEXT_ACTION` com critérios de aceite + roadmap reconciliado |
| Vault com 18 pastas fixas | pastas vazias geram ruído | 8 pastas, 14 arquivos núcleo, condicionais só com conteúdo |
| PT-BR obrigatório para toda documentação | o projeto pode já ter idioma | seguir idioma predominante; PT-BR quando não houver docs |
| Reporter como agente obrigatório | relatório final é pequeno | papel absorvido pelo Orchestrator |

## 4. O que a brownfield acrescenta

- **Evidence model** (`SOURCE/EVIDENCE/CONFIDENCE`, `CONFIRMED/INFERRED/CONFLICTING/UNKNOWN`) com
  regras de precedência e proibição de promoção silenciosa.
- **Business rule model** com classificação e flags `INVARIANT/SECURITY/FINANCIAL`.
- **Gap analysis** por categoria e severidade; dívida `BLOCKING × NON_BLOCKING`.
- **PRODUCTION_SAFETY_MODE** automático (na dúvida, `ON`).
- **Profundidade proporcional** e bootstrap **retomável** (`.ai/BOOTSTRAP_STATUS.md`), em ondas para bases grandes.
- **Scripts determinísticos**: inventário somente leitura, guard de escopo, validador do Vault.
- **Testes**: fixtures + 15 cenários de avaliação.
- **Progressive disclosure**: `SKILL.md` curto + referências carregadas por fase (a referência é um prompt monolítico de ~1.900 linhas).
