# Infrastructure Provisioning Pipeline

GitHub Actions workflow for provisioning and managing the Reddit Clone AWS infrastructure via Terraform. The pipeline handles the full infrastructure lifecycle — planning, deploying, inspecting, and destroying resources — with a single manual trigger.

---

## Table of Contents

- [Workflow Overview](#workflow-overview)
- [Pipeline Architecture](#pipeline-architecture)
  - [Execution Flow](#execution-flow)
  - [Dual-Account Model](#dual-account-model)
- [Available Actions](#available-actions)
- [Step-by-Step Execution](#step-by-step-execution)
  - [Common Steps (Always Run)](#common-steps-always-run)
  - [Conditional Steps (Based on Selected Action)](#conditional-steps-based-on-selected-action)
- [Required Secrets](#required-secrets)
- [Managed Infrastructure](#managed-infrastructure)
- [How to Run](#how-to-run)
- [Best Practices](#best-practices)

---

## Workflow Overview

| Property | Value |
|---|---|
| **Workflow File** | `.github/workflows/infra.yml` |
| **Workflow Name** | Infrastructure Provisioning Workflow |
| **Trigger** | `workflow_dispatch` — manual execution only |
| **Runner** | `ubuntu-latest` |
| **Terraform Version** | `1.7.5` |
| **AWS Region** | `us-east-1` |
| **Permissions** | `contents: read` (repository checkout only) |

---

## Pipeline Architecture

### Execution Flow

Every run follows a common initialization sequence, then branches into the selected action:

```
┌──────────────┐    ┌──────────────┐    ┌──────────────────────┐    ┌──────────────────┐
│   Checkout   │───▶│   Setup      │───▶│   Configure AWS      │───▶│   Terraform      │
│   Code       │    │   Terraform  │    │   (State Account)    │    │   Init           │
│              │    │   v1.7.5     │    │                      │    │                  │
└──────────────┘    └──────────────┘    └──────────────────────┘    └────────┬─────────┘
                                                                             │
                                                                             ▼
                                                                    ┌──────────────────┐
                                                                    │   Terraform      │
                                                                    │   Validate       │
                                                                    └────────┬─────────┘
                                                                             │
                              ┌──────────────────┬───────────────────┬───────┴──────────┐
                              │                  │                   │                  │
                              ▼                  ▼                   ▼                  ▼
                       ┌────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
                       │   Plan     │    │   Apply     │    │   Outputs   │    │   Destroy   │
                       │  (preview) │    │  (deploy)   │    │  (inspect)  │    │  (teardown) │
                       └────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Dual-Account Model

The pipeline authenticates against **two separate AWS accounts** for strict separation of concerns:

```
GitHub Actions Runner
│
├── AWS Account #1: State Account
│   │   Credentials: STATE_AWS_ACCESS_KEY_ID / STATE_AWS_SECRET_ACCESS_KEY
│   │   Used during: terraform init
│   │
│   ├── S3 Bucket       →  reddit-nti-tfstate         (remote state storage)
│   └── DynamoDB Table   →  reddit-nti-tfstate-lock    (state locking)
│
└── AWS Account #2: Target Account
    │   Credentials: TARGET_AWS_ACCESS_KEY_ID / TARGET_AWS_SECRET_ACCESS_KEY
    │   Used during: terraform plan / apply / destroy
    │
    ├── VPC, Subnets, IGW, NAT Gateway
    ├── EKS Cluster + Managed Node Group
    ├── RDS PostgreSQL Instance
    ├── S3 Media/Static Bucket
    └── ECR Repositories (backend + frontend)
```

- **State Account** credentials are configured via `aws-actions/configure-aws-credentials@v4` and used by `terraform init` to access the S3 backend and DynamoDB lock.
- **Target Account** credentials are passed as Terraform `-var` flags during `plan`, `apply`, and `destroy` operations to provision or modify infrastructure resources.

---

## Available Actions

When triggering the workflow, you select one of these actions:

| Action | Terraform Command | Auto-Approve | Description |
|---|---|---|---|
| **`plan`** | `terraform plan -input=false` | N/A | Generates an execution plan. Shows what resources will be created, changed, or destroyed — without making any changes. |
| **`apply`** | `terraform apply -input=false -auto-approve` | Yes | Provisions or updates all infrastructure resources according to the current Terraform configuration. |
| **`outputs`** | `terraform output` | N/A | Displays the current values of all Terraform outputs (VPC ID, EKS endpoint, RDS endpoint, ECR URLs, etc.). |
| **`destroy`** | `terraform destroy -auto-approve` | Yes | Tears down all infrastructure resources managed by Terraform. **Use with extreme caution.** |

---

## Step-by-Step Execution

### Common Steps (Always Run)

These steps execute regardless of the selected action:

| # | Step | Action Used | Description |
|---|---|---|---|
| 1 | **Checkout Code** | `actions/checkout@v4` | Clones the repository to the runner |
| 2 | **Setup Terraform** | `hashicorp/setup-terraform@v3` | Installs Terraform `1.7.5` on the runner |
| 3 | **Configure AWS (State)** | `aws-actions/configure-aws-credentials@v4` | Configures AWS CLI credentials for the State Account to access S3 backend |
| 4 | **Terraform Init** | `terraform init` | Initializes the backend, downloads providers (`hashicorp/aws ~> 5.0`), and prepares the working directory |
| 5 | **Terraform Validate** | `terraform validate` | Validates all `.tf` configuration files for syntax and internal consistency |

### Conditional Steps (Based on Selected Action)

Only the step matching the selected action will execute:

| # | Step | Condition | Terraform Command | Description |
|---|---|---|---|---|
| 6 | **Terraform Plan** | `inputs.action == 'plan'` | `terraform plan -input=false -var="target_access_key=..." -var="target_secret_key=..."` | Generates a detailed execution plan showing all proposed changes |
| 7 | **Terraform Apply** | `inputs.action == 'apply'` | `terraform apply -input=false -auto-approve -var="target_access_key=..." -var="target_secret_key=..."` | Provisions infrastructure with automatic approval (no interactive prompt) |
| 8 | **Show Outputs** | `inputs.action == 'outputs'` | `terraform output` | Retrieves and prints all output values from the current state |
| 9 | **Terraform Destroy** | `inputs.action == 'destroy'` | `terraform destroy -auto-approve -var="target_access_key=..." -var="target_secret_key=..."` | Destroys all managed resources with automatic approval |

---

## Required Secrets

Configure these secrets in **Repository Settings → Secrets and variables → Actions** before running the workflow:

| Secret | AWS Account | Used In | Purpose |
|---|---|---|---|
| `STATE_AWS_ACCESS_KEY_ID` | State Account | `terraform init` | AWS access key for reading/writing Terraform state in S3 |
| `STATE_AWS_SECRET_ACCESS_KEY` | State Account | `terraform init` | AWS secret key for reading/writing Terraform state in S3 |
| `TARGET_AWS_ACCESS_KEY_ID` | Target Account | `plan` / `apply` / `destroy` | AWS access key for provisioning infrastructure resources |
| `TARGET_AWS_SECRET_ACCESS_KEY` | Target Account | `plan` / `apply` / `destroy` | AWS secret key for provisioning infrastructure resources |

> **Security Note:** Target account credentials are passed as `-var` flags to Terraform, not as environment variables, ensuring they are only used by the Terraform AWS provider and not exposed to other tools on the runner.

---

## Managed Infrastructure

The following AWS resources are provisioned and managed by this pipeline:

| Module | Resources |
|---|---|
| **VPC** | VPC, 2 Public Subnets, 2 Private Subnets, Internet Gateway, NAT Gateway, Elastic IP, 2 Route Tables, Route Table Associations |
| **EKS** | EKS Cluster, Managed Node Group, Cluster IAM Role, Node IAM Role, 2 Security Groups (Cluster SG + Node Group SG), Security Group Rules |
| **RDS** | RDS PostgreSQL Instance, DB Subnet Group, Security Group |
| **S3** | S3 Bucket, Bucket Policy, Versioning, Server-Side Encryption, Ownership Controls, Public Access Block |
| **ECR** | 2 ECR Repositories (`reddit-backend`, `reddit-frontend`) |

---

## How to Run

1. Go to the **Actions** tab in the GitHub repository
2. In the left sidebar, select **Infrastructure Provisioning Workflow**
3. Click the **Run workflow** button
4. Choose the target branch (typically `main`)
5. Select the desired action from the dropdown: `plan`, `apply`, `outputs`, or `destroy`
6. Click **Run workflow** to start execution
7. Monitor the workflow run — click on it to see real-time logs for each step

---

## Best Practices

| Practice | Description |
|---|---|
| **Plan before Apply** | Always run `plan` first to review the execution plan before running `apply` |
| **Review plan output** | Carefully inspect created/changed/destroyed resource counts in the plan output |
| **Protect destroy** | Only run `destroy` when you are absolutely certain — it removes all infrastructure |
| **Secret rotation** | Rotate AWS credentials periodically and update GitHub Secrets accordingly |
| **Branch protection** | Keep the workflow on the `main` branch and use branch protection rules |
| **State locking** | The DynamoDB lock table prevents concurrent modifications — never manually delete it |