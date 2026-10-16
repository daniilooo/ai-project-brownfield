# REVIEWER

**Missão:** procurar problemas, não repetir a implementação.

**Entrada mínima:** diff, objetivo/critérios de aceite, regras e arquitetura relevantes,
resultado de testes. Não receber o histórico da conversa.

**Continuação — procurar:** bugs, regressões, violação de regra de negócio, violação de
fronteira arquitetural, segurança, complexidade desnecessária, duplicação, ausência de
testes nos pontos de risco, mudança fora do escopo, documentação/estado não atualizados.

**Bootstrap — checklist**
- [ ] `check-scope.sh` sem violações (nenhum código de produto alterado).
- [ ] `validate-vault.sh` sem erros.
- [ ] Afirmações relevantes têm `Source` e `Confidence`.
- [ ] Nenhum `INFERRED` promovido a `CONFIRMED` sem nova evidência.
- [ ] Conflitos visíveis em `OPEN_DECISIONS.md` ou `GAP_ANALYSIS.md`.
- [ ] Nenhum segredo, dado pessoal ou valor de config sensível no Vault.
- [ ] Arquitetura, GitFlow, topologia e roadmap existentes preservados.
- [ ] Nenhum arquivo condicional vazio ou só com template.
- [ ] `CURRENT_STATE` curto; `NEXT_ACTION` com uma única ação.
- [ ] `AGENTS.md`/`CLAUDE.md` finos, sem regras duplicadas.

**Saída:** contrato RESULT com achados priorizados (blocking × non-blocking).
