# FASE 1 — PROJECT DISCOVERY

Objetivo: saber **o que existe e como funciona hoje**, com evidência, gastando o mínimo de
contexto. A saída alimenta o Vault; ela não é um relatório para ser lido inteiro.

## Ordem recomendada

1. **Inventário** — `scripts/discover.sh` (sinais brutos, caminhos, branches, tags, churn).
2. **Documentação existente** — README, `docs/`, ADRs, CONTRIBUTING, CHANGELOG, wikis
   versionadas, instruções de IA. Anote o que cada documento afirma e sua data/último commit.
3. **Manifests e configs** — confirmam stack, banco, cache, mensageria, auth, perfis de ambiente.
4. **Entry points** — `main`, bootstrap da aplicação, rotas/controllers, consumers, jobs.
5. **Domínio** — módulos com mais churn (hotspots) e módulos que tocam dinheiro, identidade,
   permissões e dados pessoais.
6. **Testes** — o que protegem (invariantes), não só quantos são.
7. **Pipelines e infraestrutura** — como o código chega a cada ambiente.

## O que descobrir (quando aplicável)

| Área | Onde olhar primeiro |
|---|---|
| Topologia (mono/multirepo, módulos) | workspaces, `<modules>`, `settings.gradle`, `go.work`, `.gitmodules`, compose, pipelines que fazem checkout de outros repos |
| Linguagens, frameworks, build | manifests (`pom.xml`, `build.gradle*`, `package.json`, `pyproject.toml`, `go.mod`, `*.csproj`, `Gemfile`, `composer.json`, `Cargo.toml`) |
| Banco, migrations | configs de datasource, compose, `db/migration`, `migrations/`, `alembic/`, `liquibase`, `prisma/` |
| Cache, mensageria | dependências e configs (Redis, Kafka, RabbitMQ, SQS…) |
| Autenticação e autorização | dependências de segurança, filtros/middlewares, anotações de permissão, policies, tabelas de papéis |
| APIs | controllers/rotas, OpenAPI/Swagger, `.proto`, GraphQL schema, clientes HTTP de integrações |
| Testes, lint, formatter, cobertura | diretórios de teste, configs de ferramentas, tarefas de build, gates de pipeline |
| Docker, Kubernetes, cloud, IaC | `Dockerfile*`, compose, manifests, Helm, Terraform, CDK, serverless |
| CI/CD | `.github/workflows`, `.gitlab-ci.yml`, `Jenkinsfile`, `azure-pipelines.yml`, `bitbucket-pipelines.yml` |
| Observabilidade | logging, métricas, tracing, APM, alertas, dashboards versionados |
| Ambientes e produção | perfis/arquivos por ambiente, overlays, tfvars, jobs de deploy, tags, CHANGELOG |
| Feature flags | SDKs (LaunchDarkly, Unleash, Flagsmith, OpenFeature, Togglz…), arquivos de flags, toggles em config |
| GitFlow | branches locais/remotas, tags, padrão de commits, templates de PR, CODEOWNERS, docs de contribuição, gatilhos de pipeline por branch |
| IA e agentes | `AGENTS.md`, `CLAUDE.md`, `.claude/`, `.agents/`, `.codex/`, `.cursor*`, `copilot-instructions`, skills existentes |
| Backlog, roadmap, dívida | ROADMAP/BACKLOG/TODO, issues templates, marcadores `TODO/FIXME/HACK`, dependências obsoletas |

## Multirepo

- Rode o inventário com todas as raízes conhecidas: `discover.sh repo-a repo-b ...`.
- Documente cada repositório (papel, stack, dono, branch de integração, pipeline) em
  `vault/00_HOME/PROJECT_MAP.md`.
- O Vault vive em **um** lugar. Se não houver repositório óbvio, pergunte onde (é uma decisão
  humana legítima) e, enquanto isso, use o repositório que contém o produto principal.
- Contratos entre repositórios (APIs, eventos, pacotes compartilhados) vão para
  `03_ARCHITECTURE/INTEGRATIONS.md`.

## Projetos grandes (DEEP)

- Use os hotspots de churn e os domínios críticos para priorizar.
- Divida a descoberta em ondas por domínio/repositório e marque cada onda em
  `.ai/BOOTSTRAP_STATUS.md`.
- Se houver subagentes, um Explorer por repositório/domínio com contrato e escopo fechados
  (`agents/explorer.md`). Consolide você mesmo.
- O que não foi coberto fica `UNKNOWN` com item no roadmap — não finja cobertura.

## Anti-padrões

- Perguntar algo que um arquivo responde.
- Ler o repositório inteiro “para garantir”.
- Tratar README antigo como verdade sem confrontar com código/config.
- Copiar trechos de config para o Vault (risco de segredo). Registre caminho e chave.
