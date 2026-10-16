# FASE 5 — VAULT CONSOLIDATION

O Vault (`vault/`) é a **fonte única da verdade** do projeto: Markdown versionado junto ao
código, navegável no Obsidian, legível no terminal, Git e por qualquer LLM. Obsidian é
opcional; nenhum plugin é necessário.

## Estrutura

```text
vault/
├── 00_HOME/        START_HERE.md*, PROJECT_MAP.md*
├── 01_PRODUCT/     PRODUCT_VISION.md, PERSONAS.md, USER_JOURNEYS.md
├── 02_BUSINESS/    BUSINESS_RULES.md*, INVARIANTS.md, STATES_AND_TRANSITIONS.md,
│                   AUTHORIZATION_MATRIX.md, GLOSSARY.md
├── 03_ARCHITECTURE/ SYSTEM_ARCHITECTURE.md*, DATA_MODEL.md, SECURITY.md,
│                   INFRASTRUCTURE.md, INTEGRATIONS.md, ADR/
├── 04_DEVELOPMENT/ DEVELOPMENT_WORKFLOW.md, AI_WORKFLOW.md*, GITFLOW.md*,
│                   TEST_STRATEGY.md*, QUALITY_GATES.md, TOOLING.md
├── 05_STATE/       CURRENT_STATE.md*, NEXT_ACTION.md*, GAP_ANALYSIS.md*,
│                   TECHNICAL_DEBT.md*, KNOWN_RISKS.md*, OPEN_DECISIONS.md*
├── 06_OPERATIONS/  ENVIRONMENTS.md, DEPLOYMENT.md, FEATURE_FLAGS.md, RUNBOOK.md
└── 11_ROADMAP/     DEVELOPMENT_PLAN.md*
```

`*` = **núcleo** (sempre criado; `validate-vault.sh` exige). Os demais são **condicionais**:
crie somente quando houver conteúdo com evidência. Templates em `templates/vault/` com o
mesmo caminho. A numeração deixa espaço (07–10) para pastas que o time queira acrescentar.

## Regras de escrita

1. **Curto e acionável.** Tabelas e listas > prosa. Um arquivo responde uma pergunta.
2. **Evidência inline** (`Source | Confidence`). Ver `evidence-model.md`.
3. **Link, don't copy.** Se `docs/api.md` já descreve a API, o Vault diz onde está, qual a
   confiança e quais divergências existem. Copie somente quando a fonte for um chat/arquivo
   não versionado que precisa ser preservado.
4. **Links relativos Markdown** (`[texto](../02_BUSINESS/BUSINESS_RULES.md)`) — funcionam no
   Obsidian, GitHub, GitLab e terminal. Evite sintaxe exclusiva do Obsidian.
5. **Sem placeholders** `{{...}}` no resultado final. Se algo não é conhecido, escreva
   `UNKNOWN` e o que falta para saber.
6. **Sem segredos ou dados pessoais.**
7. **Idioma:** siga o idioma predominante da documentação do projeto; sem documentação,
   PT-BR. Chaves estruturais (`CURRENT_GOAL`, `CONFIRMED`…) permanecem em inglês para
   permitir validação automática.

## Projeto que já tem Vault/docs

- **Vault existente:** mantenha a estrutura do time. Mapeie as pastas existentes para os
  papéis acima em `START_HERE.md` e crie somente o núcleo que falta.
- **`docs/` existente:** não mova arquivos. Referencie-os e marque conflitos.
- **Wiki externa / Confluence / Notion:** registre a URL e o que se espera encontrar lá
  como `SOURCE: external`. Não copie em massa.

## START_HERE e PROJECT_MAP

- `START_HERE.md` é o mapa: o que é, ordem de leitura, onde está cada coisa, regras
  inegociáveis (gates e produção).
- `PROJECT_MAP.md` é o mapa físico: repositórios, módulos, diretórios relevantes, entry
  points, comandos principais.
