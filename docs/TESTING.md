# Testes

## Automatizados

```bash
tests/run.sh          # estrutura da skill, discover.sh, check-scope.sh, validate-vault.sh, adapters
tests/run.sh -v       # mostra saídas nas falhas
KEEP_TMP=1 tests/run.sh   # mantém as fixtures montadas em tests/.tmp/
```

Requisitos: bash, git ≥ 2.31. Sem rede. `shellcheck` é usado se estiver instalado.

| Suíte | Valida |
|---|---|
| A | frontmatter, tamanho do SKILL.md, referências internas, sintaxe/permissão dos scripts, templates núcleo, independência da referência |
| B | `discover.sh` em 11 fixtures: sinais esperados, ausência de segredos/credenciais na saída, **repositório inalterado** |
| C | `check-scope.sh`: suporte OK; código, commit fora do escopo, segredo, pipeline e remoção de arquivo de produto → FAIL |
| D | `validate-vault.sh`: exemplo OK; templates crus, segredo, estado longo, múltiplas ações, núcleo ausente, arquivo só-template, handoff incompleto → FAIL |
| E | adapters multi-LLM e handoff do exemplo |

## Avaliação de comportamento (LLM)

`tests/scenarios/` — 15 cenários com prompt, EXPECTED e FORBIDDEN. Execute em Claude Code e
Codex e registre em `docs/EVAL_LOG.md`.
