terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }

  # Uncomment once remote state S3 bucket & DynamoDB table are created
  # backend "s3" {
  #   bucket         = "acme-saas-tfstate-us-east-1"
  #   key            = "prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "acme-saas-tfstate-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

module "saas" {
  source = "../../modules/saas-stack"

  aws_region  = var.aws_region
  app_name    = var.app_name
  environment = "prod"

  vpc_cidr           = "10.20.0.0/16"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  single_nat_gateway = false

  container_image = var.container_image
  container_port  = 8080
  task_cpu        = 512
  task_memory     = 1024
  min_capacity    = 2
  max_capacity    = 12

  db_instance_class    = "db.t4g.medium"
  db_allocated_storage = 50
  db_multi_az          = true

  tags = {
    Environment = "prod"
    Application = var.app_name
    ManagedBy   = "terraform"
  }
}

output "alb_dns_name" {
  value = module.saas.alb_dns_name
}

output "cloudfront_domain_name" {
  value = module.saas.cloudfront_domain_name
}

output "db_secret_arn" {
  value = module.saas.db_secret_arn
}
