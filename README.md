# aws-ecs-fargate-saas

Modular AWS Terraform baseline for a containerized SaaS backend and static frontend. Provisions a 3-tier VPC, Application Load Balancer, autoscaled ECS Fargate service, Multi-AZ RDS PostgreSQL 16 instance wired via Secrets Manager, and a CloudFront + S3 Origin Access Control (OAC) CDN across isolated `staging` and `prod` environments with GitHub Actions OIDC GitOps workflows.

## Architecture

```text
                       +--- [CloudFront CDN (OAC)] ---> [Private S3 Assets Bucket]
                       |
[Clients] -- HTTPS ----+
                       |
                       +--- [Application Load Balancer (Public Subnets)]
                                         |
                                         v (Port 8080 only)
                            [ECS Fargate Service (Private App Subnets)]
                             ├── CPU Target Tracking Autoscaling
                             ├── Injects DATABASE_URL from Secrets Manager
                             └── ECS Exec enabled for debugging
                                         |
                                         v (Port 5432 only)
                            [RDS PostgreSQL 16 (Isolated DB Subnets)]
                             └── Multi-AZ gp3 encrypted storage
```

### Environment Parity & Cost Controls
Both `environments/staging` and `environments/prod` consume the same `modules/saas-stack` module with tuned sizing:

| Setting | `staging` | `prod` |
| :--- | :--- | :--- |
| Availability Zones | 2 AZs (`us-east-1a`, `1b`) | 3 AZs (`us-east-1a`, `1b`, `1c`) |
| NAT Gateways | Single shared NAT (`single_nat_gateway = true`) | Per-AZ NAT Gateways (HA egress) |
| Fargate Scaling | `1–4` tasks (`0.25 vCPU / 512 MiB`) | `2–12` tasks (`0.5 vCPU / 1 GiB`) |
| RDS PostgreSQL | Single-AZ `db.t4g.micro`, 3-day backups | Multi-AZ `db.t4g.medium`, 14-day backups, deletion protection |

## Repository Layout

```text
├── .github/workflows/
│   └── terraform.yml         # Keyless OIDC PR plan & main branch apply pipeline
├── modules/
│   └── saas-stack/           # Reusable VPC, ALB, ECS Fargate, RDS, Secrets Manager, S3/CloudFront
└── environments/
    ├── staging/              # Cost-optimized staging environment
    └── prod/                 # High-availability production environment
```

## Deployment

### Local CLI

```bash
cd environments/staging   # or environments/prod

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### GitHub Actions GitOps Pipeline

`.github/workflows/terraform.yml` runs `terraform fmt -check`, `validate`, and `plan` on pull requests against both environments using AWS IAM OIDC federation (no long-lived AWS access keys stored in GitHub). Pushing to `main` applies `staging` first and gates `prod` behind the `production` GitHub Environment protection rule.

Set two repository variables in GitHub (`Settings -> Secrets and variables -> Actions -> Variables`):
- `AWS_ROLE_ARN_STAGING`
- `AWS_ROLE_ARN_PROD`

## Requirements

- Terraform `>= 1.6.0`
- AWS Provider `~> 5.40`
- Random Provider `~> 3.6`
