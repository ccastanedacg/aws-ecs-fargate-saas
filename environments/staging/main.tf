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
  #   key            = "staging/terraform.tfstate"
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
  environment = "staging"

  vpc_cidr           = "10.10.0.0/16"
  azs                = ["us-east-1a", "us-east-1b"]
  single_nat_gateway = true

  container_image = var.container_image
  container_port  = 8080
  task_cpu        = 256
  task_memory     = 512
  min_capacity    = 1
  max_capacity    = 4

  db_instance_class    = "db.t4g.micro"
  db_allocated_storage = 20
  db_multi_az          = false

  tags = {
    Environment = "staging"
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
