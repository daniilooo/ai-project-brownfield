# FASE 4 — GAP ANALYSIS

Compare as dimensões e registre onde divergem:

```text
WHAT EXISTS      (artefatos no repositório)
WHAT IS IMPLEMENTED (comportamento no código)
WHAT IS DOCUMENTED
WHAT IS TESTED
WHAT IS OPERATED (pipelines, ambientes, monitoração)
WHAT IS MISSING
WHAT CONFLICTS
```

## Categorias

`PRODUCT · BUSINESS_RULE · ARCHITECTURE · SECURITY · DATA · TESTING · CI_CD · INFRA ·
WORKFLOW · DOCUMENTATION · OPERATIONS`

## Formato (`vault/05_STATE/GAP_ANALYSIS.md`)

```text
### GAP-<CATEGORIA>-<NNN> — título curto
DESCRIPTION: ...
EVIDENCE: arquivo:linha / comando / ausência verificada
IMPACT: o que pode dar errado e para quem
SEVERITY: CRITICAL | HIGH | MEDIUM | LOW | INFO
RECOMMENDATION: menor ação que reduz o risco
HUMAN_DECISION_REQUIRED: yes | no
```

## Severidade

| Severity | Critério |
|---|---|
| CRITICAL | dano ativo ou iminente: segredo exposto, perda de dados possível, falha de autorização |
| HIGH | risco relevante de regressão/incidente em fluxo crítico sem proteção |
| MEDIUM | atrito real de desenvolvimento ou risco moderado |
| LOW | melhoria localizada |
| INFO | observação útil sem ação imediata |

## Dívida técnica (`TECHNICAL_DEBT.md`)

Consolide dívida encontrada (marcadores, dependências obsoletas, duplicação, ausência de
testes em hotspots, débitos já listados pelo time):

```text
ID · DESCRIPTION · EVIDENCE · SEVERITY · BLOCKING | NON_BLOCKING · AREA
```

`BLOCKING` só quando impede a próxima entrega ou torna uma mudança comum insegura.
**Não transforme todo problema em blocker.** A maioria da dívida é `NON_BLOCKING`.

## Riscos (`KNOWN_RISKS.md`)

Riscos são eventos possíveis; gaps são lacunas observadas. Um gap pode gerar um risco. Liste
probabilidade/impacto qualitativos e mitigação existente.

## Decisões (`OPEN_DECISIONS.md`)

Todo gap com `HUMAN_DECISION_REQUIRED: yes` e todo `CONFLICTING` relevante vira uma decisão
aberta com: contexto, opções, recomendação, impacto de não decidir.
