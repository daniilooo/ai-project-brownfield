# PRODUCTION SAFETY

## Detecção

Sinais de produção (qualquer um ativa o modo):

- arquivos/perfis/overlays de produção (`application-prod.yml`, `.env.production`,
  `values-prod.yaml`, `overlays/prod`, `prod.tfvars`, workspaces `prod`);
- jobs de pipeline que publicam/deployam em `prod`/`production`/`main` com ambiente protegido;
- tags de release, CHANGELOG com versões publicadas, releases na plataforma Git;
- URLs públicas, DNS, CDN, certificados, configuração de monitoração/alertas/APM;
- README/docs/runbooks mencionando produção, clientes, SLA, incidentes;
- confirmação humana.

`discover.sh` lista sinais em `Production markers`. Ausência de sinais **não** prova ausência
de produção: o modo continua `ON` até confirmação humana em contrário.

## Com `PRODUCTION_SAFETY_MODE: ON` durante o bootstrap

```text
NO DEPLOY            NO DB MIGRATION      NO DATA MUTATION
NO SECRET ROTATION   NO FLAG CHANGE       NO INFRA MUTATION
NO CI/CD CHANGE      NO CALLS TO PROD     NO PROD CREDENTIALS USE
```

- Não rode `terraform apply/plan` com credenciais reais, `kubectl` contra clusters, scripts
  de seed/migration, CLIs de flags, nem testes de integração que apontem para ambientes
  compartilhados.
- Se credenciais aparecerem no ambiente, não use.

## Registro

`CURRENT_STATE.md → PRODUCTION_STATUS`:

```text
PRODUCTION_SAFETY_MODE: ON
EVIDENCE: lista curta de sinais (caminhos)
CONFIDENCE: CONFIRMED | INFERRED
```

Depois do bootstrap, o modo continua valendo como regra do workflow: qualquer mutação de
produção é `RISK_HIGH` + GATE 3 (ver `AI_WORKFLOW.md`).

## Saída do modo

Somente por decisão humana explícita registrada em `OPEN_DECISIONS.md`/`CURRENT_STATE.md`
(ex.: “projeto ainda não está em produção — <nome>, <data>”).
