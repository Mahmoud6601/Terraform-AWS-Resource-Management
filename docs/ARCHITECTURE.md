# Architecture & Network Design

## Design Principles
1. **Strict Environment Isolation:** `dev`, `staging`, and `prod` are independent Terraform root modules with separate S3 state keys—never shared workspaces.
2. **Zero Public Compute & Zero SSH:** All EC2 instances run in private subnets with `map_public_ip_on_launch = false`, no SSH key pairs, and no port 22 rules. Operator access uses AWS SSM Session Manager via IAM Instance Profiles.
3. **Defense-in-Depth Networking:** Internet traffic terminates at the public-subnet ALB (`alb-sg`). Private compute (`app-sg`) accepts HTTP strictly from `alb-sg` via security-group referencing—never broad CIDR blocks.
4. **Encryption Everywhere:** A per-environment rotating KMS CMK encrypts S3 objects, EBS root volumes, CloudWatch Log Groups (VPC Flow Logs + system logs), and SNS alert topics.

## CIDR Allocation Plan

| Environment | VPC CIDR | Public Subnets | Private App Subnets | Isolated Data Subnets |
| --- | --- | --- | --- | --- |
| `dev` | `10.10.0.0/16` | `10.10.1.0/24`, `10.10.2.0/24` | `10.10.11.0/24`, `10.10.12.0/24` | `10.10.21.0/24`, `10.10.22.0/24` |
| `staging` | `10.20.0.0/16` | `10.20.1.0/24`, `10.20.2.0/24` | `10.20.11.0/24`, `10.20.12.0/24` | `10.20.21.0/24`, `10.20.22.0/24` |
| `prod` | `10.30.0.0/16` | `10.30.1.0/24`, `10.30.2.0/24`, `10.30.3.0/24` | `10.30.11.0/24`, `10.30.12.0/24`, `10.30.13.0/24` | `10.30.21.0/24`, `10.30.22.0/24`, `10.30.23.0/24` |

## State & Locking Architecture
- Remote state is stored in the KMS-encrypted, versioned S3 bucket created by `bootstrap/`.
- Terraform `1.10+` native S3 lockfiles (`use_lockfile = true`) and a DynamoDB lock table prevent concurrent state corruption.
