output "db_endpoint" {
  description = "Endpoint de ligação ao RDS"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Nome da base de dados"
  value       = aws_db_instance.main.db_name
}

output "db_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.main.port
}