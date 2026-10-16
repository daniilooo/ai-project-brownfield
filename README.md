# ai-project-brownfield

Skill para preparar projetos de software **já existentes** para desenvolvimento AI-native, com descoberta baseada em evidências, base de conhecimento em Obsidian, workflow multi-LLM, agentes, gates humanos, GitFlow existente preservado e foco em continuar entregando com segurança.

## Qual problema resolve?

Projetos existentes carregam anos de código, regras de negócio espalhadas, documentação incompleta, decisões presas em conversas, pipelines, ambientes, dívida técnica e, muitas vezes, produção ativa. Quando uma LLM entra nesse projeto, ela costuma perguntar o que poderia descobrir sozinha, contradizer decisões já tomadas, sugerir arquitetura incompatível, aplicar padrões de projeto novo, recriar documentação e perder contexto ao trocar de modelo.

## Como resolve?

A skill segue o princípio **DISCOVER BEFORE ASKING**: antes de perguntar, inspeciona. Ela faz um inventário somente leitura do repositório, descobre stack, arquitetura, regras de negócio, testes, CI/CD, ambientes, sinais de produção e GitFlow, e registra cada descoberta com fonte e grau de confiança (`CONFIRMED`, `INFERRED`, `CONFLICTING`, `UNKNOWN`).

Depois consolida esse conhecimento em um Vault versionado no próprio projeto, compara o que existe com o que está documentado, testado e operado (gap analysis), alinha o workflow e o roadmap existentes e prepara adapters finos para diferentes LLMs. O engenheiro só é consultado sobre o que o projeto não consegue responder sozinho — em um único checkpoint, com no máximo sete perguntas.

```text
PROJETO EXISTENTE → DISCOVERY → CONSOLIDAÇÃO → GAP ANALYSIS
                  → ALINHAMENTO DO WORKFLOW → ALINHAMENTO DO ROADMAP → PRONTO PARA CONTINUAR
```

Durante todo o processo a skill **não altera código de produto**: backend, frontend, migrations, APIs, infraestrutura, pipelines, feature flags, segredos e dados ficam intocados. Se detectar sinais de produção, ativa automaticamente o `PRODUCTION_SAFETY_MODE` (sem deploy, migration, mutação de dados, mudança de flag ou de infraestrutura).

O Obsidian é a interface para navegar pelo conhecimento. Os arquivos Markdown continuam acessíveis pelo terminal, Git e outras ferramentas.

## O que entrega?

- Inventário do projeto em `.ai/discovery/INVENTORY.md`.
- Vault Obsidian com mapa do projeto, regras de negócio classificadas, arquitetura atual, GitFlow existente, estratégia de testes, gaps, dívida técnica, riscos e decisões em aberto.
- `CURRENT_STATE.md` curto, para uma nova LLM entender o projeto em poucos minutos.
- `NEXT_ACTION.md` com **uma** próxima ação, critérios de aceite, risco e gates.
- Workflow `PLAN → BUILD → VERIFY → SHIP` com modelo de risco (`LOW`, `MEDIUM`, `HIGH`) e três gates humanos.
- Roadmap existente preservado e reconciliado em `vault/11_ROADMAP/DEVELOPMENT_PLAN.md`.
- `AGENTS.md` como entrada neutra e `CLAUDE.md` importando-o, sem regras duplicadas.
- Agentes e contratos de comunicação apenas quando fizerem sentido para o projeto.
- Handoff curto em `.ai/HANDOFF.md` para trocar de Claude para Codex (e vice-versa) sem perder contexto.

Documentação já existente no projeto é referenciada, não recriada. Arquivos do Vault só são criados quando há conteúdo real.

Ao concluir, a skill apresenta o relatório `CONTINUATION READY` e aguarda o engenheiro iniciar a próxima ação.

## Conteúdo e compatibilidade

O arquivo `skills/ai-project-brownfield/SKILL.md` contém o fluxo principal. Os detalhes de cada fase ficam em `references/` e são lidos apenas quando necessários, para economizar contexto. A pasta da skill também traz `agents/` (papéis e contratos), `templates/` (Vault, adapters e handoff), `scripts/` (inventário e verificações) e `examples/` (um projeto fictício após o bootstrap).

