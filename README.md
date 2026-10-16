# ai-project-brownfield

Skill AI-native para **projetos de software que já existem**. Ela descobre como o projeto
realmente funciona, consolida esse conhecimento em um Vault versionado e prepara o
repositório para ser continuado por qualquer LLM — Claude Code, Codex ou outras — com
segurança e sem alterar código de produto.

```text
EXISTING PROJECT → DISCOVERY → CONSOLIDATION → GAP ANALYSIS
                 → WORKFLOW ALIGNMENT → ROADMAP ALIGNMENT → CONTINUATION READY
```

## O problema

Projetos existentes têm anos de código, regras de negócio espalhadas, documentação
incompleta, decisões presas em chats, pipelines, ambientes, GitFlow próprio, dívida técnica
e, muitas vezes, produção ativa. Quando uma LLM entra nesse projeto ela costuma:

- perguntar o que poderia descobrir sozinha;
- contradizer decisões existentes e sugerir arquitetura incompatível;
- aplicar padrões de projeto novo (monorepo, GitFlow “ideal”, reescritas);
- recriar documentação que já existe;
- perder contexto ao trocar de modelo e gerar handoffs gigantes;
- criar processos mais burocráticos que o problema.

## A solução

A skill segue um princípio: **DISCOVER BEFORE ASKING**.

1. **Inventário somente leitura** (`discover.sh`): stack, banco, mensageria, auth, testes,
   CI/CD, infra, ambientes, sinais de produção, feature flags, GitFlow, tags, instruções de
   IA existentes, dívida e hotspots de mudança.
2. **Discovery com evidência**: toda afirmação relevante tem `SOURCE`, `EVIDENCE` e
   `CONFIDENCE` (`CONFIRMED`, `INFERRED`, `CONFLICTING`, `UNKNOWN`).
3. **Regras de negócio** extraídas de docs, testes, domínio, validators, enums, migrations,
   contratos e códigos de erro — classificadas e marcadas como invariante, segurança ou
   financeiro.
4. **Arquitetura como ela é**, sem substituí-la por outra mais elegante.
5. **Gap analysis** (existe × implementado × documentado × testado × operado).
6. **DISCOVERY BRIEF**: uma página com achados e no máximo 7 perguntas realmente bloqueantes.
7. **Vault** consolidado, `CURRENT_STATE` curto, uma única `NEXT_ACTION`.
8. **Workflow** PLAN → BUILD → VERIFY → SHIP com risk model e 3 gates humanos.
9. **Roadmap** existente preservado e reconciliado.
10. **Adapters multi-LLM** finos e handoff curto.
11. **Verificação automática**: nenhum arquivo de produto alterado e Vault válido.

Ao final, a skill para em `CONTINUATION READY`. Ela **não implementa features**.

## Quando usar

- Assumir, retomar ou herdar um projeto existente.
- Preparar um repositório legado para trabalhar com agentes de IA.
- Consolidar decisões e regras espalhadas em chats, wikis e cabeças.
- Padronizar a troca entre LLMs em um projeto em andamento.
- Antes de uma mudança de alto risco em um sistema pouco documentado.

## Quando NÃO usar

- Projeto novo a partir de uma ideia (use uma skill de bootstrap greenfield).
- Para implementar uma feature — a skill prepara a base; a implementação vem depois, pelo
  workflow gerado.
- Para migrar arquitetura, trocar GitFlow ou converter multirepo em monorepo — a skill
  preserva o que existe e só **recomenda** mudanças.
- Quando não há permissão de escrita nem para arquivos de documentação (rode apenas o
  `discover.sh` para um inventário).

## Conteúdo

```text
ai-project-brownfield/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── skills/ai-project-brownfield/      ← a skill (pasta a instalar)
│   ├── SKILL.md                       núcleo enxuto (fases, regras, formatos)
│   ├── references/                    guias lidos sob demanda, por fase
│   ├── agents/                        papéis, contratos e openai.yaml (Codex)
│   ├── templates/                     Vault, AGENTS.md, CLAUDE.md, handoff, status
│   ├── scripts/                       discover.sh, check-scope.sh, validate-vault.sh
│   └── examples/                      projeto fictício após o bootstrap
├── tests/
│   ├── run.sh                         testes automatizados
│   ├── fixtures/                      projetos fake (11)
│   └── scenarios/                     15 cenários de avaliação da LLM
└── docs/                              análise da referência, design, testes, eval log
```

A skill é independente: não depende de nenhuma outra skill em runtime.

## Pré-requisitos

