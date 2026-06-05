O deploy é totalmente automatizado via GitHub Actions.

### Pré-requisitos manuais (só uma vez)

Antes de começar, é necessário criar manualmente na AWS:

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

### Deploy

Basta fazer push para `main` e ser aprovado por um reviewer — o pipeline CI/CD trata de tudo automaticamente:

```
gitleaks → test → terraform apply → build → deploy
```