| Script | Função |
|---|---|
| `discover.sh` | inventário somente leitura de um ou mais repositórios; nunca imprime valores de configuração |
| `check-scope.sh` | confirma que só material de suporte foi alterado (nenhum código de produto) |
| `validate-vault.sh` | confirma que o Vault está completo, curto e sem segredos |

A mesma pasta é utilizada no Claude Code e no Codex. A skill fornece instruções; suporte a subagentes, seleção de modelos, MCPs e execução entre fornecedores depende das capacidades e permissões reais do ambiente. Instalar esta skill não instala as LLMs nem conecta contas.

A skill é independente e não depende de nenhuma outra skill para funcionar. Depois do bootstrap, o projeto também não depende dela: o workflow fica documentado no próprio Vault.

## Pré-requisitos

- Git.
- Claude Code e/ou Codex instalados e autenticados.
- `bash` para os scripts (Linux, macOS, WSL ou Git Bash no Windows). Sem bash, a LLM faz o inventário e as verificações manualmente.
- Acesso de escrita ao projeto que receberá o bootstrap (apenas para arquivos de documentação e suporte).
- Obsidian para navegar visualmente pelo Vault gerado, quando desejado.

## Baixar o repositório

```bash
git clone https://github.com/daniilooo/ai-project-brownfield.git
cd ai-project-brownfield
```

Os comandos de instalação abaixo partem da raiz deste repositório. Copie a **pasta inteira** da skill.

## Instalação no Linux ou macOS

### Claude Code — todos os projetos da máquina

```bash
mkdir -p "$HOME/.claude/skills"
cp -R skills/ai-project-brownfield "$HOME/.claude/skills/"
```

### Codex — todos os projetos da máquina

```bash
mkdir -p "$HOME/.agents/skills"
cp -R skills/ai-project-brownfield "$HOME/.agents/skills/"
```

### Instalação somente em um projeto

Substitua o caminho pelo projeto que receberá a skill:

```bash
projeto_destino="/caminho/do/seu/projeto"
mkdir -p "$projeto_destino/.claude/skills" "$projeto_destino/.agents/skills"
cp -R skills/ai-project-brownfield "$projeto_destino/.claude/skills/"
cp -R skills/ai-project-brownfield "$projeto_destino/.agents/skills/"
```

Escolha instalação pessoal ou por projeto conforme sua necessidade. Evite instalar duas cópias com o mesmo nome no mesmo ambiente. A instalação por projeto adiciona arquivos ao repositório do projeto; se o time não quiser versioná-los, prefira a instalação pessoal.

## Instalação no Windows — PowerShell

### Instalação pessoal

```powershell
New-Item -ItemType Directory -Force -Path "$HOME/.claude/skills", "$HOME/.agents/skills" | Out-Null
Copy-Item -Recurse -Path "./skills/ai-project-brownfield" -Destination "$HOME/.claude/skills/"
Copy-Item -Recurse -Path "./skills/ai-project-brownfield" -Destination "$HOME/.agents/skills/"
```

Você pode executar apenas a cópia correspondente à ferramenta que utiliza.

### Instalação somente em um projeto

```powershell
$projetoDestino = "C:/Projetos/meu-projeto"
New-Item -ItemType Directory -Force -Path "$projetoDestino/.claude/skills", "$projetoDestino/.agents/skills" | Out-Null
Copy-Item -Recurse -Path "./skills/ai-project-brownfield" -Destination "$projetoDestino/.claude/skills/"
Copy-Item -Recurse -Path "./skills/ai-project-brownfield" -Destination "$projetoDestino/.agents/skills/"
```

## Uso no Claude Code

Abra o terminal na pasta do **projeto existente** e inicie:

```bash
claude
```

Na sessão, use:

```text
/ai-project-brownfield
```

Você também pode dar contexto:

```text
/ai-project-brownfield Analise este projeto existente e prepare sua base AI-native.
```

Se o sistema for composto por mais de um repositório, informe-os:

