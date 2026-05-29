variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "public_availability_zones" {
  description = "AZs para subnets públicas"
  type        = list(string)
  default     = ["eu-west-1a"]
}

variable "private_availability_zones" {
  description = "AZs para subnets privadas"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}