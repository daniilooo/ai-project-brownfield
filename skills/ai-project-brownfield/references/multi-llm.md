# MULTI-LLM E HANDOFF

O workflow e o conhecimento pertencem ao **projeto**. LLMs são executores intercambiáveis.

```text
                PROJETO (código + vault/ + .ai/)
                          │
                    AGENTS.md (adapter neutro)
          ┌───────────────┼────────────────┐
     CLAUDE.md         Codex          outras LLMs
   (@AGENTS.md)    (lê AGENTS.md)   (prompt: "leia AGENTS.md")
```

## Adapters

| Arquivo | Papel | Regra |
|---|---|---|
| `AGENTS.md` | entrada neutra lida por Codex e várias outras ferramentas | ordem de leitura, regras inegociáveis, onde está o workflow; **sem** duplicar o Vault |
| `CLAUDE.md` | entrada do Claude Code | importa `@AGENTS.md` e acrescenta só o que é específico do Claude |
| `.claude/agents/*.md` | opcional: subagentes Claude | ponteiros finos para `.ai/agents/<papel>.md` (template em `templates/adapters/claude-subagent.md`) |
| Outros (`.cursor/rules`, `GEMINI.md`, `copilot-instructions.md`) | opcional | uma linha apontando para `AGENTS.md` |

Se já existirem `AGENTS.md`/`CLAUDE.md`: mescle. Mantenha o conteúdo do time, mova regras de
negócio/arquitetura para o Vault somente se o time concordar (decisão aberta), e acrescente a
ordem de leitura.

Formatos de arquivos de fornecedor mudam; confira a documentação vigente da ferramenta antes
de criar adapters além de `AGENTS.md`/`CLAUDE.md`.

## Ordem de leitura de um novo executor

```text
1. AGENTS.md (ou CLAUDE.md)
2. .ai/HANDOFF.md                      (se existir e for recente)
3. vault/00_HOME/START_HERE.md
4. vault/05_STATE/CURRENT_STATE.md
5. vault/05_STATE/NEXT_ACTION.md
6. vault/02_BUSINESS/BUSINESS_RULES.md (domínios tocados pela ação)
7. vault/04_DEVELOPMENT/AI_WORKFLOW.md
```

Todo o resto é lido sob demanda.

## Handoff (`.ai/HANDOFF.md`)

- Template: `templates/ai/HANDOFF.md`. **≤ 60 linhas.** Sobrescrito a cada troca; o
  histórico fica no Git.
- Campos: `PROJECT · CURRENT_STATE · CURRENT_BRANCH · CURRENT_GOAL · LAST_COMPLETED_ACTION ·
  NEXT_ACTION · BLOCKERS · RISKS · HUMAN_DECISIONS_PENDING`.
- Aponte para arquivos; não cole conteúdo do Vault nem histórico de chat.
- Atualize antes de: encerrar sessão longa, atingir limite de uso, trocar de LLM, pausar
  trabalho com mudança não commitada (registre a branch e o que falta).

## Trocas

**Claude Code → Codex:** atualize `.ai/HANDOFF.md` e `CURRENT_STATE.md`; commit (se
permitido) ou registre arquivos não commitados. No Codex: “Leia AGENTS.md e continue a partir
de .ai/HANDOFF.md”.

**Codex → Claude Code:** idem. No Claude Code o `CLAUDE.md` já importa `AGENTS.md`; peça
“Continue a partir de .ai/HANDOFF.md”.

**Outra LLM/modelo local:** forneça `AGENTS.md` e `.ai/HANDOFF.md` como contexto inicial;
ela segue a mesma ordem de leitura.
