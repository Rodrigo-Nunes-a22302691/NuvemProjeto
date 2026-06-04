# Projeto de Microserviços

Aplicação de microserviços cloud-native deployada na AWS, desenvolvida para a disciplina de Cloud Information Systems na Universidade Lusófona.

## Visão Geral da Arquitetura

Quatro microserviços Spring Boot a comunicar via HTTP (Feign) e mensagens assíncronas (Kafka + SQS), deployados em AWS EC2 com RDS PostgreSQL.
O tipo de approach usado para o projeto foi o A.

## Serviços

| Serviço | Porta | Descrição |
|---|---|---|
| api-gateway | 8080 | Ponto de entrada único, encaminha pedidos |
| user-service | 8081 | CRUD de utilizadores, PostgreSQL |
| product-service | 8082 | CRUD de produtos, publisher SQS, consumer Kafka |
| order-service | 8083 | CRUD de orders, producer Kafka, consumer SQS |

## Infraestrutura

- **Cloud:** AWS (eu-west-1)
- **Compute:** EC2 t3.medium
- **Base de dados:** RDS PostgreSQL
- **Mensagens:** SQS + Kafka
- **IaC:** Terraform com remote state (S3 + DynamoDB)
- **CI/CD:** GitHub Actions com OIDC

## Início Rápido

### Pré-requisitos

- Conta AWS com credenciais configuradas
- Terraform >= 1.0
- Docker + Docker Compose
- Ansible

### Deploy da Infraestrutura

```bash
cd infrastructure/terraform
terraform init
terraform workspace select dev
terraform apply
```
Ou um commit para o `main` o pipeline CI/CD trata da infraestrutura automaticamente.

### Deploy dos Serviços

Faz push para a branch `main` — o pipeline CI/CD trata de tudo automaticamente:

## Pipeline CI/CD
PR: gitleaks → test → terraform plan

Push main:  gitleaks → test → terraform apply → build → deploy (Necessita de aprovaçao de um reviewer)

## Segurança

- IAM roles para EC2 (sem credenciais estáticas)
- OIDC para autenticação GitHub Actions → AWS
- Secrets via GitHub Secrets
- Scan de credenciais com Gitleaks em cada push
- Security groups por camada de serviço