# FEATURE FLAGS

PROVIDER: Unleash (`io.getunleash:unleash-client-java`) · Source: `pom.xml:80`, `application.yml:40`

| Flag | Controla | Default | Crítica? | Onde é lida | Confidence |
|---|---|---|---|---|---|
| `orders.csv-export` | exportação CSV (RM-002) | off | não | `OrderExportController.java:22` | CONFIRMED |
| `payments.new-psp` | roteamento para novo PSP | off | sim | `PaymentRouter.java:15` | CONFIRMED |
