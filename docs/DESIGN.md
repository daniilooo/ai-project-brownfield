# Design da skill

## Fluxo

```text
EXISTING PROJECT
 → PREFLIGHT (inventário, profundidade, produção, branch de suporte, retomada)
 → DISCOVERY (projeto, regras, arquitetura)          — somente leitura
 → GAP ANALYSIS
 → DISCOVERY BRIEF (≤ 7 perguntas bloqueantes; não bloqueia o resto)
 → CONSOLIDATION (Vault, state, next action)
 → WORKFLOW ALIGNMENT (AI_WORKFLOW, GitFlow)
 → ROADMAP ALIGNMENT
 → MULTI-LLM (adapters, agentes, handoff)
 → VERIFY (check-scope, validate-vault, review)
 → CONTINUATION READY (para; não implementa)
```

## Estrutura

```text
skills/ai-project-brownfield/
├── SKILL.md            núcleo: princípios, regra de ouro, fases, formatos (≤ 500 linhas)
├── references/         lido sob demanda por fase (discovery, evidence, rules, arch, gaps,
│                       vault, gitflow, production, multi-llm, roadmap)
├── agents/             papéis canônicos + CONTRACTS.md + openai.yaml (metadados Codex)
├── templates/          root/ (AGENTS.md, CLAUDE.md), ai/ (HANDOFF, BOOTSTRAP_STATUS),
│                       adapters/ (subagente Claude), vault/ (núcleo + condicionais)
├── scripts/            discover.sh, check-scope.sh, validate-vault.sh (bash puro, sem deps)
└── examples/           projeto fictício completo após o bootstrap + brief + relatório
```

## Decisões

| # | Decisão | Motivo |
|---|---|---|
| D1 | `SKILL.md` curto + `references/` | Economia de contexto; a LLM carrega só a fase atual. Formato de skill suportado por Claude Code e Codex. |
| D2 | Pasta `agents/` contém `openai.yaml` **e** os cartões de papel | O Codex lê `agents/openai.yaml`; os demais `.md` são ignorados por ele e servem de fonte para `.ai/agents/` no projeto alvo. Mantém a estrutura pedida. |
| D3 | Vault canônico; `AGENTS.md` neutro; `CLAUDE.md` = `@AGENTS.md` | Uma única fonte; adapters sem regra duplicada. |
| D4 | Após o bootstrap o projeto **não depende da skill** | `AI_WORKFLOW.md` é instanciado completo no projeto; a skill só é necessária para (re)bootstrap. |
| D5 | Scripts em bash puro | Roda em Linux/macOS/WSL/Git Bash sem instalar nada; determinístico e testável. |
| D6 | `discover.sh` imprime caminhos/rótulos, nunca valores | Evita vazar segredos para o contexto da LLM e para o Vault. |
| D7 | `check-scope.sh` com allowlist (não denylist) | Seguro por padrão em qualquer stack; extensível via `BROWNFIELD_ALLOW`. |
| D8 | `PRODUCTION_SAFETY_MODE` padrão `ON` sem sinais | Falso positivo custa pouco; falso negativo pode custar produção. |
| D9 | Chaves estruturais em inglês, conteúdo no idioma do projeto | Permite validação automática e mantém a documentação legível pelo time. |
| D10 | Arquivos condicionais só com conteúdo | Evita Vault-cemitério; `validate-vault.sh` reprova arquivos só-template. |
| D11 | Gates: 3 + lista fechada de paradas | Reduz interrupções por microcorreções sem abrir mão de controle humano no que importa. |
| D12 | Commit local permitido; push/PR = GATE 3 | O bootstrap é reversível localmente; publicar é decisão humana. |
