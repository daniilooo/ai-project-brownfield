# AGENTS.md — {{PROJECT_NAME}}

<!-- TEMPLATE: adapter neutro. Mantenha curto (≤ 60 linhas). Não copie regras do Vault para cá. Se já existia AGENTS.md, mescle preservando o conteúdo do time. -->

Este projeto usa um workflow AI-native independente de fornecedor. O conhecimento vive em
`vault/`; o estado operacional em `.ai/`. Este arquivo é apenas a porta de entrada.

## Ordem de leitura

1. `.ai/HANDOFF.md` (se existir)
2. `vault/00_HOME/START_HERE.md`
3. `vault/05_STATE/CURRENT_STATE.md`
4. `vault/05_STATE/NEXT_ACTION.md`
5. `vault/02_BUSINESS/BUSINESS_RULES.md` — somente domínios tocados
6. `vault/04_DEVELOPMENT/AI_WORKFLOW.md`

Leia o resto sob demanda.

## Regras inegociáveis

- Siga `vault/04_DEVELOPMENT/AI_WORKFLOW.md` (PLAN → BUILD → VERIFY → SHIP, risk model, gates).
- `PRODUCTION_SAFETY_MODE: {{ON_OFF}}` — ver `vault/05_STATE/CURRENT_STATE.md`.
- Nunca: deploy, migration em ambiente compartilhado, mutação de dados, mudança de flag,
  rotação de segredo ou mudança de infra sem aprovação humana explícita.
- Mudança de regra de negócio ou de arquitetura significativa exige humano.
- Nunca commitar segredos. Nunca commitar/pushar em branch protegida
  (`vault/04_DEVELOPMENT/GITFLOW.md`).
- Descubra antes de perguntar; registre fonte e confiança do que afirmar.

## Ao terminar uma entrega ou trocar de LLM

Atualize `vault/05_STATE/CURRENT_STATE.md`, `vault/05_STATE/NEXT_ACTION.md` e `.ai/HANDOFF.md`.

## Comandos essenciais

<!-- TEMPLATE: apenas os 3–5 comandos mais usados; detalhes em vault/04_DEVELOPMENT/DEVELOPMENT_WORKFLOW.md -->
| Ação | Comando |
|---|---|
| Build | `{{BUILD_COMMAND}}` |
| Testes | `{{TEST_COMMAND}}` |
| Lint/format | `{{LINT_COMMAND}}` |
