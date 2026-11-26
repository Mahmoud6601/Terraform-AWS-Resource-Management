# Security Controls & CIS AWS Foundations Mapping

| Control | Implementation | Reference |
| --- | --- | --- |
| **No Static Cloud Keys** | GitHub Actions OIDC federation (`sts:AssumeRoleWithWebIdentity`) in `bootstrap/main.tf`; zero access keys in code | CIS 1.12 / 1.14 |
| **KMS Key Rotation** | `enable_key_rotation = true` on all Customer Managed KMS keys (`modules/kms`, `bootstrap`) | CIS 3.6 |
| **S3 Public Access Block & TLS** | All 4 Public Access Block flags `true`, `BucketOwnerEnforced`, `aws:SecureTransport = false` Deny policy | CIS 2.1.1 / 2.1.4 |
| **Locked Default Security Group** | `aws_default_security_group` purged to zero ingress/egress rules in `modules/vpc` | CIS 5.3 |
| **Zero Unrestricted SSH/RDP** | Terraform variable `validation {}` in `modules/security_group` rejects `0.0.0.0/0` on ports 22 and 3389 | CIS 5.1 / 5.2 |
| **IMDSv2 & Encrypted EBS** | `http_tokens = "required"`, `hop_limit = 1`, `encrypted = true` (`gp3`) in `modules/ec2_instance` | AWS Well-Architected SEC06 |
| **ALB Header & TLS Hardening** | `drop_invalid_header_fields = true`, `ELBSecurityPolicy-TLS13-1-2-2021-06`, HTTP->HTTPS 301 redirect | AWS Well-Architected SEC09 |
| **VPC Flow Logs & Encrypted Logs** | `ALL` traffic captured to KMS-encrypted CloudWatch Log Group with retention | CIS 3.9 |
| **Automated Policy Gates** | Checkov, Trivy Config (`HIGH/CRITICAL` blocking), TFLint, and Gitleaks enforced in `.github/workflows/ci.yml` | Shift-Left Governance |
