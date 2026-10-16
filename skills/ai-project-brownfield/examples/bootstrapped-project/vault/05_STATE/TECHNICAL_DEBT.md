# TECHNICAL DEBT

| ID | DESCRIPTION | EVIDENCE | SEVERITY | BLOCKING | AREA |
|---|---|---|---|---|---|
| TD-001 | Pagamentos com 31% de cobertura de linhas | relatório JaCoCo do CI | HIGH | NON_BLOCKING | payment |
| TD-002 | `PaymentController` acessa repository | GAP-ARCHITECTURE-001 | LOW | NON_BLOCKING | payment |
| TD-003 | 37 marcadores TODO/FIXME, 12 em `order` | inventário | LOW | NON_BLOCKING | order |
