terraform {
  backend "s3" {
    bucket         = "microservices-project-tf-state-eu-west-1"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "microservices-project-tf-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source = "./modules/vpc"

  project     = "microservices-project"
  environment = terraform.workspace
}

module "compute" {
  source = "./modules/compute"

  project     = "microservices-project"
  environment = terraform.workspace
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_ids[0]
  sg_id       = module.vpc.sg_web_id
  key_name    = "microservices-project-dev-key"
}

module "db" {
  source = "./modules/db"

  project     = "microservices-project"
  environment = terraform.workspace
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
  sg_id       = module.vpc.sg_db_id
  db_password = "nuno2013"
  db_username = "dbadmin"
}

module "sqs" {
  source = "./modules/sqs"

  project     = "microservices-project"
  environment = terraform.workspace
  queue_name  = "order-created"
}