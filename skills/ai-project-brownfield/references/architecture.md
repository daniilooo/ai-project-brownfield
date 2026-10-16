# FASE 3 — ARCHITECTURE DISCOVERY

Descreva a arquitetura **como ela é**. Não substitua arquitetura só porque existe outra mais
elegante. Recomendação de mudança só com problema concreto e evidência, registrada como gap
`ARCHITECTURE` com `HUMAN_DECISION_REQUIRED: yes`.

## O que documentar em `vault/03_ARCHITECTURE/SYSTEM_ARCHITECTURE.md`

| Seção | Conteúdo |
|---|---|
| `CURRENT_ARCHITECTURE` | estilo real (camadas, hexagonal, modular monolith, microserviços, serverless, misto) com evidência; onde o estilo é respeitado e onde não |
| `MODULES` | módulos/pacotes/serviços, responsabilidade, dono quando conhecido |
| `BOUNDARIES` | regras de dependência observadas (quem pode importar quem); violações encontradas |
| `DEPENDENCIES` | dependências internas e externas relevantes; versões de runtime/framework |
| `DATA_FLOW` | fluxos principais (diagrama Mermaid de sequência para 1–3 fluxos críticos) |
| `INTEGRATIONS` | resumo; detalhes em `INTEGRATIONS.md` |
| `SECURITY_BOUNDARIES` | onde ocorre autenticação, autorização, validação de entrada, fronteiras de confiança; detalhes em `SECURITY.md` |
| `DEPLOYMENT_MODEL` | como e onde roda; detalhes em `INFRASTRUCTURE.md` e `06_OPERATIONS/` |

Cada afirmação com `Source | Confidence`.

## Diagramas

Mermaid (renderiza no Obsidian, GitHub e GitLab). Um diagrama de contexto/contêiner
simplificado é suficiente; acrescente outros apenas se reduzirem incerteza.

## Modelo de dados

`DATA_MODEL.md`: entidades principais, relacionamentos, tabelas críticas, origem do schema
(migrations × ORM × DDL manual), estratégia de migrations. Não despeje o schema inteiro —
aponte para a fonte.

## ADRs

- ADRs existentes: **referencie** (não copie) a partir de `03_ARCHITECTURE/ADR/README.md`.
- Decisões descobertas mas nunca registradas: crie ADR retroativo com status
  `Accepted (retroactive)` e `CONFIDENCE`, somente para decisões que um novo executor poderia
  contradizer por desconhecimento.
- Template: `templates/vault/03_ARCHITECTURE/ADR/ADR_TEMPLATE.md`.
