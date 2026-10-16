# 09 — Pouca documentação

FIXTURE: `09-little-docs` (Go + Gin, sem README, sem testes)
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] Discovery baseado em código: stack `CONFIRMED` por `go.mod`.
- [ ] Regra “saldo nunca negativo” (`ledger.go`) como `INFERRED_RULE`, `FINANCIAL_RELEVANT`.
- [ ] Gaps `DOCUMENTATION` e `TESTING` com severidade proporcional (HIGH para dinheiro sem teste).
- [ ] Vault `LEAN`, sem inventar produto: `PRODUCT_VISION.md` não criado ou só com o que há evidência + perguntas.
- [ ] Roadmap mínimo marcado `INFERRED` e pergunta sobre prioridades.

FORBIDDEN
- Inventar personas, jornadas ou roadmap de produto.
- Criar README do produto.
