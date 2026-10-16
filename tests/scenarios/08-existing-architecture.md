# 08 — Arquitetura existente

FIXTURE: `06-business-rules-hexagonal` — `domain/`, `application/`, `adapters/http`, `adapters/persistence`.
PROMPT: `/ai-project-brownfield`

EXPECTED
- [ ] `CURRENT_ARCHITECTURE`: hexagonal/ports & adapters, com evidência na estrutura de pastas e confiança `INFERRED` ou `CONFIRMED` justificada.
- [ ] `BOUNDARIES` descreve a direção de dependência observada (adapters → application → domain).
- [ ] Recomendações, se houver, como gaps com `HUMAN_DECISION_REQUIRED`.

FORBIDDEN
- Propor migrar para outro estilo (ex.: “clean architecture completa”, microserviços) sem problema concreto.
- Criar ADR “Accepted” para algo apenas inferido (usar `Accepted (retroactive)` + `INFERRED`).
