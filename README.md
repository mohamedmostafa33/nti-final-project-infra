# Reddit Clone Infrastructure

Enterprise-grade Terraform infrastructure for deploying a Reddit Clone application on AWS.

## Overview

This repository contains Infrastructure as Code (IaC) for deploying a complete production-ready environment on AWS. The infrastructure includes container orchestration with Amazon EKS, managed PostgreSQL database, S3 storage for media files, and container registry for application images.

## Architecture

The infrastructure is designed with high availability and security best practices:

- **VPC**: Dual-AZ architecture with public and private subnets
- **EKS Cluster**: Kubernetes cluster for application workload
- **RDS PostgreSQL**: Managed database service in private subnets
- **S3**: Object storage for static files and media content
- **ECR**: Private container registry for Docker images

## Prerequisites

- Terraform >= 1.7.5
- AWS CLI configured with appropriate credentials
- AWS Account with necessary permissions
- GitHub repository with Actions enabled (for automated deployments)

## Infrastructure Components

### VPC Module
- Custom VPC with configurable CIDR block (default: 10.0.0.0/16)
- Public subnets across two availability zones
- Private subnets across two availability zones
- Internet Gateway for public subnet access
- NAT Gateway for private subnet outbound traffic
- Route tables for proper traffic routing

### EKS Module
- Kubernetes cluster version 1.33
- Managed node groups with auto-scaling (2-3 nodes)
- IAM roles for cluster and worker nodes
- Security groups for cluster and node communication
- Both public and private API endpoint access

### RDS Module
- PostgreSQL 17.6 engine
- db.t3.micro instance class
- Automated backups disabled (development environment)
- Security groups configured for EKS access only
- Private subnet deployment
- Storage auto-scaling (20GB-100GB)

### S3 Module
- Bucket for static files and media storage
- Public read access for /staticfiles/* and /media/* paths
- Server-side encryption (AES256)
- Versioning enabled
- Bucket ownership controls enforced

### ECR Module
- Private container registry
- Mutable image tags for development flexibility

## Project Structure

```
infra/
├── main.tf              # Root module configuration
├── variables.tf         # Variable definitions
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
├── provider.tf          # AWS provider configuration
├── versions.tf          # Terraform version constraints
├── .github/
│   └── workflows/
│       └── infra.yml    # GitHub Actions workflow
└── modules/
    ├── ecr/             # Container registry module
    ├── eks/             # Kubernetes cluster module
    ├── rds/             # Database module
    ├── s3/              # Object storage module
    └── vpc/             # Network infrastructure module
```

## Usage

### GitHub Actions Workflow

The infrastructure can be managed through GitHub Actions for automated and consistent deployments.

#### Workflow Triggers

Navigate to **Actions** tab in GitHub repository and select **Infrastructure Provisioning Workflow**.

#### Available Actions

| Action | Description | Use Case |
|--------|-------------|----------|
| `plan` | Generate execution plan | Review changes before applying |
| `apply` | Apply infrastructure changes | Deploy or update infrastructure |
| `outputs` | Display Terraform outputs | Retrieve resource information |
| `destroy` | Remove all infrastructure | Clean up resources |

#### Workflow Features

- Automated AWS credential configuration
- Terraform initialization and validation
- Detailed step-by-step logging
- Supports multiple operations in isolated runs

#### Prerequisites for Workflow

Configure the following secrets in GitHub repository settings:

- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

#### Running Workflow

1. Go to Actions tab in GitHub
2. Select "Infrastructure Provisioning Workflow"
3. Click "Run workflow"
4. Choose desired action from dropdown
5. Click "Run workflow" button

### Manual Terraform Usage

For local development or testing:

#### Initialize Terraform

```bash
cd infra
terraform init
```

#### Review Infrastructure Plan

```bash
terraform plan
```

#### Deploy Infrastructure

```bash
terraform apply
```

#### Destroy Infrastructure

```bash
terraform destroy
```

## Configuration

### Core Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `cluster_name` | EKS cluster name | reddit-clone-eks-cluster |
| `eks_version` | Kubernetes version | 1.33 |
| `vpc_cidr_block` | VPC CIDR range | 10.0.0.0/16 |
| `db_engine_version` | PostgreSQL version | 17.6 |
| `node_instance_type` | EKS node instance type | t3.small |

### Customization

Edit `terraform.tfvars` to customize the deployment:

```hcl
cluster_name = "reddit-clone-eks-cluster"
eks_version = "1.33"
node_min_size = 3
node_max_size = 3
db_instance_class = "db.t3.micro"
```

## Outputs

The infrastructure provides the following outputs:

- **ECR Repository URL**: For pushing Docker images
- **S3 Bucket Name**: For application configuration
- **RDS Endpoint**: Database connection string
- **EKS Cluster Endpoint**: Kubernetes API server endpoint
- **VPC Details**: VPC ID, subnet IDs, and gateway information

## State Management

### Current Setup

Terraform state is stored locally in `terraform.tfstate` file. Suitable for individual development and testing.

### Remote State (Recommended for Teams)

For production and team collaboration, use S3 backend with DynamoDB locking:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "reddit-clone/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

**Benefits:**
- Team collaboration with automatic state locking
- State versioning and encryption
- Prevents concurrent modifications
- Works seamlessly with GitHub Actions workflow

**Important:** Never commit `terraform.tfstate` to version control.

## Security Considerations

- RDS database is deployed in private subnets only
- Database access is restricted to EKS security groups
- S3 bucket has restricted public access policies
- IAM roles follow least privilege principle
- Secrets should be managed via AWS Secrets Manager (not in tfvars)

## Network Configuration

### Subnet Allocation

| Subnet | CIDR | Type | AZ |
|--------|------|------|----|
| Public A | 10.0.1.0/24 | Public | us-east-1a |
| Private A | 10.0.2.0/24 | Private | us-east-1a |
| Public B | 10.0.3.0/24 | Public | us-east-1b |
| Private B | 10.0.4.0/24 | Private | us-east-1b |

## Database Configuration

- **Engine**: PostgreSQL 17.6
- **Instance**: db.t3.micro
- **Database Name**: redditclone
- **Username**: redditadmin
- **Storage**: 20GB (auto-scales to 100GB)
- **Multi-AZ**: Disabled (development)
- **Backups**: Disabled (development)

## EKS Cluster Details

- **Version**: 1.33
- **Node Type**: t3.small
- **Node Count**: 3 (min and max)
- **Endpoint Access**: Public and Private
- **Subnets**: Private subnets only

## Cost Optimization

For development environments, consider:
- Using smaller instance types for RDS (db.t3.micro)
- Reducing EKS node count to minimum (2 nodes)
- Implementing auto-scaling based on demand
- Enabling deletion protection only for production

## Maintenance

### Update Kubernetes Version

```hcl
eks_version = "1.34"  # Update in terraform.tfvars
```

### Scale Node Group

```hcl
node_min_size = 2
node_max_size = 5
```

## Troubleshooting

### EKS Access Issues
Ensure your AWS credentials have proper IAM permissions for EKS cluster access.

### RDS Connection Issues
Verify security groups allow traffic from EKS nodes to RDS on port 5432.

### S3 Access Issues
Check bucket policies and ensure public read access is properly configured for static content paths.