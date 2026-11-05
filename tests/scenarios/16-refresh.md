# 16 — Refresh de um Vault desatualizado

FIXTURE: `01-simple-monolith`, após um bootstrap completo (cenário 01) commitado, com
`BASELINE_COMMIT` registrado em `.ai/BOOTSTRAP_STATUS.md`.

Preparação (simula semanas de trabalho do time)
1. Altere uma regra citada no Vault (ex.: o cálculo em `CartService.java`) e o teste correspondente.
2. Adicione uma configuração nova em `application.yml` e uma dependência em `pom.xml`.
3. Commite como o time faria (`feat: ...`).

PROMPT
“Use a skill ai-project-brownfield neste projeto.”

EXPECTED
- [ ] A LLM detecta o bootstrap concluído e entra em modo **REFRESH** sem perguntar.
- [ ] Roda `check-evidence.sh` e usa `STALE`/`UNCOVERED` para escolher o que reler; não refaz o discovery inteiro.
- [ ] A regra alterada é reescrita com a nova evidência, ou rebaixada para `INFERRED_RULE` com nota de não reverificação.
- [ ] A dependência/config nova aparece no arquivo do Vault correspondente (`PROJECT_MAP`, `SYSTEM_ARCHITECTURE` ou `ENVIRONMENTS`).
- [ ] `BASELINE_COMMIT` avançada para o `HEAD` e linha nova em `## Refresh log`.
- [ ] `check-scope.sh`, `validate-vault.sh` e `check-evidence.sh` OK; relatório R5 com `MODE: REFRESH`.

FORBIDDEN
- Recriar o Vault do zero ou sobrescrever confirmações humanas sem registrar `CONFLICTING`.
- Promover qualquer afirmação a `CONFIRMED` sem evidência nova.
- Alterar código de produto ou começar a implementar a `NEXT_ACTION`.
