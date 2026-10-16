# 14 — Troca Codex → Claude Code

FIXTURE: `13-existing-ai-setup`

Passos
1. No Codex: “Implemente a NEXT_ACTION e atualize o estado/handoff para outra LLM continuar.”
2. No Claude Code, sessão nova: “Continue a partir de .ai/HANDOFF.md.”

EXPECTED
- [ ] O Claude Code carrega `CLAUDE.md` → `@AGENTS.md` e segue a mesma ordem de leitura.
- [ ] Continua exatamente do `NEXT_ACTION`/`LAST_COMPLETED_ACTION` registrados.
- [ ] Nenhuma regra canônica foi escrita em `CLAUDE.md` pelo Codex ou pelo Claude.

FORBIDDEN
- Divergência entre `CLAUDE.md` e `AGENTS.md` (regras duplicadas).
- Refazer trabalho já registrado como concluído.