- Git.
- Claude Code e/ou Codex instalados e autenticados (ou outra LLM com acesso ao terminal).
- `bash` (Linux, macOS, WSL ou Git Bash no Windows) para os scripts.
- Obsidian é opcional, para navegar o Vault visualmente.

## Instalação

Clone o repositório:

```bash
git clone https://github.com/daniilooo/ai-project-brownfield.git
cd ai-project-brownfield
```

Copie a **pasta inteira** da skill.

### Claude Code — todos os projetos

```bash
mkdir -p "$HOME/.claude/skills"
cp -R skills/ai-project-brownfield "$HOME/.claude/skills/"
```

### Codex — todos os projetos

```bash
mkdir -p "$HOME/.agents/skills"
cp -R skills/ai-project-brownfield "$HOME/.agents/skills/"
```

### Somente em um projeto

```bash
projeto="/caminho/do/projeto"
mkdir -p "$projeto/.claude/skills" "$projeto/.agents/skills"
cp -R skills/ai-project-brownfield "$projeto/.claude/skills/"
cp -R skills/ai-project-brownfield "$projeto/.agents/skills/"
```

> Instalar por projeto adiciona `.claude/skills/` e `.agents/skills/` ao repositório alvo —
> ambos estão na allowlist do bootstrap. Se o time não quiser versioná-los, prefira a
> instalação pessoal. Evite duas cópias com o mesmo nome no mesmo ambiente.

### Windows — PowerShell

```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.claude/skills", "$HOME/.agents/skills" | Out-Null
Copy-Item -Recurse -Path "./skills/ai-project-brownfield" -Destination "$HOME/.claude/skills/"
Copy-Item -Recurse -Path "./skills/ai-project-brownfield" -Destination "$HOME/.agents/skills/"
```

Os scripts exigem `bash` (Git Bash ou WSL). Sem bash, a skill continua funcionando; a LLM
faz o inventário e as verificações manualmente, com o mesmo checklist.

### Atualizar e desinstalar

`git pull --ff-only` neste repositório e copie a pasta novamente. Para desinstalar, remova
apenas a pasta `ai-project-brownfield` instalada — os artefatos gerados nos projetos permanecem.

## Uso

Abra o terminal **na raiz do projeto existente**.

### Claude Code

```text
/ai-project-brownfield
```

ou

```text
/ai-project-brownfield Analise este projeto existente e prepare sua base AI-native.
```

### Codex

```text
$ai-project-brownfield
```

ou em linguagem natural:

```text
Use a skill ai-project-brownfield para analisar este projeto existente e preparar sua base AI-native.
```

### Outras LLMs

Forneça o conteúdo de `skills/ai-project-brownfield/SKILL.md` como instrução e dê acesso
de leitura à pasta da skill (referências, templates e scripts).

### Multirepo

Informe os repositórios que compõem o sistema:

```text
/ai-project-brownfield O sistema é composto por este repo e por ../web e ../worker.
```

## O que é gerado no projeto alvo

```text
AGENTS.md                    adapter neutro: ordem de leitura e regras inegociáveis
CLAUDE.md                    @AGENTS.md (+ específicos do Claude, se houver)
.ai/
├── HANDOFF.md               handoff curto (≤ 60 linhas)
├── BOOTSTRAP_STATUS.md      progresso (permite retomar em outra sessão/LLM)
├── discovery/INVENTORY.md   saída do discover.sh
├── agents/                  somente os papéis úteis ao projeto
└── contracts/CONTRACTS.md
vault/
├── 00_HOME/        START_HERE*, PROJECT_MAP*
├── 01_PRODUCT/     PRODUCT_VISION, PERSONAS, USER_JOURNEYS
├── 02_BUSINESS/    BUSINESS_RULES*, INVARIANTS, STATES_AND_TRANSITIONS, AUTHORIZATION_MATRIX, GLOSSARY
├── 03_ARCHITECTURE/ SYSTEM_ARCHITECTURE*, DATA_MODEL, SECURITY, INFRASTRUCTURE, INTEGRATIONS, ADR/
├── 04_DEVELOPMENT/ AI_WORKFLOW*, GITFLOW*, TEST_STRATEGY*, DEVELOPMENT_WORKFLOW, QUALITY_GATES, TOOLING
├── 05_STATE/       CURRENT_STATE*, NEXT_ACTION*, GAP_ANALYSIS*, TECHNICAL_DEBT*, KNOWN_RISKS*, OPEN_DECISIONS*
├── 06_OPERATIONS/  ENVIRONMENTS, DEPLOYMENT, FEATURE_FLAGS, RUNBOOK
└── 11_ROADMAP/     DEVELOPMENT_PLAN*
```

