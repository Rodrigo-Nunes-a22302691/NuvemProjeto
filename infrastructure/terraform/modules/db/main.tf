# Criacao da base de dados








# Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project}-${var.environment}-db-subnet-group"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "main" {
  identifier        = "${var.project}-${var.environment}-rds"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = var.instance_class
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.sg_id]

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name        = "${var.project}-${var.environment}-rds"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}