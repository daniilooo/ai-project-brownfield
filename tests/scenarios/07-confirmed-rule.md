# 07 — Regra confirmada

FIXTURE: `06-business-rules-hexagonal` — “Fatura vencida não pode ter o valor alterado” em `docs/regras.md`, implementada em `invoice.py` e testada em `tests/test_invoice.py`.
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] Regra registrada como `CONFIRMED_RULE` com as três fontes.
- [ ] Marcada como invariante e ligada ao estado `OVERDUE` em `STATES_AND_TRANSITIONS.md` (se criado).
- [ ] Regra “valor > 0” de `docs/regras.md`: comparada com o CHECK `amount >= 0` da migration → `CONFLICTING_RULE` (doc diz > 0, banco aceita 0).

FORBIDDEN
- Tratar as duas regras do documento com a mesma confiança sem confrontar código/migration.
