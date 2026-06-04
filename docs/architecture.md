# Arquitetura do Sistema

## Diagrama de Arquitetura

```mermaid
graph TB
    Internet([Internet]) --> EIP[Elastic IP\n108.132.51.92]
    EIP --> GW[API Gateway\n:8080]
    
    GW -->|/api/users/**| US[User Service\n:8081]
    GW -->|/api/products/**| PS[Product Service\n:8082]
    GW -->|/api/orders/**| OS[Order Service\n:8083]
    
    US --> RDS[(RDS PostgreSQL\ntabela: users)]
    PS --> RDS
    OS --> RDS
    
    OS -->|OrderCreatedEvent| Kafka[Kafka\n:9092]
    Kafka -->|OrderCreatedEvent| PS
    
    PS -->|ProductCreatedEvent| SQS[AWS SQS\norder-created]
    SQS -->|ProductCreatedEvent| OS
```

## Componentes

### Rede (VPC)

| Componente | CIDR | Descrição |
|---|---|---|
| VPC | 10.0.0.0/16 | Rede principal |
| Subnet pública | 10.0.1.0/24 | EC2 + API Gateway |
| Subnet privada 1 | 10.0.3.0/24 | RDS (eu-west-1a) |
| Subnet privada 2 | 10.0.4.0/24 | RDS (eu-west-1b) |

### Security Groups

| Security Group | Regras de entrada | Propósito |
|---|---|---|
| sg-web | 22, 80, 443, 8080-8083 | EC2 |
| sg-db | 5432 (só do sg-web) | RDS |

### Compute

| Componente | Tipo | Descrição |
|---|---|---|
| EC2 | t3.small | Corre todos os containers |
| Elastic IP | 108.132.51.92 | IP fixo |
| IAM Role | ec2-role | Permissões SQS |

### Base de Dados

| Componente | Tipo | Descrição |
|---|---|---|
| RDS | PostgreSQL 16 | db.t3.micro |
| Tabelas | users, products, orders, order_items | Criadas automaticamente pelo Hibernate |

### Mensageria

| Componente | Tipo | Fluxo |
|---|---|---|
| Kafka | Confluent 7.5.0 | order-service → product-service |
| SQS | AWS Standard | product-service → order-service |
| DLQ | AWS Standard | Mensagens falhadas (max 3 tentativas) |

## Fluxos de Comunicação

### Fluxo Síncrono (HTTP)