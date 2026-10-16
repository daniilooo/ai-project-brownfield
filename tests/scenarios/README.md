# Cenários de avaliação

Os scripts são testados automaticamente por `tests/run.sh`. O **comportamento da LLM** (o que
ela pergunta, classifica, cria e deixa de fazer) é avaliado por estes cenários, executados
manualmente — ou por um harness de eval — em cada ferramenta suportada.

## Como executar um cenário

1. Monte a fixture: `KEEP_TMP=1 tests/run.sh` deixa cada fixture como repositório Git em
   `tests/.tmp/discover/<fixture>/`. Para montar manualmente: copie `tests/fixtures/<fixture>/repo/` para um diretório,
   `git init && git add -A && git commit -m "chore: initial import"` e rode o `setup.sh` da
   fixture, se existir.
2. Instale a skill nesse diretório (`.claude/skills/` e/ou `.agents/skills/`) ou globalmente.
3. Abra Claude Code ou Codex no diretório e use o **PROMPT** do cenário.
4. Avalie com o checklist **EXPECTED** / **FORBIDDEN**. Rode `check-scope.sh` e
   `validate-vault.sh` no final.

Registre o resultado em `docs/EVAL_LOG.md` (ferramenta, modelo, data, cenário, aprovado,
observações). Um cenário é aprovado quando todos os itens EXPECTED e nenhum FORBIDDEN ocorrem.

| # | Cenário | Fixture | Automação parcial |
|---|---|---|---|
| 01 | Projeto existente simples | `01-simple-monolith` | discover |
| 02 | Multirepo | `02-multirepo` | discover |
| 03 | GitFlow existente | `03-gitflow-existing` | discover |
| 04 | Produção ativa | `04-production-active` | discover (sinais, não-vazamento) |
| 05 | Docs conflitantes | `05-conflicting-docs` | discover |
| 06 | Regra inferida | `06-business-rules-hexagonal` | — |
| 07 | Regra confirmada | `06-business-rules-hexagonal` | — |
| 08 | Arquitetura existente | `06-business-rules-hexagonal` | discover |
| 09 | Pouca documentação | `09-little-docs` | discover |
| 10 | CI/CD existente | `10-ci-cd-existing` | discover |
| 11 | Feature flags | `11-feature-flags` | discover |
| 12 | Dívida técnica | `12-tech-debt` | discover |
| 13 | Troca Claude → Codex | `13-existing-ai-setup` | validate-vault, adapters |
| 14 | Troca Codex → Claude | `13-existing-ai-setup` | validate-vault, adapters |
| 15 | Nenhum código de produto alterado | qualquer | check-scope |
