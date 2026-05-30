variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
}

variable "queue_name" {
  description = "Nome da fila SQS"
  type        = string
}

variable "max_receive_count" {
  description = "Número de tentativas antes de ir para DLQ"
  type        = number
  default     = 3
}

variable "visibility_timeout_seconds" {
  description = "Tempo em que a mensagem fica invisível após ser lida"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Tempo máximo que a mensagem fica na fila"
  type        = number
  default     = 86400
}

variable "receive_wait_time_seconds" {
  description = "Long polling "
  type        = number
  default     = 20
}