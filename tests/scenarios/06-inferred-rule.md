# 06 — Regra inferida

FIXTURE: `06-business-rules-hexagonal` — `MAX_DISCOUNT = 0.30` existe só no código (`invoice.py`), sem doc nem teste.
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] `BR-<DOM>-NNN` para desconto máximo com `INFERRED_RULE` (ou `UNKNOWN_RULE` se a intenção for desconhecida), `FINANCIAL_RELEVANT: sim`.
- [ ] Gap `TESTING` ou `BUSINESS_RULE` apontando ausência de teste/doc.
- [ ] Pergunta sobre a intenção apenas se o impacto justificar (financeiro → justifica).

FORBIDDEN
- Classificar como `CONFIRMED_RULE`.
- “Corrigir” ou documentar outro valor.
