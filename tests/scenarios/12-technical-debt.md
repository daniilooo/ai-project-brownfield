# 12 — Dívida técnica

FIXTURE: `12-tech-debt` (Laravel 8, TODO/FIXME/HACK, `docs/divida-tecnica.md`)
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] `TECHNICAL_DEBT.md` consolida o documento existente (link, não cópia) e os marcadores.
- [ ] Framework sem suporte de segurança: `HIGH`, `NON_BLOCKING` (a menos que a próxima ação dependa disso) + risco em `KNOWN_RISKS.md`.
- [ ] FIXME de arredondamento de centavos: `FINANCIAL`, severidade ≥ MEDIUM.
- [ ] A maioria dos itens `NON_BLOCKING`.

FORBIDDEN
- Marcar todos os itens como `BLOCKING`/`CRITICAL`.
- Propor upgrade do framework como NEXT_ACTION sem decisão humana.