`*` = núcleo, sempre criado. Os demais só existem se houver conteúdo com evidência — a skill
não cria arquivo vazio para cumprir template. Docs pré-existentes são **referenciadas**, não
copiadas. Veja o exemplo completo em `skills/ai-project-brownfield/examples/`.

Abra `vault/` no Obsidian (“Open folder as vault”) e comece por `00_HOME/START_HERE.md`, ou
leia direto no editor/GitHub — os links são Markdown relativo padrão.

## Brownfield discovery e evidence model

| Confiança | Quando |
|---|---|
| `CONFIRMED` | duas fontes independentes concordam, fonte autoritativa direta ou confirmação humana |
| `INFERRED` | uma fonte indireta (nome, padrão, só código, só doc) |
| `CONFLICTING` | fontes divergem — ambas registradas, sem escolha silenciosa |
| `UNKNOWN` | sem evidência suficiente |

A skill **não pergunta** “qual banco?” se há config PostgreSQL, nem “qual framework?” se o
manifest responde, nem “como é o GitFlow?” antes de inspecionar branches, tags e pipelines.
Pergunta somente quando a evidência falta ou conflita **e** o impacto é relevante.

Regras de negócio recebem ID estável (`BR-<DOMÍNIO>-NNN`) e classificação
`CONFIRMED_RULE / INFERRED_RULE / CONFLICTING_RULE / UNKNOWN_RULE`, com flags
`INVARIANT`, `SECURITY_RELEVANT` e `FINANCIAL_RELEVANT`.

## Workflow, risk model e gates

Depois do bootstrap, todo trabalho segue `vault/04_DEVELOPMENT/AI_WORKFLOW.md`:

| Etapa | O que acontece |
|---|---|
| **PLAN** | entender objetivo, consultar regras e arquitetura, classificar risco, definir abordagem, perguntar só o crítico |
| **BUILD** | implementar, testar, corrigir problemas locais, atualizar docs — sem interromper por microcorreções |
| **VERIFY** | testes, build, lint, contratos, migrations, segurança, regressão, review — proporcional ao risco |
| **SHIP** | commit, push, PR/MR, merge, tag, deploy, atualizar estado — conforme permissões |

| Risco | Exemplos |
|---|---|
| `RISK_LOW` | copy, estilo, UI simples, docs, filtro, refactor local |
| `RISK_MEDIUM` | endpoint, CRUD, regra de negócio limitada, integração interna, autorização comum |
| `RISK_HIGH` | auth, billing, pagamento, migration, segurança, concorrência, infra, produção, flags críticas |

Gates: **GATE 1 — PLAN APPROVAL**, **GATE 2 — FEATURE READY**, **GATE 3 — PROMOTION**.
Fora deles a LLM só para em: mudança de regra de negócio, decisão de produto, mudança
arquitetural significativa, migration destrutiva/risco de perda de dados, segurança
CRITICAL/HIGH, mutação de produção/deploy, conflito canônico não resolvido ou falta de
credenciais/permissões. Não para por erro de compilação, ajuste de teste, lint, formatter,
problema óbvio de harness, refactor trivial ou correção de documentação.

## GitFlow existente

A skill **não impõe** GitFlow. Descobre branches, branches protegidas, fluxo de merge,
convenção de commits, release, tags, PR/MR e gates a partir do histórico, das pipelines e
da documentação, e documenta em `GITFLOW.md` com fonte e confiança. Mudanças só como
recomendação com razão concreta.

## Multi-LLM e handoff

O workflow pertence ao projeto; LLMs são executores intercambiáveis.

- `AGENTS.md` é a porta de entrada neutra (lida pelo Codex e por várias ferramentas).
- `CLAUDE.md` importa `@AGENTS.md` — nenhuma regra duplicada por fornecedor.
- Ordem de leitura de um novo executor: `AGENTS.md` → `.ai/HANDOFF.md` → `START_HERE` →
  `CURRENT_STATE` → `NEXT_ACTION` → `BUSINESS_RULES` (domínios tocados) → `AI_WORKFLOW`.
- `.ai/HANDOFF.md` tem campos fixos (`PROJECT`, `CURRENT_STATE`, `CURRENT_BRANCH`,
  `CURRENT_GOAL`, `LAST_COMPLETED_ACTION`, `NEXT_ACTION`, `BLOCKERS`, `RISKS`,
  `HUMAN_DECISIONS_PENDING`) e no máximo 60 linhas.

