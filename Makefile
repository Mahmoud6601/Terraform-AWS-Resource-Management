.PHONY: help fmt validate lint security test init plan apply destroy backup-state

ENV ?= dev
ENV_DIR := environments/$(ENV)
BACKEND_CFG := $(ENV_DIR)/backend.hcl
TFVARS_FILE := $(ENV_DIR)/terraform.tfvars

help:
	@echo "aws-terraform-platform — Available Targets"
	@echo "  make fmt                     Format all Terraform files"
	@echo "  make validate                Validate bootstrap and all environments (no AWS creds)"
	@echo "  make lint                    Run TFLint recursively"
	@echo "  make security                Run Checkov and Trivy Config scans"
	@echo "  make test                    Run native Terraform unit tests (mocked AWS)"
	@echo "  make init ENV=dev            Initialize environment with backend.hcl"
	@echo "  make plan ENV=dev            Plan changes for environment"
	@echo "  make apply ENV=dev           Apply planned changes for environment"
	@echo "  make destroy ENV=dev         Destroy environment resources"
	@echo "  make backup-state ENV=dev    Back up environment Terraform state"

fmt:
	terraform fmt -recursive

validate:
	./scripts/validate-all.sh --validate-only

lint:
	tflint --init && tflint --recursive

security:
	checkov -d . --config-file .checkov.yaml
	trivy config --severity HIGH,CRITICAL --exit-code 1 .

test:
	@for dir in modules/vpc modules/security_group modules/s3_bucket modules/ec2_instance environments/dev; do \
		terraform -chdir=$$dir init -backend=false -input=false >/dev/null && \
		terraform -chdir=$$dir test -verbose; \
	done

init:
	terraform -chdir=$(ENV_DIR) init -backend-config=backend.hcl -reconfigure

plan:
	terraform -chdir=$(ENV_DIR) plan -var-file=terraform.tfvars -out=tfplan

apply:
	./scripts/backup-state.sh $(ENV) || true
	terraform -chdir=$(ENV_DIR) apply tfplan

destroy:
	terraform -chdir=$(ENV_DIR) destroy -var-file=terraform.tfvars

backup-state:
	./scripts/backup-state.sh $(ENV)
