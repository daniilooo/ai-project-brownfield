---
name: ai-project-brownfield
description: >
  Prepara projetos de software EXISTENTES (brownfield) para desenvolvimento AI-native.
  Descobre stack, arquitetura, regras de negócio, GitFlow, CI/CD, ambientes e sinais de
  produção a partir de evidências; consolida um Vault como fonte única da verdade; faz
  gap analysis; alinha workflow, gates, roadmap e handoff multi-LLM (Claude Code, Codex e
  outras) sem alterar código de produto. Use ao assumir, retomar ou documentar um projeto
  já existente, ao preparar um repositório legado para agentes de IA ou ao consolidar
  contexto espalhado em chats. Não use para criar projeto novo a partir de uma ideia.
---

# AI PROJECT BROWNFIELD

Você vai preparar um projeto de software **que já existe** para continuar sendo desenvolvido
de forma AI-native — por qualquer LLM, com segurança e sem reconstruir contexto a cada sessão.

```text
EXISTING PROJECT → DISCOVERY → CONSOLIDATION → GAP ANALYSIS
                 → WORKFLOW ALIGNMENT → ROADMAP ALIGNMENT → CONTINUATION READY
```

Esta execução **não implementa features**. Ela termina em `CONTINUATION READY` e devolve o
controle ao engenheiro.

Caminhos relativos neste arquivo (`references/`, `templates/`, `scripts/`, `agents/`,
`examples/`) são relativos à pasta desta skill. Leia cada referência **somente quando chegar
à fase que precisa dela**.

---

## 1. Princípios

1. **DISCOVER BEFORE ASKING** — antes de perguntar, inspecione. Antes de sugerir arquitetura,
   entenda a atual. Antes de criar regra, localize a existente. Antes de propor workflow ou
   GitFlow, descubra o vigente.
2. **EVIDENCE OVER ASSUMPTION** — toda afirmação relevante tem `SOURCE`, `EVIDENCE` e
   `CONFIDENCE` (`CONFIRMED`, `INFERRED`, `CONFLICTING`, `UNKNOWN`). Nunca promova `INFERRED`
   a `CONFIRMED` em silêncio.
3. **PRESERVE BEFORE IMPROVE** — arquitetura, topologia (mono/multirepo), GitFlow, pipelines
   e roadmap existentes são preservados. Mudança vira **recomendação** com razão concreta,
   nunca ação do bootstrap.
4. **LINK, DON'T COPY** — documentação existente é referenciada e reconciliada, não recriada.
5. **MINIMUM SUFFICIENT CONTEXT** — leia por amostragem dirigida; documente apenas o que
   reduz incerteza ou acelera a próxima entrega.
6. **PROPORTIONAL PROCESS** — profundidade e cerimônia proporcionais ao tamanho e ao risco.
7. **VENDOR AGNOSTIC** — conhecimento vive no Vault; arquivos de fornecedor são adapters finos.

Otimize `UNDERSTANDING → SAFE CHANGE → FAST FEEDBACK → DELIVERY`.
Não otimize `DOCUMENTATION → DOCUMENTATION → DOCUMENTATION`.

---

## 2. Regra de ouro — DO NOT MODIFY PRODUCT CODE

Durante o bootstrap você **pode criar/alterar somente** material de suporte:

```text
vault/   docs/   .ai/   .claude/   .agents/   .codex/   agents/   skills/
AGENTS.md   CLAUDE.md   (adapters, estado, handoff, docs de workflow)
```

Você **não altera**: backend, frontend, migrations, banco, APIs, infraestrutura real,
pipelines de CI/CD, configuração de runtime, feature flags, segredos, dados, `README.md`
do produto, manifests e lockfiles.

Também não execute comandos que mudem estado fora do repositório (deploy, migration, seed,
chamadas a ambientes, instalação global). Comandos de leitura (`git log`, `ls`, `grep`,
`cat`) são livres. **Build e testes só com autorização explícita** — eles podem baixar
dependências, alterar lockfiles ou tocar bancos configurados.

Se um arquivo existente de suporte precisar mudar (ex.: `CLAUDE.md` já existente), **mescle**
preservando o conteúdo do time; nunca sobrescreva.

Antes de encerrar, rode `scripts/check-scope.sh` no repositório alvo. Qualquer violação
bloqueia o `CONTINUATION READY`.

---

## 3. PRODUCTION_SAFETY_MODE

Ative automaticamente quando houver **qualquer** sinal de produção (config/pipeline/manifest
de produção, tags de release, URLs públicas, monitoração, menção explícita) **ou quando não
for possível descartar produção**. Na dúvida: `ON`.

Com o modo ativo, durante o bootstrap:

```text
NO DEPLOY · NO DB MIGRATION · NO DATA MUTATION · NO SECRET ROTATION
NO FLAG CHANGE · NO INFRA MUTATION · NO CI/CD CHANGE
```

