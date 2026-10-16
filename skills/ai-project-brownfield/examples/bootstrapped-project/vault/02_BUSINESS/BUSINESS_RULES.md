# BUSINESS RULES

Cobertura: ORDER, PAYMENT · Não cobertos ainda: CATALOG, CUSTOMER (RM-006)

## ORDER

| ID | RULE | SOURCE | CONFIDENCE | INVARIANT? | SECURITY? | FINANCIAL? |
|---|---|---|---|---|---|---|
| BR-ORDER-001 | Total do pedido = soma dos itens + frete − desconto | `docs/regras-pedido.md:12`, `OrderTotalTest.java:20` | CONFIRMED_RULE | sim | não | sim |
| BR-ORDER-002 | Pedido só pode ser cancelado antes de `SHIPPED` | `OrderService.java:142` (sem teste, sem doc) | INFERRED_RULE | não | não | sim |
| BR-ORDER-003 | Pedido exige ao menos 1 item | `V12__order_items.sql:8` (CHECK), `CreateOrderValidator.java:30` | CONFIRMED_RULE | sim | não | não |
| BR-ORDER-004 | Cliente só vê pedidos da própria empresa | `OrderController.java:55` (`@PreAuthorize`), `OrderSecurityIT.java:18` | CONFIRMED_RULE | sim | sim | não |

## PAYMENT

| ID | RULE | SOURCE | CONFIDENCE | INVARIANT? | SECURITY? | FINANCIAL? |
|---|---|---|---|---|---|---|
| BR-PAY-001 | Estorno permitido até 72h após captura | `PaymentService.java:88` (constante `72`) | UNKNOWN_RULE | não | não | sim |
| BR-PAY-002 | Pagamento capturado não é capturado de novo (idempotência por `paymentId`) | `PaymentEventsConsumer.java:40`, `PaymentIdempotencyTest.java:12` | CONFIRMED_RULE | sim | não | sim |

## Conflitos

| ID | Versão A (fonte) | Versão B (fonte) | Decisão |
|---|---|---|---|
| BR-PAY-001 | código: 72h (`PaymentService.java:88`) | `docs/faq-suporte.md:5`: "estorno em até 7 dias" | DEC-001 |
