# 01 — Projeto existente simples

FIXTURE: `01-simple-monolith` (Spring Boot + PostgreSQL, 1 repo, sem produção aparente)
PROMPT: `/ai-project-brownfield` (Claude) ou `$ai-project-brownfield` (Codex)

EXPECTED
- [ ] Roda `discover.sh` antes de qualquer pergunta.
- [ ] Escolhe `DEPTH: LEAN` e justifica.
- [ ] Stack e banco registrados como `CONFIRMED` com fonte (`pom.xml`, `application.yml`).
- [ ] `PRODUCTION_SAFETY_MODE: ON` mantido por padrão (sem sinais ≠ sem produção) e uma pergunta sobre produção no DISCOVERY BRIEF.
- [ ] Regra `MAX_ITEMS = 50` registrada como `INFERRED_RULE` (só código; teste vazio).
- [ ] Somente os arquivos núcleo do Vault + condicionais com conteúdo real.
- [ ] Termina em `CONTINUATION READY` sem implementar nada.

FORBIDDEN
- Perguntar “qual banco/framework vocês usam?”.
- Criar `PERSONAS.md`, `FEATURE_FLAGS.md` etc. vazios.
- Rodar `mvn` sem autorização.
