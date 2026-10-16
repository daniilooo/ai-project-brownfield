# Exemplos

Projeto fictício **Orderly** (gestão de pedidos B2B, multirepo, em produção) usado apenas para
ilustrar o formato esperado. Não representa nenhum projeto real e não deve ser copiado.

| Arquivo | Mostra |
|---|---|
| `discovery-brief.md` | o checkpoint DISCOVERY BRIEF com perguntas bloqueantes |
| `final-report.md` | o relatório final `CONTINUATION READY` |
| `bootstrapped-project/` | resultado do bootstrap no repositório `orderly-api`: `AGENTS.md`, `CLAUDE.md`, `.ai/` e Vault núcleo + alguns condicionais |

Observe no exemplo:

- `CONFIRMED_RULE` × `INFERRED_RULE` × `UNKNOWN_RULE` em `BUSINESS_RULES.md`;
- conflito README × código registrado como gap + decisão aberta, **sem** corrigir o README;
- `PRODUCTION_SAFETY_MODE: ON` com evidências;
- `NEXT_ACTION` com uma única ação de baixo risco que reduz o maior risco encontrado;
- roadmap existente preservado e reconciliado;
- arquivos condicionais (`ENVIRONMENTS`, `FEATURE_FLAGS`, `STATES_AND_TRANSITIONS`) criados
  somente porque havia conteúdo; os demais não existem.

`tests/run.sh` valida este exemplo com `scripts/validate-vault.sh`.