```text
/ai-project-brownfield O sistema é composto por este repositório e por ../web e ../worker.
```

## Uso no Codex

Abra o terminal na pasta do **projeto existente** e inicie:

```bash
codex
```

Na sessão, use:

```text
$ai-project-brownfield
```

Ou solicite explicitamente:

```text
Use a skill ai-project-brownfield para analisar este projeto existente e preparar sua base AI-native.
```

Se a skill não aparecer, confira se existe `SKILL.md` dentro da pasta instalada e abra uma nova sessão. A cópia em `~/.claude/skills/` se destina ao Claude Code local; a instalação em Cowork e sessões cloud utiliza mecanismos próprios da plataforma.

## Como será a execução?

1. A LLM cria uma branch de suporte seguindo a convenção do projeto e roda o inventário.
2. Descobre stack, arquitetura, regras de negócio, testes, pipelines, ambientes, produção e GitFlow — sem perguntar o que o repositório já responde.
3. Apresenta um **Discovery Brief** de uma página com achados, conflitos, principais gaps e até sete perguntas realmente bloqueantes. Responda o que souber; o restante vira decisão em aberto.
4. A LLM gera o Vault, o estado atual, a próxima ação, o workflow, o GitFlow documentado, o roadmap reconciliado, os adapters e o handoff.
5. Os scripts verificam que nenhum código de produto foi alterado e que o Vault está válido.
6. Abra a pasta `vault/` como Vault no Obsidian e navegue por `00_HOME/START_HERE.md`.
7. Revise `CURRENT_STATE.md`, `OPEN_DECISIONS.md` e `NEXT_ACTION.md` antes de continuar o desenvolvimento.

Push, abertura de PR/MR e merge da branch de suporte dependem da sua autorização. A skill não começa a implementar a próxima ação ao terminar.

## Continuar o desenvolvimento e trocar de LLM

Depois do bootstrap a skill não é mais necessária no dia a dia. Em qualquer ferramenta, peça:

```text
Leia AGENTS.md e execute a NEXT_ACTION.
```

Para trocar de Claude para Codex (ou o contrário), peça à LLM atual para atualizar o handoff e, na nova ferramenta:

```text
Leia AGENTS.md e continue a partir de .ai/HANDOFF.md.
```

## Atualizar a instalação

Na cópia deste repositório:

```bash
git pull --ff-only
```

Depois copie novamente a pasta da skill para o destino escolhido. Preserve eventuais personalizações antes de substituir arquivos.

## Desinstalar

Remova apenas a pasta `ai-project-brownfield` do local em que a instalou. Isso remove a skill, mas mantém os artefatos já gerados nos projetos.

## Testes da skill

```bash
tests/run.sh
```

Valida a estrutura da skill e os scripts em projetos de exemplo (projeto simples, multirepo, GitFlow existente, produção ativa, documentação conflitante, regras de negócio, arquitetura existente, pouca documentação, CI/CD, feature flags, dívida técnica e projeto já preparado). Os cenários de comportamento da LLM, incluindo trocas Claude ↔ Codex, estão em `tests/scenarios/`.

## Limites e próximos passos

- O resultado deve ser conferido em um projeto piloto; os testes validam scripts e formato, mas não comprovam a execução completa em todas as ferramentas.
- Os cenários de comportamento em `tests/scenarios/` ainda precisam ser executados no Claude Code e no Codex e registrados em `docs/EVAL_LOG.md`.
- O inventário detecta sinais por nomes de arquivos e palavras-chave; a classificação final é da LLM, com evidência.
- Regras de proteção de branch e configurações da plataforma Git só são lidas se houver MCP ou CLI autorizado.
- Em bases muito grandes a cobertura é deliberadamente parcial: domínios críticos primeiro, o restante entra no roadmap.

Mais detalhes em `docs/REFERENCE_ANALYSIS.md`, `docs/DESIGN.md` e `docs/TESTING.md`.

## Licença

MIT — ver `LICENSE`.

## Documentação oficial

- [Skills no Codex](https://learn.chatgpt.com/docs/build-skills)
- [Skills no Claude Code](https://code.claude.com/docs/en/skills)
