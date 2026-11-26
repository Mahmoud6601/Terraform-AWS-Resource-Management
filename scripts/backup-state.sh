#!/usr/bin/env bash
# Back up Terraform state for an environment with gzip compression and SHA-256 checksum.
# Usage: ./scripts/backup-state.sh <dev|staging|prod>
set -euo pipefail
cd "$(dirname "$0")/.."

ENV="${1:-}"
if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]]; then
  echo "Usage: $0 <dev|staging|prod>" >&2
  exit 1
fi

ENV_DIR="environments/${ENV}"
BACKUP_DIR="backups/${ENV}"
TIMESTAMP="$(date -u +%Y%m%d-%H%M%SZ)"
OUT_FILE="${BACKUP_DIR}/terraform-${ENV}-${TIMESTAMP}.tfstate.gz"

mkdir -p "$BACKUP_DIR"

echo "Pulling Terraform state for '${ENV}'..."
RAW_STATE="$(terraform -chdir="$ENV_DIR" state pull)"
if [ -z "$RAW_STATE" ]; then
  echo "ERROR: Empty state returned for '${ENV}'." >&2
  exit 1
fi

printf '%s\n' "$RAW_STATE" | gzip -c > "$OUT_FILE"
sha256sum "$OUT_FILE" > "${OUT_FILE}.sha256"

echo "State backup complete: ${OUT_FILE}"
echo "Checksum recorded:     ${OUT_FILE}.sha256"
echo "Restore command:       ./scripts/restore-state.sh ${ENV} ${OUT_FILE}"
