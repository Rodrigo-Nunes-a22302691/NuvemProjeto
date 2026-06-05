# Guia de Deploy

## Deploy Automático

O deploy é totalmente automatizado via GitHub Actions. 

Basta simplesmente configurar os github secrets


E depois fazer push para `main`, e ser aprovado por um reviewer:

```bash
git push origin main
```

O pipeline executa automaticamente:
- gitleaks    → scan de credenciais
- test        → testes unitários (4 serviços em paralelo)
- terraform   → valida, formata e aplica infraestrutura
- build       → constrói e publica imagens Docker (latest + SHA)
- deploy      → Ansible faz deploy na EC2 (requer aprovação manual)