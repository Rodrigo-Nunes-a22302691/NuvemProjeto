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

variable "subnet_id" {
  description = "ID da subnet pública"
  type        = string
}

variable "sg_id" {
  description = "ID do Security Group web"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID da AMI (Amazon Machine Image)"
  type        = string
  default     = "ami-06422669907866d20"
}

variable "key_name" {
  description = "Nome do Key Pair para SSH"
  type        = string
}