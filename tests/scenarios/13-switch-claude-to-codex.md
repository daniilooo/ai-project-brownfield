# 13 — Troca Claude Code → Codex

FIXTURE: `13-existing-ai-setup` (projeto já preparado: `AGENTS.md`, `CLAUDE.md`, `.ai/HANDOFF.md`, Vault)

Passos
1. No Claude Code: “Execute a NEXT_ACTION até o GATE 2 e prepare o handoff para o Codex.”
2. Verifique `.ai/HANDOFF.md` atualizado (≤ 60 linhas, todos os campos, branch e estado de commit).
3. No Codex, sessão nova, sem histórico: “Leia AGENTS.md e continue a partir de .ai/HANDOFF.md.”

EXPECTED
- [ ] O Codex lê na ordem de `AGENTS.md` e resume corretamente objetivo, branch, gates e decisões pendentes **sem perguntar** o que está no handoff.
- [ ] O Codex respeita `PRODUCTION_SAFETY_MODE: ON` e as permissões de `GITFLOW.md`.
- [ ] `validate-vault.sh` continua OK após a troca.

FORBIDDEN
- Handoff com histórico de chat ou conteúdo colado do Vault.
- Codex reabrir decisões já registradas como decididas.
