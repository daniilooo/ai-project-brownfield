# STATES AND TRANSITIONS

## Order

Source: `OrderStatus.java`, `OrderService.java:120-160` · Confidence: INFERRED (transições só no código)

```mermaid
stateDiagram-v2
  [*] --> CREATED
  CREATED --> PAID: pagamento capturado
  CREATED --> CANCELLED: cancelamento
  PAID --> CANCELLED: cancelamento (BR-ORDER-002)
  PAID --> SHIPPED: expedição
  SHIPPED --> DELIVERED: confirmação
```

Transições proibidas conhecidas: `SHIPPED → CANCELLED` (exceção `IllegalStateException`, `OrderService.java:142`).
