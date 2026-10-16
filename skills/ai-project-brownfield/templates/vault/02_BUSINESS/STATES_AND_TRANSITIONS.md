# STATES AND TRANSITIONS

<!-- TEMPLATE: condicional. Uma seção por entidade com estado. -->

## {{Entidade}}

Source: {{enum / state machine / migration}} · Confidence: {{...}}

```mermaid
stateDiagram-v2
  [*] --> {{ESTADO_A}}
  {{ESTADO_A}} --> {{ESTADO_B}}: {{evento}}
```

Transições proibidas conhecidas: {{...}}
