# FASE 2 — BUSINESS RULE DISCOVERY

Objetivo: tornar explícitas as regras que, se quebradas, causam dano — especialmente as que
hoje só existem no código ou na cabeça de alguém.

## Fontes (em ordem de produtividade típica)

1. Testes de domínio/serviço (nomes e asserts descrevem regras).
2. Validators, guards, policies, specifications.
3. Enums e state machines (status, transições permitidas).
4. Services e entidades de domínio (condicionais com números mágicos, limites, cálculos).
5. Constraints e migrations (`NOT NULL`, `UNIQUE`, `CHECK`, FKs, defaults).
6. Contratos de API e códigos/mensagens de erro.
7. Controllers (autorização, pré-condições).
8. Documentação de produto/negócio.

## Registro

`vault/02_BUSINESS/BUSINESS_RULES.md`, agrupado por domínio:

| ID | DOMAIN | RULE | SOURCE | CONFIDENCE | INVARIANT? | SECURITY? | FINANCIAL? |
|---|---|---|---|---|---|---|---|

- `ID`: `BR-<DOMÍNIO>-<NNN>` (ex.: `BR-ORDER-001`). IDs são estáveis; nunca reutilize.
- `RULE`: frase verificável (“Pedido cancelado não pode ser reaberto”), não descrição de código.
- `CONFIDENCE`:
  - `CONFIRMED_RULE` — documentada **e** implementada/testada, ou confirmada por humano;
  - `INFERRED_RULE` — vista apenas no código ou apenas no teste;
  - `CONFLICTING_RULE` — doc diz uma coisa, código/teste outra (ou dois pontos do código divergem);
  - `UNKNOWN_RULE` — comportamento existe, intenção desconhecida (ex.: número mágico sem explicação).
- Invariantes (sempre verdadeiras) também vão para `INVARIANTS.md` com o mecanismo que as
  garante (constraint, teste, validação) ou `UNPROTECTED`.
- Transições de estado vão para `STATES_AND_TRANSITIONS.md` (Mermaid `stateDiagram-v2`).
- Quem pode fazer o quê vai para `AUTHORIZATION_MATRIX.md`.
- Termos do domínio vão para `GLOSSARY.md` (inclua sinônimos encontrados no código).

## Priorização

Primeiro: regras `FINANCIAL`, `SECURITY`, invariantes de dados e regras com estado.
Em projetos grandes não tente catalogar todas as regras — cubra os fluxos críticos e registre
domínios não cobertos como `UNKNOWN` no roadmap.

## Cuidados

- Código pode conter bug. Regra vista só no código é `INFERRED_RULE`, não lei.
- Não “corrija” regra durante o bootstrap. Divergência vira gap `BUSINESS_RULE` + decisão humana.
- Mudança de regra de negócio é sempre gate humano.
