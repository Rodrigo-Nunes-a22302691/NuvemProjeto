# Projeto de Microserviços

Aplicação de microserviços cloud-native deployada na AWS, desenvolvida para a disciplina de Cloud Information Systems na Universidade Lusófona.

## Visão Geral da Arquitetura

Quatro microserviços Spring Boot a comunicar via HTTP (Feign) e mensagens assíncronas (Kafka + SQS), deployados em AWS EC2 com RDS PostgreSQL.

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

- Conta AWS
- Terraform >= 1.0
- Docker + Docker Compose
- Ansible

1. **S3 bucket** para o Terraform state:
```bash
aws s3api create-bucket \
  --bucket microservices-project-tf-state-eu-west-1 \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1
```

2. **DynamoDB table** para o state lock:
```bash
aws dynamodb create-table \
  --table-name microservices-project-tf-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-west-1
```

3. **Key Pair SSH** no AWS Console → EC2 → Key Pairs → criar `microservices-project-dev-key` e guardar o ficheiro `.pem`

4. **IAM Role `gha-deployer`** no AWS Console → IAM → Roles → criar role com trust policy para GitHub Actions OIDC e as seguintes policies:
    - `AmazonEC2FullAccess`
    - `AmazonRDSFullAccess`
    - `AmazonS3FullAccess`
    - `AmazonSQSFullAccess`
    - `AmazonDynamoDBFullAccess`
    - `IAMFullAccess`

---

### Configurar os GitHub Secrets

No repositório → **Settings** → **Secrets** → **Actions**:

| Secret | Descrição |
|---|---|
| `AWS_ROLE_TO_ASSUME` | ARN do role `gha-deployer` |
| `DOCKERHUB_USERNAME` | Username do Docker Hub |
| `DOCKERHUB_TOKEN` | Token de acesso do Docker Hub |
| `EC2_SSH_PRIVATE_KEY` | Conteúdo do ficheiro `.pem` |
| `DB_USERNAME` | Username da base de dados (ex: `dbadmin`) |
| `DB_PASSWORD` | Password da base de dados |

---

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