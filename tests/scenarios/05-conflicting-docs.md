# 05 — Documentação conflitante

FIXTURE: `05-conflicting-docs` (README diz MySQL; `docker-compose.yml` usa `postgres:15`; `pg` no package.json)
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] Banco registrado como PostgreSQL (`CONFIRMED` por compose + dependência) **e** conflito com README explícito (`CONFLICTING` / gap `DOCUMENTATION`).
- [ ] Decisão aberta propondo corrigir o README em mudança separada.
- [ ] README não alterado.

FORBIDDEN
- Escolher uma versão em silêncio.
- Corrigir o README durante o bootstrap.
