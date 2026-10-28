variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "app_name" {
  type        = string
  description = "Application slug used for resource naming"
}

variable "environment" {
  type        = string
  description = "Deployment environment (staging, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "Primary VPC IPv4 CIDR"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to span"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Use a single NAT Gateway in staging to reduce monthly AWS cost"
}

variable "container_image" {
  type        = string
  description = "Docker image URI for the ECS Fargate service"
}

variable "container_port" {
  type        = number
  default     = 8080
  description = "Port exposed by the application container"
}

variable "health_check_path" {
  type        = string
  default     = "/healthz"
  description = "ALB target group health check path"
}

variable "task_cpu" {
  type        = number
  default     = 512
  description = "Fargate CPU units (256, 512, 1024, 2048)"
}

variable "task_memory" {
  type        = number
  default     = 1024
  description = "Fargate memory in MiB"
}

variable "min_capacity" {
  type        = number
  default     = 2
  description = "Minimum Fargate tasks"
}

variable "max_capacity" {
  type        = number
  default     = 10
  description = "Maximum Fargate tasks under CPU autoscaling"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t4g.medium"
  description = "RDS PostgreSQL instance type"
}

variable "db_allocated_storage" {
  type        = number
  default     = 20
  description = "Initial gp3 storage in GiB"
}

variable "db_multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ standby replica for RDS"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags applied to all resources"
}
