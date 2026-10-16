# EXISTING GITFLOW

**Não imponha GitFlow novo.** Descubra o atual, preserve quando coerente e recomende mudança
somente com razão concreta (ex.: deploy de produção a partir de branch sem proteção).

## Como descobrir (somente leitura)

```bash
git branch -a --sort=-committerdate | head -50     # famílias de branch e atividade
git symbolic-ref refs/remotes/origin/HEAD           # branch default
git tag --sort=-creatordate | head -20              # versionamento / releases
git log --oneline -100 --first-parent <default>     # merges, squash, commits diretos
git log --format=%s -200 | head -200                # convenção de commits
git log --merges --oneline -20                      # estratégia de merge
```

Complemente com: gatilhos de pipeline por branch/tag, `CODEOWNERS`, templates de PR/MR,
CONTRIBUTING, docs de release, configuração de proteção (se houver acesso via MCP/CLI
autorizado; caso contrário `UNKNOWN`).

## O que documentar em `vault/04_DEVELOPMENT/GITFLOW.md`

```text
BRANCHES            famílias observadas e papel de cada uma
PROTECTED_BRANCHES  confirmadas ou inferidas (pipeline/CODEOWNERS)
MERGE_FLOW          origem → destino (ex.: feature/* → develop → release/* → main)
COMMIT_CONVENTION   ex.: Conventional Commits (taxa observada nos últimos N commits)
RELEASE_FLOW        como uma versão nasce e chega a produção
TAGGING             padrão de tags (vX.Y.Z, release-*, datas)
PR_MR               plataforma, template, revisores, checks obrigatórios
HUMAN_GATES         o que exige humano no Git (merge, tag, release)
AI_PERMISSIONS      o que a LLM pode fazer: branch, commit, push, PR/MR, merge, tag
```

Cada item com `Source | Confidence`. Divergência entre o que a doc diz e o que o histórico
mostra é `CONFLICTING` e vira decisão aberta se tiver impacto.

## Permissões de IA (padrão conservador quando não definido)

| Ação | Padrão |
|---|---|
| Criar branch de trabalho | permitido |
| Commit em branch de trabalho | permitido |
| Push da branch de trabalho | após GATE 2 |
| Abrir PR/MR | após GATE 2 |
| Merge, tag, release | humano (GATE 3) |
| Push/commit em branch protegida | nunca |
| Reescrever histórico compartilhado | nunca |
