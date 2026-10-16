# Contribuindo

## GitFlow

```text
feature/*  fix/*  docs/*  chore/*  ...
        │  Pull Request (squash ou merge)
        ▼
     develop ──── Pull Request (merge commit) ────▶ main
```

| Branch | Recebe merge de | Commit direto |
|---|---|---|
| `main` | **somente** `develop`, via Pull Request | bloqueado |
| `develop` | **somente** branches de trabalho, via Pull Request | bloqueado |
| branches de trabalho | livre | permitido |

Prefixos de branch de trabalho aceitos em `develop`:

`feature/` `fix/` `bugfix/` `hotfix/` `docs/` `chore/` `refactor/` `test/` `ci/` `build/` `perf/` `style/` `revert/` `dependabot/`

Exemplo: `feature/discovery-waves`, `fix/check-scope-deleted-files`, `docs/readme-install`.

Correções urgentes também passam por `develop` (`hotfix/*` → `develop` → `main`).

### Como as regras são aplicadas

| Camada | O que faz | Onde |
|---|---|---|
| Rulesets do GitHub | bloqueiam push direto, force push e remoção de `main`/`develop`; exigem PR e checks verdes | `.github/rulesets/*.json` |
| CI `PR rules / branch-flow` | reprova PR com origem/destino fora do fluxo | `.github/workflows/pr-rules.yml` |
| CI `PR rules / conventional-commits` | reprova título de PR e commits fora do padrão | `.github/workflows/pr-rules.yml` |
| CI `CI` | shellcheck e `tests/run.sh` em Linux e macOS | `.github/workflows/ci.yml` |
| Hooks locais (opcionais) | bloqueiam commit em `main`/`develop` e validam a mensagem antes do commit | `.githooks/` |

Ative os hooks no seu clone:

```bash
scripts/git/install-hooks.sh
```

## Conventional Commits

Padrão: [Conventional Commits 1.0.0](https://www.conventionalcommits.org/pt-br/v1.0.0/).

```text
<tipo>[(escopo)][!]: <descrição>

[corpo opcional]

[rodapé(s) opcional(is)]
```

| Tipo | Uso |
|---|---|
| `feat` | nova capacidade da skill (fase, script, template, papel) |
| `fix` | correção de comportamento |
| `docs` | somente documentação |
| `style` | formatação, sem mudança de comportamento |
| `refactor` | reestruturação sem mudar comportamento |
| `perf` | desempenho |
| `test` | testes, fixtures, cenários |
| `build` | empacotamento e distribuição |
| `ci` | GitHub Actions e rulesets |
| `chore` | manutenção geral |
| `revert` | reversão de commit |

Regras validadas por `scripts/git/check-commit-msg.sh`:

- cabeçalho com até 100 caracteres;
- escopo em minúsculas (`skill`, `scripts`, `templates`, `agents`, `examples`, `tests`, `docs`, `ci`);
- descrição sem ponto final;
- linha em branco entre cabeçalho e corpo;
- `!` ou rodapé `BREAKING CHANGE:` para mudança incompatível.

Exemplos:

```text
feat(skill): add discovery waves for DEEP mode
fix(scripts): ignore deleted files in check-scope
docs(readme): explain project installation
ci: run tests on macOS
feat(templates)!: rename NEXT_ACTION sections
```

Mensagens geradas pelo Git (`Merge ...`, `Revert "..."`) são aceitas. Em PRs com **squash**,
o título do PR vira o commit em `develop` — por isso o título também é validado.

## Fluxo de trabalho

```bash
git switch develop && git pull
git switch -c feature/minha-mudanca
# ... alterações ...
tests/run.sh
git commit -m "feat(skill): minha mudança"
git push -u origin feature/minha-mudanca
# abrir PR feature/minha-mudanca → develop
```

Promoção: abrir PR `develop → main` (merge commit), de preferência com título `release: vX.Y.Z`
e atualização do `CHANGELOG.md`.

## Verificações locais antes do PR

```bash
tests/run.sh
shellcheck -S warning skills/ai-project-brownfield/scripts/*.sh scripts/git/*.sh scripts/github/*.sh tests/run.sh .githooks/*
scripts/git/check-commits.sh origin/develop HEAD
```
