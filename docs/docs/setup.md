# Configuração do Projeto

## Pré-requisitos

- Conta AWS com acesso programático
- Terraform >= 1.0
- Docker + Docker Compose
- Ansible
- Java 21
- Maven

## Configuração Inicial (Manual — só uma vez)

### 1 — Criar o S3 bucket para o Terraform state

```bash
aws s3api create-bucket \
  --bucket microservices-project-tf-state-eu-west-1 \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

aws s3api put-bucket-versioning \
  --bucket microservices-project-tf-state-eu-west-1 \
  --versioning-configuration Status=Enabled
```

### 2 — Criar a tabela DynamoDB para o state lock

```bash
aws dynamodb create-table \
  --table-name microservices-project-tf-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-west-1
```

### 3 — Criar o role IAM para o GitHub Actions (OIDC)

No AWS Console → IAM → Roles → criar role `gha-deployer` com:
- Trust policy para GitHub Actions OIDC
- Policies: AmazonEC2FullAccess, AmazonRDSFullAccess, AmazonS3FullAccess, AmazonSQSFullAccess, AmazonDynamoDBFullAccess, IAMFullAccess

### 4 — Criar Key Pair para SSH

No AWS Console → EC2 → Key Pairs → criar `microservices-project-dev-key`

## Configuração do GitHub

### Secrets necessários

| Secret | Descrição |
|---|---|
| `AWS_ROLE_TO_ASSUME` | ARN do role `gha-deployer` |
| `DOCKERHUB_USERNAME` | Username do Docker Hub |
| `DOCKERHUB_TOKEN` | Token de acesso do Docker Hub |
| `EC2_SSH_PRIVATE_KEY` | Conteúdo do ficheiro `.pem` |
| `EC2_HOST` | IP público da EC2 (Elastic IP) |
| `DB_HOST` | Endpoint do RDS |
| `DB_USERNAME` | Username da base de dados |
| `DB_PASSWORD` | Password da base de dados |
| `SQS_QUEUE_URL` | URL da fila SQS |

## Deploy da Infraestrutura

```bash
cd infrastructure/terraform
terraform init
terraform workspace new dev
terraform workspace select dev
terraform apply
```
Ou um commit para o `main` o pipeline CI/CD trata da infraestrutura automaticamente.
