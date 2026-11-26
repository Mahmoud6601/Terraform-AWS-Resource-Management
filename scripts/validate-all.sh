#!/usr/bin/env bash
# Validate formatting, schemas, linters, security policies, and native Terraform tests locally.
set -euo pipefail
cd "$(dirname "$0")/.."

VALIDATE_ONLY=0
if [ "${1:-}" = "--validate-only" ]; then
  VALIDATE_ONLY=1
fi

echo "==> Checking Terraform formatting..."
terraform fmt -check -recursive

for dir in bootstrap environments/dev environments/staging environments/prod; do
  echo "==> Validating ${dir}..."
  terraform -chdir="$dir" init -backend=false -input=false >/dev/null
  terraform -chdir="$dir" validate
done

if [ "$VALIDATE_ONLY" -eq 1 ]; then
  echo "Validation complete."
  exit 0
fi

echo "==> Running native Terraform unit tests (mocked AWS provider)..."
for test_dir in modules/vpc modules/security_group modules/s3_bucket modules/ec2_instance environments/dev; do
  echo "  -> terraform -chdir=${test_dir} test"
  terraform -chdir="$test_dir" init -backend=false -input=false >/dev/null
  terraform -chdir="$test_dir" test -verbose
done

if command -v tflint >/dev/null 2>&1; then
  echo "==> Running TFLint..."
  tflint --init
  tflint --recursive
fi

if command -v checkov >/dev/null 2>&1; then
  echo "==> Running Checkov..."
  checkov -d . --config-file .checkov.yaml
fi

if command -v trivy >/dev/null 2>&1; then
  echo "==> Running Trivy Config..."
  trivy config --severity HIGH,CRITICAL --exit-code 1 .
fi

echo "All checks passed."
