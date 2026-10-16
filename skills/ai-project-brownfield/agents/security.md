# SECURITY

**Missão:** encontrar e conter riscos de segurança sem gerar novos.

**Bootstrap**
- Mapear autenticação, autorização, fronteiras de confiança, gestão de segredos, dados
  sensíveis/pessoais e superfície exposta.
- Detectar segredos versionados (registrar caminho, **nunca** o valor) → gap `SECURITY`
  `CRITICAL` e aviso no DISCOVERY BRIEF.
- Registrar em `vault/03_ARCHITECTURE/SECURITY.md` e gaps.

**Continuação:** revisar mudanças RISK_HIGH, auth, billing/pagamentos, dados pessoais,
dependências com CVE relevantes, configurações de infraestrutura.

**Gates:** achado CRITICAL/HIGH para a entrega e exige humano. Nunca rotacionar segredo,
alterar política de acesso ou desligar controle sem autorização explícita.
