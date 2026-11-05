# MODO REFRESH — ressincronizar um Vault existente

Use quando o projeto **já passou pelo bootstrap** desta skill (há `vault/` e
`.ai/BOOTSTRAP_STATUS.md` com a FASE 11 `DONE`) e o código evoluiu desde então: semanas de
trabalho, troca de time, release nova, ou o engenheiro pede “atualize o Vault”.

REFRESH **não refaz o bootstrap**. Ele mede o drift entre Vault e código, reverifica apenas
as afirmações afetadas e devolve o projeto a `CONTINUATION READY`. As regras da skill
continuam valendo: Regra de ouro, `PRODUCTION_SAFETY_MODE`, evidence model, gates.

```text
R0 PREFLIGHT → R1 DRIFT → R2 REVERIFY → R3 UPDATE STATE → R4 VERIFY → R5 REPORT
```

## R0 — PREFLIGHT

1. Leia `.ai/BOOTSTRAP_STATUS.md`, `.ai/HANDOFF.md` e `vault/05_STATE/CURRENT_STATE.md`.
2. Obtenha a baseline: linha `BASELINE_COMMIT:` do status (SHA puro ou `<repo>@<sha>` por
   repositório). Sem baseline (bootstrap antigo): use o último commit que alterou
   `vault/05_STATE/CURRENT_STATE.md` (`git log -1 --format=%H -- vault/05_STATE/CURRENT_STATE.md`)
   e registre a escolha como `INFERRED`.
3. `git status` (alterações do time não são suas), branch de suporte nova
   (ex.: `docs/ai-brownfield-refresh`) a partir da branch de integração.
4. Reavalie `PRODUCTION_SAFETY_MODE`: o projeto pode ter ido para produção desde o bootstrap.

## R1 — DRIFT

```bash
scripts/check-evidence.sh <raiz-com-vault> [outras raízes...]
git log --oneline <baseline>..HEAD | head -n 50
git diff --stat <baseline> -- . ':!vault' ':!.ai'
```

Classifique a saída:

| Sinal | Significado | Ação |
|---|---|---|
| `BROKEN` / `LINE` | arquivo citado sumiu, foi renomeado ou encolheu | localizar o novo lugar (`git log --follow`, busca pelo símbolo) e corrigir o `SOURCE` |
| `STALE` | arquivo citado mudou | reverificar as afirmações que o citam (R2) |
| `UNCOVERED` | área alterada que o Vault não cita | decidir se gera conhecimento novo (regra, integração, ambiente) ou é ruído |
| manifest/lockfile, migration, pipeline, config de ambiente, tag de release no diff | mudança estrutural | revisar o arquivo do Vault correspondente mesmo sem `STALE` |

Mapa rápido do que revisar:

| Mudou | Revise |
|---|---|
| manifests, lockfiles | `PROJECT_MAP`, `SYSTEM_ARCHITECTURE`, `TOOLING` |
| migrations, schema | `DATA_MODEL`, `BUSINESS_RULES` (constraints), `INVARIANTS` |
| domínio, validators, enums, testes de domínio | `BUSINESS_RULES`, `STATES_AND_TRANSITIONS` |
| pipelines, Dockerfile, IaC, helm/k8s | `GITFLOW`, `ENVIRONMENTS`, `DEPLOYMENT`, `INFRASTRUCTURE`, `QUALITY_GATES` |
| flags | `FEATURE_FLAGS` |
| tags/releases, branches novas | `CURRENT_STATE` (`CURRENT_RELEASE`, `CURRENT_BRANCHES`), `DEVELOPMENT_PLAN` |

Em projetos grandes, trate o drift em ondas (uma por repo/domínio), como no modo `DEEP`.

## R2 — REVERIFY

Para cada afirmação que cita fonte `STALE`/`BROKEN`, abra a fonte e decida:

| Resultado | Registro |
|---|---|
| continua verdadeira | mantenha a confiança; atualize `SOURCE` (linha nova) se mudou |
| mudou | reescreva a afirmação com a nova evidência |
| não foi possível reverificar | **rebaixe** para `INFERRED` com nota `fonte alterada desde <sha>, não reverificada` |
| contradiz confirmação humana | `CONFLICTING` + item em `OPEN_DECISIONS.md`; nunca sobrescreva o humano em silêncio |

Rebaixar é seguro; promover continua exigindo evidência nova ou humano.

## R3 — UPDATE STATE

- `GAP_ANALYSIS.md` / `TECHNICAL_DEBT.md` / `KNOWN_RISKS.md`: feche o que foi resolvido
  (com o commit como `SOURCE`), acrescente o que surgiu.
- `DEVELOPMENT_PLAN.md`: mova para `DONE` o que o histórico comprova; não invente prioridades.
- `CURRENT_STATE.md`: reescreva curto (≤ 120 linhas).
- `NEXT_ACTION.md`: se a ação registrada já foi feita ou ficou obsoleta, proponha **uma** nova
  e marque-a como proposta no relatório; o engenheiro confirma.
- `.ai/HANDOFF.md`: atualize.

## R4 — VERIFY

```bash
scripts/check-scope.sh <raiz>
scripts/validate-vault.sh <raiz>
scripts/check-evidence.sh --since <baseline> <raízes...>   # BROKEN/LINE/LINK = 0
```

`STALE` remanescente é aceitável apenas se cada item foi revisado em R2. Depois disso,
atualize `BASELINE_COMMIT` para o `HEAD` atual de cada repositório e acrescente uma linha em
`## Refresh log` de `.ai/BOOTSTRAP_STATUS.md`. Uma nova execução de `check-evidence.sh`
(sem `--since`) deve então sair sem `STALE`.

## R5 — REPORT E STOP

```text
STATUS: CONTINUATION READY | PARTIAL (motivo)
MODE: REFRESH · BASELINE: <sha antigo> → <sha novo> · COMMITS_COVERED: <n>
DRIFT: BROKEN <n> · STALE <n> · UNCOVERED <n>
CLAIMS_UPDATED · CLAIMS_DOWNGRADED · NEW_CONFLICTS
FILES_UPDATED
NEXT_ACTION (mantida | proposta nova)
```

Mesmos gates do bootstrap: commit local só se permitido; push/PR são GATE 3.
