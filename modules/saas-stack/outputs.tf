output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "Public DNS endpoint of the Application Load Balancer"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.assets.domain_name
  description = "CloudFront CDN domain serving static assets"
}

output "assets_bucket_name" {
  value       = aws_s3_bucket.assets.bucket
  description = "Private S3 bucket backing the CloudFront distribution"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "ECS Fargate cluster name"
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "Private RDS PostgreSQL endpoint"
}

output "db_secret_arn" {
  value       = aws_secretsmanager_secret.db_url.arn
  description = "Secrets Manager ARN holding the DATABASE_URL connection string"
}
