# ENVIRONMENTS

| Ambiente | Propósito | Como é publicado | Config (caminho) | Dados reais? | Source | Confidence |
|---|---|---|---|---|---|---|
| dev | integração contínua | push em develop (`deploy.yml`) | `values-dev.yaml` | não | workflow | CONFIRMED |
| hml | homologação de release | push em release/* | `values-hml.yaml` | anonimizados | workflow, CONTRIBUTING | INFERRED |
| prod | produção | merge em main + aprovação do environment | `values-prod.yaml` | sim | `deploy-prod.yml` | CONFIRMED |
