variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets privadas"
  type        = list(string)
}

variable "sg_id" {
  description = "ID do Security Group db"
  type        = string
}

variable "db_name" {
  description = "Nome da base de dados"
  type        = string
  default     = "microservices"
}

variable "db_username" {
  description = "Username da base de dados"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password da base de dados"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Tipo de instância RDS"
  type        = string
  default     = "db.t3.micro"
}