Registre o modo em `CURRENT_STATE.md` (`PRODUCTION_STATUS`) com as evidências.
Detalhes: `references/production-safety.md`.

---

## 4. Profundidade proporcional

Escolha após o inventário inicial e registre a escolha:

| Modo | Quando | Efeito |
|---|---|---|
| `LEAN` | 1 repo pequeno, poucos domínios, sem produção | Somente arquivos núcleo do Vault; regras e gaps de maior impacto |
| `STANDARD` | Caso comum | Núcleo + arquivos condicionais justificados por evidência |
| `DEEP` | Anos de código, vários repos/domínios, produção, alto risco de regressão | Bootstrap em ondas por domínio/repo, retomável, com Explorers em paralelo quando disponíveis |

Em `DEEP`, não tente entender tudo de uma vez: cubra primeiro o mapa global e os domínios
críticos (dinheiro, segurança, dados, hotspots de mudança) e registre o restante como
`UNKNOWN` com plano de cobertura no roadmap.

---

## 5. Execução

Mantenha o progresso em `.ai/BOOTSTRAP_STATUS.md` (template em
`templates/ai/BOOTSTRAP_STATUS.md`). Assim o bootstrap pode ser retomado por outra sessão ou
outra LLM.

### FASE 0 — PREFLIGHT

1. Se `.ai/BOOTSTRAP_STATUS.md` existir, **retome** de onde parou.
2. Identifique a raiz e a topologia. Antes de perguntar se há outros repositórios, procure
   referências em README, compose, pipelines, submódulos e manifests. Nunca converta
   multirepo em monorepo.
3. Verifique `git status`. Alterações pendentes do time **não são suas**: não as toque, não
   as commite e registre-as.
4. Detecte setup de IA prévio (`vault/`, `AGENTS.md`, `CLAUDE.md`, `.ai/`, `.claude/`,
   `.agents/`, `.cursor*`, `copilot-instructions`). Se existir: modo **CONSOLIDATE** (mesclar).
5. Rode `scripts/discover.sh <raiz> [outras raízes...]` e salve a saída em
   `.ai/discovery/INVENTORY.md`. A saída é evidência bruta, não conclusão.
6. Escolha a profundidade (§4) e o estado do `PRODUCTION_SAFETY_MODE` (§3).
7. Descubra a convenção de branches e crie uma branch de suporte coerente com ela (ex.:
   `docs/ai-brownfield-bootstrap` ou `feature/ai-brownfield-bootstrap`) a partir da branch de
   integração. Nunca trabalhe direto em branch protegida.

### FASE 1 — PROJECT DISCOVERY

Siga `references/discovery.md` e `references/evidence-model.md`. Use o inventário para
direcionar a leitura; abra arquivos para confirmar, não para varrer.

### FASE 2 — BUSINESS RULE DISCOVERY

Siga `references/business-rules.md`. Regras vêm de docs, testes, domínio, validators, enums,
state machines, constraints, migrations, contratos de API e códigos de erro.

### FASE 3 — ARCHITECTURE DISCOVERY

Siga `references/architecture.md`. Descreva a arquitetura **como ela é**, não como deveria ser.

### FASE 4 — GAP ANALYSIS

Siga `references/gap-analysis.md`. Compare existe × implementado × documentado × testado ×
operado; classifique gaps e dívida sem transformar tudo em blocker.

### CHECKPOINT — DISCOVERY BRIEF

Apresente ao engenheiro, em no máximo uma página:

```text
PROJECT · TOPOLOGY · STACK · ARCHITECTURE · PRODUCTION_SAFETY_MODE · DEPTH
TOP_FINDINGS (5) · CONFLICTS · TOP_GAPS (5) · QUESTIONS (até 7, só bloqueantes)
```

Cada pergunta deve citar a evidência que faltou ou conflitou e o impacto da resposta. Não
pare o bootstrap esperando respostas: continue com o que não depende delas, registre o
restante em `OPEN_DECISIONS.md` e atualize quando o humano responder (resposta humana =
`CONFIRMED`, `SOURCE: human:<nome/papel>@<data>`).

### FASE 5 — VAULT CONSOLIDATION

Siga `references/vault.md` com os templates de `templates/vault/`. Crie os arquivos núcleo e
somente os condicionais que tenham conteúdo real. **Não crie arquivo vazio para cumprir
template.** Em projetos com docs existentes, o Vault aponta para elas e registra conflitos.

### FASE 6 — CURRENT STATE E NEXT ACTION

- `vault/05_STATE/CURRENT_STATE.md`: curto (≤ 120 linhas). Uma LLM nova precisa entender o
  projeto em poucos minutos.
- `vault/05_STATE/NEXT_ACTION.md`: **uma** ação atual, com escopo, critérios de aceite,
  risco, validação e gates.

### FASE 7 — WORKFLOW ALIGNMENT

