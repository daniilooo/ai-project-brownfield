# EVIDENCE MODEL

Toda descoberta relevante registra:

```text
SOURCE      onde foi visto (arquivo:linha, comando, commit, humano@data)
EVIDENCE    o que foi visto, em uma frase
CONFIDENCE  CONFIRMED | INFERRED | CONFLICTING | UNKNOWN
```

Em tabelas do Vault use as colunas `Source | Evidence | Confidence`. Em texto corrido use o
sufixo `[CONFIRMED — pom.xml:42]`.

## Classificação

| Valor | Critério |
|---|---|
| `CONFIRMED` | (a) duas fontes independentes concordam (ex.: código + teste, config + pipeline), ou (b) fonte autoritativa direta (config efetiva, migration aplicada no histórico, contrato publicado), ou (c) confirmação humana registrada |
| `INFERRED` | uma fonte indireta: nome de classe, convenção, comentário, padrão de pastas, doc sem confirmação no código |
| `CONFLICTING` | fontes relevantes divergem |
| `UNKNOWN` | nenhuma evidência suficiente — ainda assim registre se a lacuna importa |

## Regras

1. **Nunca promova em silêncio.** `INFERRED → CONFIRMED` exige nova evidência ou humano,
   registrados no `SOURCE`.
2. **Conflito não se resolve escolhendo o mais conveniente.** Registre as duas versões; se
   tiver impacto, abra item em `OPEN_DECISIONS.md`.
3. **Comportamento × intenção.** Para *o que o sistema faz*, código/config/testes que passam
   pesam mais. Para *o que o sistema deveria fazer*, decisões humanas e docs de produto pesam
   mais. Divergência entre os dois é um gap (`BUSINESS_RULE` ou `DOCUMENTATION`), não um erro
   automático do código.
4. **Precedência ao descrever o estado atual** (do mais forte ao mais fraco):
   humano confirmado > config/pipeline efetivos > código + teste > código > migrations/schema >
   contrato de API > doc recente > doc antiga > nomes/convenções > comentários.
5. **Datas importam.** Doc com último commit muito anterior ao código que descreve é
   evidência fraca.
6. **Sem segredos.** Evidência é caminho + chave, nunca valor.

## Exemplo

| Item | Source | Evidence | Confidence |
|---|---|---|---|
| Banco principal | `docker-compose.yml:12`, `application.yml:8` | imagem `postgres:15` e URL `jdbc:postgresql` | CONFIRMED |
| Banco principal (doc) | `README.md:30` | README cita MySQL | CONFLICTING (doc desatualizada?) |
| Cache | `pom.xml:77` | dependência `spring-boot-starter-data-redis`, sem config encontrada | INFERRED |
| Fila | — | nenhuma dependência ou config | UNKNOWN |
