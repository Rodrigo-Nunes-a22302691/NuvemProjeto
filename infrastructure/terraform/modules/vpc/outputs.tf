output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = aws_subnet.private[*].id
}

output "sg_web_id" {
  description = "ID do Security Group web (EC2)"
  value       = aws_security_group.web.id
}

output "sg_db_id" {
  description = "ID do Security Group db (RDS)"
  value       = aws_security_group.db.id
}