Instancie `templates/vault/04_DEVELOPMENT/AI_WORKFLOW.md` (PLAN → BUILD → VERIFY → SHIP,
risk model e human gates) com os comandos e permissões **reais** do projeto. Documente o
GitFlow existente seguindo `references/gitflow.md`. Não altere pipelines; documente-os.

### FASE 8 — ROADMAP ALIGNMENT

Siga `references/roadmap.md`. Preserve o roadmap existente e reconcilie em
`DONE · IN_PROGRESS · NEXT · LATER · DEFERRED` em `vault/11_ROADMAP/DEVELOPMENT_PLAN.md`.

### FASE 9 — MULTI-LLM, AGENTS E HANDOFF

Siga `references/multi-llm.md` e `agents/README.md`:

- `AGENTS.md` (adapter neutro) e `CLAUDE.md` (importa `AGENTS.md`), sem duplicar regras.
- Copie para `.ai/agents/` somente os papéis úteis a este projeto, e
  `agents/CONTRACTS.md` para `.ai/contracts/CONTRACTS.md`.
- Crie `.ai/HANDOFF.md` curto (≤ 60 linhas).

### FASE 10 — VERIFY

1. `scripts/check-scope.sh <raiz>` — nenhum arquivo de produto alterado.
2. `scripts/validate-vault.sh <raiz>` — núcleo presente, sem placeholders, sem segredos,
   `CURRENT_STATE`/`NEXT_ACTION`/`HANDOFF` curtos e completos.
3. Revisão com o checklist de `agents/reviewer.md` (modo bootstrap): toda afirmação
   relevante tem fonte; `INFERRED` não virou `CONFIRMED`; conflitos estão visíveis.

Corrija o que falhar sem consultar o humano quando a correção estiver no escopo de suporte.

### FASE 11 — REPORT E STOP

Faça commit local na branch de suporte somente se a política do projeto permitir que a LLM
commite (na dúvida, pergunte uma vez). **Push, PR/MR e merge são GATE 3** — só com
autorização humana. Atualize `.ai/BOOTSTRAP_STATUS.md` e encerre com:

```text
STATUS: CONTINUATION READY | PARTIAL (motivo)
DEPTH · PRODUCTION_SAFETY_MODE · BRANCH
FILES_CREATED / FILES_UPDATED
KEY_FINDINGS · CONFLICTS · TOP_GAPS
OPEN_DECISIONS (humanas)
NEXT_ACTION (de NEXT_ACTION.md)
HOW_TO_CONTINUE: Claude Code → /ai-project-brownfield não é mais necessário; abra o projeto
e peça "leia AGENTS.md e execute a NEXT_ACTION". Codex → idem.
```

**Não comece a implementar a NEXT_ACTION.** O engenheiro decide quando começar.

---

## 6. Evidence model (resumo)

| Classificação | Significado |
|---|---|
| `CONFIRMED` | Evidência direta e consistente (código + teste, config efetiva, doc vigente coerente com código) ou confirmação humana |
| `INFERRED` | Dedução plausível de evidência indireta (nomes, padrões, um único sinal) |
| `CONFLICTING` | Fontes divergem — registre ambas, não escolha em silêncio |
| `UNKNOWN` | Sem evidência suficiente |

Formato mínimo: `SOURCE` (arquivo:linha, comando, humano) · `EVIDENCE` (o que foi visto) ·
`CONFIDENCE`. Regras de precedência e promoção: `references/evidence-model.md`.

---

## 7. Política de perguntas

Pergunte **somente** quando: a evidência estiver ausente, as fontes conflitarem, a decisão
não puder ser inferida com segurança **e** houver impacto relevante. Agrupe as perguntas no
DISCOVERY BRIEF. Nunca pergunte o que um manifest, config, branch ou pipeline já responde
(“qual banco?”, “qual framework?”, “como é o GitFlow?”).

---

## 8. Eficiência de contexto e delegação

- O inventário e o histórico de churn (`discover.sh`) dizem onde ler primeiro.
- Leia entry points, módulos de domínio, configs e testes dos fluxos críticos; não leia o
  repositório inteiro.
- Delegue somente quando houver ganho real (repos/domínios independentes, revisão isolada).
  Use os contratos de `agents/CONTRACTS.md` e envie contexto mínimo. Se a ferramenta não
  tiver subagentes, execute os papéis sequencialmente você mesmo.

---

## 9. Segurança

Nunca copie para o Vault: senhas, tokens, chaves, connection strings com credenciais, dados
pessoais ou dados de produção. Registre apenas **nomes** de variáveis e onde são definidas.
Se encontrar segredo versionado, registre um gap `SECURITY` (sem reproduzir o valor) e
avise o engenheiro no DISCOVERY BRIEF.

---

## INICIE AGORA

1. Não implemente código de produto.
2. Execute a FASE 0 (PREFLIGHT) e rode o inventário.
3. Prossiga pelas fases; pare apenas no DISCOVERY BRIEF para perguntas bloqueantes e nos
   gates definidos.
4. Termine em `CONTINUATION READY` com o relatório da FASE 11.
