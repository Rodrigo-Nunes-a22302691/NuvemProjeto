# Criacao de toda a estrutura da VPC,
# VPC
# A internet gateAway para poder comunicar com a internet
# As subnets dentro da VPC, uma publica outra privada
# Configuraçao da route table, para depois associar a internet gateAway
# E por fim os SG, para depois as instancias herdarem








# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}









# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}









# Subnets
# Subnet pública
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.public_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}


# Subnet privada
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.private_availability_zones[count.index]

  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}









# Route table
# Route table pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}


# Associar subnet pública à route table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}








# Security Groups
# Security Group: web (EC2)
resource "aws_security_group" "web" {
  name        = "${var.project}-${var.environment}-sg-web"
  description = "Security group para EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Microservices"
    from_port   = 8080
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-sg-web"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}


# Security Group: db (RDS)
resource "aws_security_group" "db" {
  name        = "${var.project}-${var.environment}-sg-db"
  description = "Security group para RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL apenas do SG web"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-sg-db"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}