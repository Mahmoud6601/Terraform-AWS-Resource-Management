# Day-2 Operations & Recovery Runbook

## 1. Pre-Change State Backup
```bash
./scripts/backup-state.sh prod
```

## 2. State Lock Recovery
If a CI runner dies mid-apply leaving a stale lock:
1. Verify no GitHub Actions `deploy.yml` run is currently executing.
2. Copy the `Lock ID` from the Terraform error message.
3. Run:
   ```bash
   terraform -chdir=environments/prod force-unlock <LOCK_ID>
   ```
4. Immediately run `terraform -chdir=environments/prod plan` to inspect actual AWS state.

## 3. Drift Remediation
When `.github/workflows/drift-detection.yml` opens an `infra-drift` issue:
1. Inspect the refresh-only plan output in the workflow run.
2. Decide whether to revert the manual AWS console change (re-run `deploy.yml`) or codify the intended change in HCL via PR.

## 4. Zero-Downtime AMI Rotation
Because `modules/ec2_instance` resolves the latest Amazon Linux 2023 AMI via SSM Parameter Store and configures `instance_refresh { strategy = "Rolling" }`, applying a plan after a new AL2023 release automatically rolls instances while maintaining `min_healthy_percentage = 50`.