Trocar Claude → Codex: atualize o handoff e, no Codex, peça “Leia AGENTS.md e continue a
partir de .ai/HANDOFF.md”. Codex → Claude: o mesmo pedido no Claude Code.

## Agentes

Papéis disponíveis: Orchestrator, Explorer, Domain Analyst, Software Architect, Security,
QA, DevOps, Reviewer e Implementer (especializável em backend, frontend, database…). O
bootstrap copia para o projeto **somente** os úteis. O Orchestrator delega apenas quando há
ganho real (trabalho independente, isolamento, modelo mais barato), com profundidade 1 e
contratos estruturados (`ROLE … EXPECTED_OUTPUT` / `STATUS … RECOMMENDATION`). Sem suporte a
subagentes, a mesma LLM executa os papéis em sequência.

## Segurança

- **DO NOT MODIFY PRODUCT CODE**: durante o bootstrap só `vault/`, `docs/`, `.ai/`,
  `.claude/`, `.agents/`, `.codex/`, `agents/`, `skills/`, `AGENTS.md` e `CLAUDE.md` podem
  mudar. `check-scope.sh` reprova qualquer outro arquivo, inclusive pipelines e README do produto.
- **PRODUCTION_SAFETY_MODE** ativa automaticamente com qualquer sinal de produção — e
  permanece `ON` quando não é possível descartá-la: no deploy, no migration, no data
  mutation, no secret rotation, no flag change, no infra mutation, no CI/CD change.
- Build e testes só com autorização (podem baixar dependências ou tocar bancos).
- Nenhum segredo no Vault: `discover.sh` nunca imprime valores e remove credenciais de URLs;
  `validate-vault.sh` reprova padrões de segredo.
- Push, PR/MR e merge do próprio bootstrap são GATE 3.

## Scripts

```bash
S=~/.claude/skills/ai-project-brownfield/scripts     # ou ~/.agents/skills/...

$S/discover.sh . ../outro-repo > .ai/discovery/INVENTORY.md   # inventário somente leitura
$S/check-scope.sh .                                          # nenhum arquivo de produto alterado?
$S/validate-vault.sh .                                       # Vault completo, curto e sem segredos?
```

Os scripts também são úteis isoladamente — por exemplo, `discover.sh` como inventário rápido
de um repositório desconhecido.

## Testes da skill

```bash
tests/run.sh
```

Valida estrutura, os três scripts em 11 fixtures (projeto simples, multirepo, GitFlow,
produção, docs conflitantes, regras, arquitetura hexagonal, pouca documentação, CI/CD, feature
flags, dívida técnica, setup de IA existente) e o exemplo completo. Os 15 cenários de
comportamento da LLM estão em `tests/scenarios/`. Detalhes em `docs/TESTING.md`.

## Exemplos

- `skills/ai-project-brownfield/examples/discovery-brief.md` — o checkpoint com perguntas.
- `skills/ai-project-brownfield/examples/final-report.md` — o relatório `CONTINUATION READY`.
- `skills/ai-project-brownfield/examples/bootstrapped-project/` — resultado completo em um
  projeto fictício multirepo em produção.

## Limitações

- Os scripts detectam **sinais** por nomes de arquivo e palavras-chave; podem gerar falsos
  positivos/negativos. A classificação final é da LLM, com evidência.
- O comportamento da LLM foi especificado e tem cenários de avaliação, mas a primeira rodada
  de avaliação em Claude Code e Codex ainda precisa ser executada e registrada
  (`docs/EVAL_LOG.md`).
- Regras de proteção de branch, issues e ambientes da plataforma Git só são lidas se houver
  MCP/CLI autorizado; caso contrário ficam `INFERRED`/`UNKNOWN`.
- Em bases muito grandes a cobertura é deliberadamente parcial (domínios críticos primeiro);
  o restante vira item de roadmap.
- Formatos de arquivos específicos de fornecedor (subagentes, regras) mudam; confira a
  documentação vigente antes de criar adapters além de `AGENTS.md`/`CLAUDE.md`.
- Os scripts requerem bash; em Windows sem WSL/Git Bash, as verificações são manuais.

## Documentação

- `docs/REFERENCE_ANALYSIS.md` — o que foi aproveitado e descartado da skill de referência.
- `docs/DESIGN.md` — estrutura e decisões de design.
- `docs/TESTING.md` — testes e avaliação.
- [Skills no Claude Code](https://code.claude.com/docs/en/skills) · [Skills no Codex](https://learn.chatgpt.com/docs/build-skills)

## Licença

MIT — ver `LICENSE`.
