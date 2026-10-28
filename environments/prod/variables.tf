variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type    = string
  default = "pulse-saas"
}

variable "container_image" {
  type    = string
  default = "public.ecr.aws/nginx/nginx:stable-alpine"
}
