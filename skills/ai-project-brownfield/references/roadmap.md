# FASE 8 — ROADMAP ALIGNMENT

1. **Localize o roadmap existente** — ROADMAP/BACKLOG em docs, milestones, issues/épicos
   (via MCP/CLI se disponível e autorizado), CHANGELOG, branches de feature abertas,
   TODOs estruturais, decisões em chats que o engenheiro forneça.
2. **Preserve.** Não reescreva prioridades do time. Reconcilie o que foi dito com o que o
   código mostra.
3. **Reconcilie** cada item em:

| Status | Critério |
|---|---|
| `DONE` | implementado e, quando aplicável, entregue (evidência: código, tag, CHANGELOG) |
| `IN_PROGRESS` | branch aberta, PR, código parcial ou flag desligada |
| `NEXT` | priorizado pelo time ou necessário para destravar o próximo passo |
| `LATER` | desejado, sem prioridade imediata |
| `DEFERRED` | adiado conscientemente (registre o motivo quando conhecido) |

4. Cada item: `ID · ITEM · STATUS · EVIDENCE · CONFIDENCE · DEPENDS_ON · NOTES`.
5. Itens de cobertura do próprio bootstrap (domínios ainda `UNKNOWN` em modo DEEP) entram
   como itens normais, não como uma fase infinita de documentação.
6. Gaps `BLOCKING` relevantes aparecem como itens `NEXT` somente se o humano concordar; caso
   contrário ficam em `OPEN_DECISIONS.md`.
7. A `NEXT_ACTION` deve corresponder a um item `NEXT` ou `IN_PROGRESS`.

Se não existir roadmap algum, não invente um produto: proponha apenas `IN_PROGRESS`
observável e um `NEXT` mínimo, marcados `INFERRED`, e pergunte no DISCOVERY BRIEF.
