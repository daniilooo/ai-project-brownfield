# AI WORKFLOW


Fluxo de toda demanda: **PLAN → BUILD → VERIFY → SHIP**, com cerimônia proporcional ao risco.

## 1. RISK MODEL

| Nível | Exemplos |
|---|---|
| `RISK_LOW` | copy, estilo, UI simples, docs, filtro, refactor local |
| `RISK_MEDIUM` | endpoint, CRUD, regra de negócio limitada, integração interna, autorização comum |
| `RISK_HIGH` | auth, billing, pagamento, migration, segurança, concorrência, infra, produção, feature flag crítica |

Na dúvida entre dois níveis, use o maior. Tocar regra marcada `FINANCIAL`, `SECURITY` ou
`INVARIANT` em `vault/02_BUSINESS/` eleva para `RISK_HIGH`.

## 2. PLAN

- Entender o objetivo (NEXT_ACTION ou pedido humano).
- Consultar regras (`vault/02_BUSINESS/`) e arquitetura (`vault/03_ARCHITECTURE/`) tocadas.
- Localizar código e testes afetados (Explorer quando útil).
- Classificar o risco e definir a abordagem mínima coerente com o código existente.
- Perguntar **somente** decisões críticas (ver §6).

Plano proporcional: LOW = 2–3 linhas; MEDIUM = abordagem + arquivos + testes; HIGH = abordagem,
alternativas, rollback, validação e riscos.

## 3. BUILD

- Implementar seguindo os padrões do código vizinho.
- Criar/ajustar testes da mudança.
- Corrigir problemas locais e validar.
- Atualizar documentação afetada (regras, arquitetura, estado).

Não interromper o humano por microcorreções seguras dentro do escopo.

## 4. VERIFY

Validação proporcional ao risco (comandos em `QUALITY_GATES.md` quando existir):

| Verificação | LOW | MEDIUM | HIGH |
|---|---|---|---|
| Build | ✓ | ✓ | ✓ |
| Lint/format | ✓ | ✓ | ✓ |
| Testes unitários afetados | ✓ | ✓ | ✓ |
| Suíte do módulo / integração | — | ✓ | ✓ |
| Contratos de API | — | se tocar API | ✓ |
| Migrations (aplicar + reverter em ambiente local/efêmero) | — | — | se houver |
| Revisão de segurança | — | se tocar auth/dados | ✓ |
| Regressão de fluxos críticos vizinhos | — | recomendado | ✓ |
| Review (Reviewer) | opcional | ✓ | ✓ |

Comandos do projeto:

| Ação | Comando | Source |
|---|---|---|
| Build (api) | `./mvnw -q verify -DskipTests` | `.github/workflows/ci.yml:31` |
| Testes (api) | `./mvnw test` (IT usa Testcontainers; requer Docker local) | `ci.yml:38` |
| Web | `npm ci && npm test && npm run build` | `orderly-web/.github/workflows/ci.yml:20` |
| Lint/format (api) | `./mvnw spotless:check` | `pom.xml:120`, `ci.yml:29` |

## 5. SHIP

Etapas: stage → commit → push → PR/MR → merge → tag → deploy → atualizar estado.
Somente conforme as permissões abaixo (detalhes em `GITFLOW.md`).

| Ação | LLM pode? | Condição |
|---|---|---|
| Criar branch de trabalho | sim | seguir convenção de `GITFLOW.md` |
| Commit | sim | branch de trabalho; Conventional Commits se for a convenção |
| Push branch de trabalho | após GATE 2 | |
| Abrir PR/MR | após GATE 2 | |
| Merge | não | GATE 3 |
| Tag/release | não | GATE 3 |
| Deploy | não | GATE 3 |
| Atualizar estado/handoff | sim | sempre ao final |

## 6. HUMAN GATES

| Gate | Momento | LOW | MEDIUM | HIGH |
|---|---|---|---|---|
| GATE 1 — PLAN APPROVAL | antes do BUILD | implícito (pedido = aprovação) | plano curto | plano completo com rollback |
| GATE 2 — FEATURE READY | após VERIFY | resumo | resumo + evidências | resumo + evidências + riscos residuais |
| GATE 3 — PROMOTION | merge/tag/deploy | humano | humano | humano |

Fora dos gates, **parar apenas** para:

- mudança de regra de negócio;
- decisão de produto;
- mudança arquitetural significativa;
- migration destrutiva ou risco de perda de dados;
- segurança CRITICAL/HIGH;
- mutação de produção ou deploy;
- conflito canônico não resolvido (Vault × código × humano);
- credenciais/permissões ausentes.

**Não parar** (quando dentro do escopo autorizado) para: erro de compilação, ajuste de teste
unitário da própria mudança, lint, formatter, problema óbvio de harness, refactor trivial,
correção de documentação.

## 7. PRODUCTION SAFETY

`PRODUCTION_SAFETY_MODE` (ver `vault/05_STATE/CURRENT_STATE.md`). Com `ON`: nenhuma ação
contra produção, banco compartilhado, flags, segredos ou infraestrutura sem GATE 3.

## 8. ENCERRAMENTO DE CADA ENTREGA

1. Atualizar `CURRENT_STATE.md` (COMPLETED/IN_PROGRESS/BLOCKERS).
2. Definir a próxima `NEXT_ACTION.md` (uma ação) ou marcar que aguarda decisão humana.
3. Atualizar `.ai/HANDOFF.md`.
4. Registrar decisões novas (ADR, regra, decisão aberta) e dívida descoberta.

## 9. DELEGAÇÃO

Papéis em `.ai/agents/`, contratos em `.ai/contracts/CONTRACTS.md`. Delegar só quando houver
ganho real (independência, isolamento, custo). Profundidade máxima 1. Sem subagentes, a mesma
LLM executa os papéis em sequência.
