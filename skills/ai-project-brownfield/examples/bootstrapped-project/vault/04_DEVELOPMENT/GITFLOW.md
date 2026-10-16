# GITFLOW

| Item | Valor | Source | Confidence |
|---|---|---|---|
| BRANCHES | main, develop, feature/*, release/*, hotfix/* | `git branch -a` | CONFIRMED |
| PROTECTED_BRANCHES | main, develop | `CODEOWNERS`, `ci.yml` (`on.push.branches`) | INFERRED (sem acesso às regras de proteção) |
| MERGE_FLOW | feature/* → develop → release/* → main; hotfix/* → main + develop | `git log --merges`, `CONTRIBUTING.md:22` | CONFIRMED |
| COMMIT_CONVENTION | Conventional Commits (82 de 100 últimos) | `git log --format=%s -100` | CONFIRMED |
| RELEASE_FLOW | `release/x.y` estabiliza em hml; merge em main gera tag e deploy prod com aprovação | `deploy-prod.yml`, `CONTRIBUTING.md:40` | CONFIRMED |
| TAGGING | `vX.Y.Z` em main (última v2.14.0) | `git tag` | CONFIRMED |
| PR_MR | GitHub PR, template `.github/pull_request_template.md`, 1 revisor, CI obrigatório | template + `CODEOWNERS` | INFERRED |
| HUMAN_GATES | merge em develop/main, tag, aprovação do environment `production` | `deploy-prod.yml:12` | CONFIRMED |

## AI_PERMISSIONS

| Ação | Permitido | Condição |
|---|---|---|
| Criar branch | sim | `feature/<ticket>-<slug>` a partir de develop |
| Commit | sim | Conventional Commits |
| Push | sim | após GATE 2 |
| PR/MR | sim | após GATE 2, base develop |
| Merge | não | humano |
| Tag | não | humano |

## Divergências e recomendações

- `CONTRIBUTING.md` pede squash merge; histórico mostra merge commits em `develop` (CONFLICTING, baixo impacto — DEC-003).
