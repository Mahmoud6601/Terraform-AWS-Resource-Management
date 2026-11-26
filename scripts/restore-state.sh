#!/usr/bin/env bash
# Restore Terraform state from a checksum-verified backup created by backup-state.sh.
# Usage: ./scripts/restore-state.sh <dev|staging|prod> <backups/.../file.tfstate.gz>
set -euo pipefail
cd "$(dirname "$0")/.."

ENV="${1:-}"
BACKUP_FILE="${2:-}"

if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]] || [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
  echo "Usage: $0 <dev|staging|prod> <backup-file.tfstate.gz>" >&2
  exit 1
fi

if [ -f "${BACKUP_FILE}.sha256" ]; then
  echo "Verifying SHA-256 checksum..."
  sha256sum -c "${BACKUP_FILE}.sha256"
fi

if [ "${RESTORE_FORCE:-0}" != "1" ]; then
  read -r -p "Push state backup '${BACKUP_FILE}' to '${ENV}' backend? This OVERWRITES remote state. [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) echo "Aborted."; exit 1 ;;
  esac
fi

TMP_STATE="$(mktemp)"
trap 'rm -f "$TMP_STATE"' EXIT
gunzip -c "$BACKUP_FILE" > "$TMP_STATE"

terraform -chdir="environments/${ENV}" state push "$TMP_STATE"
echo "State restore complete for '${ENV}'. Run 'terraform -chdir=environments/${ENV} plan' to verify."
