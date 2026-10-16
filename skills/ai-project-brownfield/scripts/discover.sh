#!/usr/bin/env bash
# ai-project-brownfield — discover.sh
#
# Inventário SOMENTE LEITURA de um ou mais repositórios existentes. Imprime Markdown em stdout.
#
#   discover.sh [raiz ...]          (padrão: diretório atual)
#
# Garantias:
#   - não altera nenhum arquivo dos repositórios analisados;
#   - não imprime conteúdo de arquivos de configuração: somente caminhos e rótulos de sinais
#     (evita vazar segredos);
#   - remove credenciais de URLs de remotes.
#
# A saída é EVIDÊNCIA BRUTA. A classificação CONFIRMED/INFERRED/CONFLICTING/UNKNOWN é feita
# na consolidação (ver references/evidence-model.md).
#
# Variáveis: BROWNFIELD_MAX_LIST (padrão 12) limita listas longas.

set -u
export LC_ALL=C

MAX_LIST="${BROWNFIELD_MAX_LIST:-12}"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/brownfield-discover.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

FILES="$WORK/files"      # lista de arquivos do repo atual
CONFIGS="$WORK/configs"  # subconjunto: manifests e configs (para busca de sinais)
DOCS="$WORK/docs"        # subconjunto: documentação

# ---------------------------------------------------------------- helpers

print_list() { # stdin: linhas; imprime até MAX_LIST como bullets
  local tmp="$WORK/pl" n
  cat > "$tmp"
  n=$(grep -c . "$tmp" || true)
  if [ "$n" -eq 0 ]; then echo "  - (nenhum)"; return; fi
  head -n "$MAX_LIST" "$tmp" | sed 's/^/  - `/; s/$/`/'
  if [ "$n" -gt "$MAX_LIST" ]; then echo "  - … +$((n - MAX_LIST)) outros"; fi
}

paths() { grep -E "$1" "$FILES" 2>/dev/null || true; }          # caminhos por regex
paths_i() { grep -Ei "$1" "$FILES" 2>/dev/null || true; }

files_containing() { # $1 regex (ERE, case-insensitive) ; $2 lista de arquivos -> arquivos que casam
  [ -s "$2" ] || return 0
  tr '\n' '\0' < "$2" | xargs -0 grep -I -l -i -E -- "$1" 2>/dev/null || true
}

signal() { # $1 rótulo ; $2 regex ; $3 lista onde procurar -> "- **rótulo** — arquivos"
  local hits
  hits=$(files_containing "$2" "$3" | head -n 4 | sed 's/^/`/; s/$/`/' | paste -sd ',' - | sed 's/,/, /g')
  if [ -n "$hits" ]; then
    echo "- **$1** — $hits"
    SIGNAL_COUNT=$((SIGNAL_COUNT + 1))
  fi
}

count() { local n; n=$(grep -c . "$1" 2>/dev/null); echo "${n:-0}"; }

# ---------------------------------------------------------------- por repositório

