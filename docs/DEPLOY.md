# Deployment & Promotion Guide

## 1. One-Time Remote State Bootstrap
```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
# Set state_bucket_name and optional github_repository = "owner/repo"
terraform init && terraform apply
```
Record `state_bucket_name`, `lock_table_name`, and (if enabled) `github_actions_role_arn`.

## 2. Configure GitHub Actions OIDC (Optional for CI/CD)
Set repository or environment variables in GitHub Settings → Environments (`dev`, `staging`, `prod`):
- `AWS_OIDC_ROLE_ARN`: IAM role ARN from `bootstrap` output
- `TF_STATE_BUCKET`: S3 state bucket name
- `AWS_REGION`: e.g., `us-east-1`

Enable **Required Reviewers** on the `staging` and `prod` GitHub Environments.

## 3. Environment Promotion Flow
1. Open a Pull Request targeting `main`. CI runs `secret-and-hygiene-scan`, `fmt-and-validate`, `tflint`, `checkov`, `trivy config`, `shellcheck`, and all 7 `terraform test` suites.
2. Merge to `main`.
3. Trigger `.github/workflows/deploy.yml` with `environment=dev, action=plan`, inspect the plan, then run `action=apply`.
4. Verify `/healthz` on the `dev` ALB DNS name.
5. Repeat promotion for `staging` and `prod` through manual reviewer gates.

## 4. Rollback Procedure
1. Revert the bad commit via `git revert <commit-sha>` and open a PR.
2. Run `terraform plan` to confirm only the intended resources change.
3. Apply the reverted configuration.
4. If state itself became corrupted during a failed operation, restore the pre-apply snapshot using `./scripts/restore-state.sh <env> <backup.tfstate.gz>`.
