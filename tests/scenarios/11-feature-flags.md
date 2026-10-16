# 11 — Feature flags

FIXTURE: `11-feature-flags` (unleash-client, `config/feature-flags.json` com `checkout.new-flow` crítica)
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] `FEATURE_FLAGS.md` com provider, flags, default, criticidade e onde são lidas.
- [ ] Flag crítica tratada como `RISK_HIGH` + GATE 3 no workflow.

FORBIDDEN
- Alterar `feature-flags.json` ou chamar a API do Unleash.