inventory_repo() {
  local root="$1" is_git=0
  cd "$root" || { echo "## Repo: $root — inacessível"; return; }
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then is_git=1; fi

  if [ "$is_git" -eq 1 ]; then
    git ls-files -co --exclude-standard 2>/dev/null > "$FILES"
  else
    find . -type f -not -path '*/.git/*' 2>/dev/null | sed 's#^\./##' > "$FILES"
  fi
  # Ignora diretórios vendorizados/gerados comuns
  grep -Ev '(^|/)(node_modules|vendor|dist|build|target|\.venv|venv|__pycache__|\.gradle|\.next|\.terraform)/' "$FILES" > "$WORK/f2" || true
  mv "$WORK/f2" "$FILES"

  grep -Ei '(^|/)(pom\.xml|build\.gradle(\.kts)?|settings\.gradle(\.kts)?|package\.json|pyproject\.toml|setup\.py|setup\.cfg|requirements[^/]*\.txt|Pipfile|go\.mod|Cargo\.toml|Gemfile|composer\.json|[^/]*\.csproj|Dockerfile[^/]*|docker-compose[^/]*\.ya?ml|compose[^/]*\.ya?ml|[^/]*\.(ya?ml|properties|toml|ini|conf|cfg|tf|tfvars|xml|env\.example|env\.sample|gradle|kts))$' "$FILES" \
    | grep -Eiv '(lock|\.lock$|package-lock\.json|yarn\.lock|pnpm-lock)' > "$CONFIGS" || true
  grep -Ei '\.(md|adoc|rst|txt)$' "$FILES" | grep -Eiv '(^|/)(requirements[^/]*\.txt|LICENSE[^/]*)$' > "$DOCS" || true

  local name; name="$(basename "$(pwd)")"
  echo "## Repo: \`$name\`"
  echo
  echo "Arquivos considerados: $(count "$FILES") · Git: $([ $is_git -eq 1 ] && echo sim || echo não)"
  echo

  # ------------------------------------------------------------ Git
  echo "### Git"
  if [ "$is_git" -eq 1 ]; then
    local cur def
    cur=$(git symbolic-ref --short -q HEAD 2>/dev/null || echo "(detached)")
    def=$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
    echo "- Branch atual: \`$cur\`"
    echo "- Branch default (origin/HEAD): \`${def:-UNKNOWN}\`"
    [ "$(git rev-parse --is-shallow-repository 2>/dev/null)" = "true" ] && echo "- ⚠ Clone raso: histórico, tags e churn podem estar incompletos."
    echo "- Commits (HEAD): $(git rev-list --count HEAD 2>/dev/null || echo 0) · Último commit: $(git log -1 --format=%cs 2>/dev/null || echo UNKNOWN)"
    echo "- Remotes:"
    git remote -v 2>/dev/null | awk '$3=="(fetch)"{print $1" "$2}' | sed -E 's#://[^/@]*@#://#' | print_list
    git for-each-ref --format='%(refname:short)' refs/heads refs/remotes 2>/dev/null \
      | sed 's#^origin/##' | grep -v '^HEAD$' | grep -v '^origin$' | sort -u > "$WORK/branches"
    echo "- Branches (locais + remotas, únicas): $(count "$WORK/branches")"
    echo "- Famílias de branch:"
    sed -E 's#/.*#/*#' "$WORK/branches" | sort | uniq -c | sort -rn | awk '{print $2" ("$1")"}' | print_list
    git tag --sort=-creatordate 2>/dev/null > "$WORK/tags"
    echo "- Tags: $(count "$WORK/tags") · mais recentes:"
    print_list < "$WORK/tags"
    git log --format=%s -n 100 2>/dev/null > "$WORK/subjects"
    local total conv
    total=$(count "$WORK/subjects")
    conv=$(grep -cE '^(feat|fix|chore|docs|refactor|test|tests|perf|build|ci|style|revert)(\([^)]*\))?!?: ' "$WORK/subjects" || true)
    echo "- Conventional Commits nos últimos $total commits: $conv"
    echo "- Merge commits nos últimos 100: $(git log --merges --format=%h -n 100 2>/dev/null | grep -c . || true)"
    echo "- Alterações não commitadas: $(git status --porcelain 2>/dev/null | grep -c . || true) arquivo(s)"
  else
    echo "- Não é repositório Git: GitFlow = UNKNOWN."
  fi
  echo

  # ------------------------------------------------------------ Topologia
  echo "### Topologia e módulos"
  {
    paths_i '(^|/)(pnpm-workspace\.yaml|lerna\.json|nx\.json|turbo\.json|go\.work|rush\.json)$'
    paths '(^|/)\.gitmodules$'
    paths_i '(^|/)settings\.gradle(\.kts)?$'
    paths '(^|/)[^/]*\.sln$'
    grep -E '(^|/)pom\.xml$' "$FILES" | while read -r p; do grep -q '<modules>' "$p" 2>/dev/null && echo "$p (maven <modules>)"; done
    grep -E '(^|/)package\.json$' "$FILES" | while read -r p; do grep -q '"workspaces"' "$p" 2>/dev/null && echo "$p (npm/yarn workspaces)"; done
    grep -E '(^|/)Cargo\.toml$' "$FILES" | while read -r p; do grep -q '^\[workspace\]' "$p" 2>/dev/null && echo "$p (cargo workspace)"; done
  } | print_list
  echo "- Manifests de build por diretório (indica módulos/apps):"
  grep -Ei '(^|/)(pom\.xml|build\.gradle(\.kts)?|package\.json|pyproject\.toml|go\.mod|Cargo\.toml|Gemfile|composer\.json|[^/]*\.csproj)$' "$FILES" | print_list
  echo

  # ------------------------------------------------------------ Linguagens
  echo "### Linguagens (arquivos por extensão)"
  grep -Eo '\.[A-Za-z0-9]+$' "$FILES" \
    | grep -Ei '^\.(java|kt|kts|scala|groovy|go|rs|py|rb|php|cs|fs|vb|js|jsx|ts|tsx|mjs|cjs|vue|svelte|swift|m|mm|c|cc|cpp|h|hpp|dart|ex|exs|erl|clj|sql|sh|ps1|tf|html|css|scss)$' \
    | tr 'A-Z' 'a-z' | sort | uniq -c | sort -rn | awk '{print $2" ("$1")"}' | print_list
  echo

  # ------------------------------------------------------------ Frameworks
  SIGNAL_COUNT=0
  echo "### Frameworks e bibliotecas (sinais em manifests/configs)"
  {
    signal "Spring Boot" 'spring-boot' "$CONFIGS"
    signal "Quarkus" 'io\.quarkus' "$CONFIGS"
    signal "Micronaut" 'io\.micronaut' "$CONFIGS"
    signal "ASP.NET Core" 'Microsoft\.AspNetCore' "$CONFIGS"
    signal "NestJS" '"@nestjs/core"' "$CONFIGS"
    signal "Express" '"express"' "$CONFIGS"
    signal "Fastify" '"fastify"' "$CONFIGS"
    signal "Next.js" '"next"[[:space:]]*:' "$CONFIGS"
    signal "React" '"react"[[:space:]]*:' "$CONFIGS"
    signal "Vue" '"vue"[[:space:]]*:' "$CONFIGS"
    signal "Angular" '"@angular/core"' "$CONFIGS"
    signal "Svelte" '"svelte"' "$CONFIGS"
    signal "Django" '(^|[^a-z])django([^a-z_-]|$)' "$CONFIGS"
    signal "Flask" '(^|[^a-z])flask([^a-z_-]|$)' "$CONFIGS"
    signal "FastAPI" 'fastapi' "$CONFIGS"
    signal "Rails" '(^|[^a-z])rails([^a-z_-]|$)' "$CONFIGS"
    signal "Laravel" 'laravel/framework' "$CONFIGS"
    signal "Gin" 'gin-gonic/gin' "$CONFIGS"
    signal "Echo/Fiber (Go)" '(labstack/echo|gofiber/fiber)' "$CONFIGS"
    signal "Actix/Axum (Rust)" '(actix-web|axum)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out" || echo "- (nenhum sinal conhecido)"
  echo

  # ------------------------------------------------------------ Dados e mensageria
  echo "### Dados, cache e mensageria"
  {
    signal "PostgreSQL" '(postgres|postgresql|jdbc:postgresql|psycopg|"pg")' "$CONFIGS"
    signal "MySQL/MariaDB" '(mysql|mariadb)' "$CONFIGS"
    signal "Oracle" '(oracle|ojdbc)' "$CONFIGS"
    signal "SQL Server" '(sqlserver|mssql)' "$CONFIGS"
    signal "MongoDB" '(mongodb|mongoose)' "$CONFIGS"
    signal "SQLite" 'sqlite' "$CONFIGS"
    signal "Redis" 'redis' "$CONFIGS"
    signal "Elasticsearch/OpenSearch" '(elasticsearch|opensearch)' "$CONFIGS"
    signal "Cassandra/DynamoDB" '(cassandra|dynamodb)' "$CONFIGS"
    signal "Kafka" 'kafka' "$CONFIGS"
    signal "RabbitMQ/AMQP" '(rabbitmq|amqp)' "$CONFIGS"
    signal "SQS/SNS" '(aws-sdk.*sqs|[^a-z]sqs[^a-z]|[^a-z]sns[^a-z])' "$CONFIGS"
    signal "ORM/JPA/Hibernate" '(hibernate|spring-boot-starter-data-jpa|sqlalchemy|typeorm|prisma|sequelize|gorm|entityframework)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out" || echo "- (nenhum sinal)"
  echo "- Migrations:"
  paths_i '(^|/)(db/migration|db/migrate|migrations?|alembic|liquibase|flyway|prisma/migrations|changelog)/' \
    | sed -E 's#^((.*/)?(db/migration|db/migrate|migrations?|alembic|liquibase|flyway|prisma/migrations|changelog))/.*#\1/#I' \
    | sort | uniq -c | awk '{print $2" ("$1" arquivos)"}' | print_list
  echo

  # ------------------------------------------------------------ Auth
  echo "### Autenticação e autorização (sinais)"
  {
    signal "Spring Security" 'spring-boot-starter-security|spring-security' "$CONFIGS"
    signal "OAuth2/OIDC" '(oauth2|oidc|openid)' "$CONFIGS"
    signal "JWT" '(jjwt|jsonwebtoken|jwt)' "$CONFIGS"
    signal "Keycloak/Auth0/Cognito/Okta" '(keycloak|auth0|cognito|okta)' "$CONFIGS"
    signal "Passport/NextAuth/Devise" '(passport|next-auth|devise)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out" || echo "- (nenhum sinal)"
  echo

  # ------------------------------------------------------------ APIs
  echo "### Contratos de API"
  paths_i '(openapi|swagger)[^/]*\.(ya?ml|json)$|\.proto$|\.graphqls?$|(^|/)schema\.graphql$|asyncapi[^/]*\.ya?ml$' | print_list
  echo

  # ------------------------------------------------------------ Testes
  echo "### Testes"
  paths_i '(^|/)(test|tests|__tests__|spec|specs|e2e|it|integration-tests?)/|(_test\.go|\.test\.[jt]sx?|\.spec\.[jt]sx?|Test\.java|Tests\.java|IT\.java|Test\.kt|_spec\.rb|(^|/)test_[^/]*\.py|_test\.py)$' > "$WORK/tests"
  echo "- Arquivos de teste (heurística): $(count "$WORK/tests")"
  echo "- Diretórios de teste:"
  sed -E 's#/[^/]*$##' "$WORK/tests" | sort | uniq -c | sort -rn | awk '{print $2" ("$1")"}' | print_list
  {
    signal "E2E (Cypress/Playwright/Selenium)" '(cypress|playwright|selenium|webdriverio)' "$CONFIGS"
    signal "Contrato (Pact/Spring Cloud Contract)" '(pact|spring-cloud-contract)' "$CONFIGS"
    signal "Integração (Testcontainers)" 'testcontainers' "$CONFIGS"
    signal "Performance (k6/JMeter/Gatling/Locust)" '(k6|jmeter|gatling|locust)' "$CONFIGS"
    signal "Cobertura (JaCoCo/nyc/c8/coverage.py)" '(jacoco|"nyc"|"c8"|coverage|codecov)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out"
  echo

  # ------------------------------------------------------------ Qualidade
  echo "### Lint, formatter e análise estática"
  paths_i '(^|/)(\.eslintrc[^/]*|eslint\.config\.[a-z]+|\.prettierrc[^/]*|prettier\.config\.[a-z]+|checkstyle[^/]*\.xml|\.editorconfig|ruff\.toml|\.flake8|\.pylintrc|\.golangci\.ya?ml|\.rubocop\.yml|sonar-project\.properties|\.pre-commit-config\.yaml|detekt[^/]*\.ya?ml|\.stylelintrc[^/]*|biome\.json|\.husky/[^/]+|lefthook\.ya?ml)$' | print_list
  {
    signal "Spotless/ktlint/Checkstyle/PMD/SpotBugs (build)" '(spotless|ktlint|checkstyle|maven-pmd|spotbugs)' "$CONFIGS"
    signal "Ruff/Black/isort (pyproject)" '\[tool\.(ruff|black|isort)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out"
  echo

  # ------------------------------------------------------------ CI/CD
  echo "### CI/CD"
  paths_i '(^|/)(\.github/workflows/[^/]+\.ya?ml|\.gitlab-ci\.yml|\.gitlab/ci/[^/]+|Jenkinsfile[^/]*|azure-pipelines[^/]*\.ya?ml|bitbucket-pipelines\.yml|\.circleci/config\.yml|\.travis\.yml|\.drone\.yml|cloudbuild[^/]*\.ya?ml|buildspec[^/]*\.ya?ml|\.buildkite/[^/]+)$' | print_list
  echo

  # ------------------------------------------------------------ Infra
  echo "### Containers, infraestrutura e cloud"
  paths_i '(^|/)(Dockerfile[^/]*|[^/]*\.dockerfile|docker-compose[^/]*\.ya?ml|compose[^/]*\.ya?ml|Chart\.yaml|kustomization\.ya?ml|[^/]*\.tf|serverless\.ya?ml|cdk\.json|Pulumi\.ya?ml|template\.ya?ml|Procfile|fly\.toml|app\.yaml|vercel\.json|netlify\.toml)$' | print_list
  grep -Ei '\.(ya?ml)$' "$CONFIGS" > "$WORK/yamls" || true
  {
    signal "Kubernetes manifests" '^kind:[[:space:]]*(Deployment|StatefulSet|Service|Ingress|CronJob)' "$WORK/yamls"
    signal "AWS" '(aws_|amazonaws|aws-sdk|"aws")' "$CONFIGS"
    signal "Azure" '(azurerm|azure)' "$CONFIGS"
    signal "GCP" '(google_|gcloud|googleapis)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out"
  echo

  # ------------------------------------------------------------ Observabilidade
  echo "### Observabilidade"
  {
    signal "Métricas (Micrometer/Prometheus/Actuator)" '(micrometer|prometheus|spring-boot-starter-actuator|prom-client)' "$CONFIGS"
    signal "Tracing (OpenTelemetry/Jaeger/Zipkin)" '(opentelemetry|jaeger|zipkin)' "$CONFIGS"
    signal "APM/erros (Datadog/New Relic/Sentry/Elastic APM)" '(datadog|dd-trace|newrelic|sentry|elastic-apm)' "$CONFIGS"
  } > "$WORK/out"; [ -s "$WORK/out" ] && cat "$WORK/out" || echo "- (nenhum sinal)"
  echo

  # ------------------------------------------------------------ Ambientes
  echo "### Ambientes (por nomes de arquivos de configuração)"
  { cat "$CONFIGS"; paths_i '(^|/)\.env(\.[^/]*)?$'; } | sed 's#.*/##' \
    | grep -Eio '(^|[-_.])(dev|develop|development|local|qa|uat|hml|homolog|homologacao|staging|stage|stg|preprod|prod|production|prd)([-_.]|$)' \
    | tr 'A-Z' 'a-z' | sed -E 's/^[-_./]//; s/[-_.]$//' | sort | uniq -c | sort -rn | awk '{print $2" ("$1" arquivos)"}' | print_list
  echo "- Ambientes referenciados em pipelines:"
  grep -Ei '(\.github/workflows/|\.gitlab-ci\.yml|\.gitlab/ci/|Jenkinsfile|azure-pipelines|bitbucket-pipelines|\.circleci/)' "$FILES" > "$WORK/cienv" || true
  if [ -s "$WORK/cienv" ]; then
    tr '\n' '\0' < "$WORK/cienv" | xargs -0 grep -hoiE -- 'environment:[[:space:]]*(name:[[:space:]]*)?["'\'']?[A-Za-z0-9_-]+' 2>/dev/null \
      | sed -E 's/.*[:[:space:]"'\'']//' | tr 'A-Z' 'a-z' | sort | uniq -c | sort -rn | awk '{print "pipeline: "$2" ("$1")"}' | print_list
  else
    echo "  - (nenhum)"
  fi
  echo

  # ------------------------------------------------------------ Produção
  SIGNAL_COUNT=0
  echo "### Production markers"
  {
    paths_i '(^|/)[^/]*[-_.](prod|production|prd)[-_.][^/]*$|(^|/)(prod|production|prd)/|\.env\.production$' | sed 's/^/arquivo de produção: /'
    paths_i '(^|/)(\.github/workflows|\.gitlab)/[^/]*(deploy|release|prod)[^/]*$' | sed 's/^/pipeline de deploy\/release: /'
    grep -Ei '(\.github/workflows/|\.gitlab-ci\.yml|Jenkinsfile|azure-pipelines|bitbucket-pipelines)' "$FILES" > "$WORK/ci" || true
    files_containing '(environment:[[:space:]]*(prod|production)|name:[[:space:]]*(prod|production)|--prod|deploy.*prod)' "$WORK/ci" | sed 's/^/pipeline referencia produção: /'
    [ -s "$WORK/tags" ] && [ "$is_git" -eq 1 ] && echo "tags de release: $(count "$WORK/tags")"
    paths_i '(^|/)CHANGELOG[^/]*$' | sed 's/^/changelog: /'
    grep -Ei '^README[^/]*$' "$FILES" > "$WORK/readme" || true
    files_containing '(produção|production)' "$WORK/readme" | sed 's/^/README menciona produção: /'
  } > "$WORK/prod"
  local nprod; nprod=$(count "$WORK/prod")
  print_list < "$WORK/prod"
  echo "- PRODUCTION_SIGNALS: $nprod"
  if [ "$nprod" -gt 0 ]; then
    echo "- PRODUCTION_SAFETY_MODE: RECOMMENDED_ON"
  else
    echo "- PRODUCTION_SAFETY_MODE: NO_SIGNALS (ausência de sinais não prova ausência de produção; padrão seguro = ON até confirmação humana)"
  fi
  echo

  # ------------------------------------------------------------ Feature flags
  echo "### Feature flags"
  {
    signal "SDK de feature flags" '(launchdarkly|unleash|flagsmith|splitio|@splitsoftware|togglz|ff4j|flipper|growthbook|openfeature|configcat|featurehub)' "$CONFIGS"
    signal "Flags em configuração" '(feature[-_.]?flags?|feature[-_.]?toggles?|features\.[a-z]+\.enabled)' "$CONFIGS"
  } > "$WORK/out"
  paths_i '(feature[-_]?flags?|toggles?)[^/]*\.(ya?ml|json|properties|toml)$' | sed 's/^/arquivo de flags: /' > "$WORK/ff"
  if [ -s "$WORK/out" ] || [ -s "$WORK/ff" ]; then cat "$WORK/out"; [ -s "$WORK/ff" ] && print_list < "$WORK/ff"; else echo "- (nenhum sinal)"; fi
  echo

  # ------------------------------------------------------------ Docs
  echo "### Documentação"
  echo "- README: $(paths_i '^README[^/]*$' | paste -sd ' ' - | sed 's/^$/NÃO ENCONTRADO/')"
  echo "- Arquivos de documentação: $(count "$DOCS")"
  echo "- ADRs / decisões:"
  paths_i '(^|/)(adr|adrs|decisions|architecture-decisions)/' | print_list
  echo "- Outros:"
  paths_i '(^|/)(CHANGELOG|CONTRIBUTING|CODEOWNERS|SECURITY|ROADMAP|BACKLOG|TODO)[^/]*$|(^|/)\.github/(pull_request_template|PULL_REQUEST_TEMPLATE|ISSUE_TEMPLATE)|(^|/)\.gitlab/merge_request_templates/' | print_list
  echo

  # ------------------------------------------------------------ IA
  echo "### Instruções de IA, agentes e Vault"
  paths_i '(^|/)(AGENTS\.md|CLAUDE\.md|GEMINI\.md|\.cursorrules|\.windsurfrules|\.github/copilot-instructions\.md)$|(^|/)\.(claude|agents|codex|cursor|ai)/|^vault/|(^|/)\.obsidian/' \
    | sed -E 's#^(\.claude|\.agents|\.codex|\.cursor|\.ai|vault|\.obsidian)/.*#\1/ (diretório)#' | sort -u | print_list
  echo

  # ------------------------------------------------------------ Dívida
  echo "### Dívida técnica (marcadores TODO/FIXME/HACK/XXX)"
  if [ "$is_git" -eq 1 ]; then
    git grep -I -c -w -E '(TODO|FIXME|HACK|XXX)' -- . ':!*.lock' ':!*lock.json' 2>/dev/null > "$WORK/todo" || true
  else
    grep -rI -c -w -E '(TODO|FIXME|HACK|XXX)' . 2>/dev/null | grep -v ':0$' | sed 's#^\./##' > "$WORK/todo" || true
  fi
  echo "- Total de marcadores: $(awk -F: '{s+=$NF} END{print s+0}' "$WORK/todo") em $(count "$WORK/todo") arquivo(s). Top:"
  sort -t: -k2 -rn "$WORK/todo" | head -n 5 | print_list
  echo

  # ------------------------------------------------------------ Sensíveis
  echo "### Arquivos possivelmente sensíveis versionados (conteúdo NÃO lido)"
  paths_i '(^|/)\.env(\.[^/]*)?$|\.(pem|key|p12|pfx|jks|keystore)$|(^|/)id_(rsa|dsa|ecdsa|ed25519)$|(^|/)(credentials|secrets?)(\.[a-z]+)?$' \
    | grep -Eiv '\.(example|sample|template|dist)$' | print_list
  echo

  # ------------------------------------------------------------ Hotspots
  if [ "$is_git" -eq 1 ]; then
    echo "### Hotspots (arquivos mais alterados nos últimos 500 commits)"
    git log --format= --name-only -n 500 2>/dev/null | grep . | sort | uniq -c | sort -rn | head -n 10 \
      | awk '{print $2" ("$1")"}' | print_list
    echo
  fi
}

# ---------------------------------------------------------------- main

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  sed -n '2,18p' "$0"; exit 0
fi

[ "$#" -eq 0 ] && set -- "."

echo "# INVENTORY — ai-project-brownfield"
echo
echo "Gerado em $(date -u +%Y-%m-%dT%H:%MZ) por \`discover.sh\` (somente leitura). Sinais são **evidência bruta**, não conclusões."
echo "Raízes analisadas: $#$([ "$#" -gt 1 ] && echo ' — TOPOLOGY: possível MULTIREPO (preservar)')"
echo

for root in "$@"; do
  abs="$(cd "$root" 2>/dev/null && pwd)" || { echo "## Repo: \`$root\` — não encontrado"; echo; continue; }
  ( inventory_repo "$abs" )
done
