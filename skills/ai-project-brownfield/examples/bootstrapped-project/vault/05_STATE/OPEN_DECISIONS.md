# OPEN DECISIONS

## Abertas

### DEC-001 — Prazo de estorno: 72h ou 7 dias?
CONTEXT: código × FAQ divergem (GAP-BUSINESS_RULE-001, BR-PAY-001).
OPTIONS: A) manter 72h e corrigir FAQ · B) alterar para 7 dias (RISK_HIGH, financeiro).
RECOMMENDATION: confirmar com produto/financeiro antes de qualquer mudança.
IMPACT_IF_UNDECIDED: suporte continua prometendo prazo que o sistema recusa.
OWNER: UNKNOWN (produto)

### DEC-002 — Corrigir README (MySQL → PostgreSQL)?
CONTEXT: README é arquivo de produto; o bootstrap não o altera.
OPTIONS: A) corrigir em PR próprio · B) manter e apontar para o Vault.
RECOMMENDATION: A, RISK_LOW.
IMPACT_IF_UNDECIDED: confusão de onboarding.
OWNER: tech lead

### DEC-003 — Estratégia de merge: squash ou merge commit?
CONTEXT: CONTRIBUTING diz squash; histórico mostra merge commits.
OPTIONS: A) seguir CONTRIBUTING · B) atualizar CONTRIBUTING.
RECOMMENDATION: perguntar ao time; enquanto isso a LLM não faz merge.
IMPACT_IF_UNDECIDED: baixo.
OWNER: tech lead

## Decididas

| ID | Decisão | Quem | Quando |
|---|---|---|---|
| — | nenhuma ainda | — | — |
