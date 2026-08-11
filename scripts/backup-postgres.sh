#!/usr/bin/env bash
# ==============================================================================
# Continuous Automated PostgreSQL Database Backup Script
# Dump, Gzip Compress, SHA256 Checksum, and S3 / Cloud Storage Upload
# ==============================================================================

set -eo pipefail

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="${BACKUP_DIR:-/tmp/dailybasket-backups}"
BACKUP_FILE="dailybasket_db_${TIMESTAMP}.sql.gz"
CHECKSUM_FILE="dailybasket_db_${TIMESTAMP}.sha256"
S3_BUCKET="${S3_BACKUP_BUCKET:-s3://daily-basket-db-backups-prod}"

mkdir -p "$BACKUP_DIR"

echo "📦 [Backup Engine] Starting PostgreSQL backup snapshot at ${TIMESTAMP}..."

# Execute pg_dump with custom format & compression
pg_dump "${DATABASE_URL}" | gzip -9 > "${BACKUP_DIR}/${BACKUP_FILE}"

# Generate SHA256 integrity checksum
sha256sum "${BACKUP_DIR}/${BACKUP_FILE}" > "${BACKUP_DIR}/${CHECKSUM_FILE}"

echo "✅ Backup archive created: ${BACKUP_FILE} ($(du -sh "${BACKUP_DIR}/${BACKUP_FILE}" | cut -f1))"
echo "🔒 SHA256 Checksum: $(cat "${BACKUP_DIR}/${CHECKSUM_FILE}")"

# Upload to S3 / Cloud Storage if AWS CLI is configured
if command -v aws &> /dev/null; then
  echo "☁️ Uploading backup archive to ${S3_BUCKET}..."
  aws s3 cp "${BACKUP_DIR}/${BACKUP_FILE}" "${S3_BUCKET}/${BACKUP_FILE}" --storage-class STANDARD_IA
  aws s3 cp "${BACKUP_DIR}/${CHECKSUM_FILE}" "${S3_BUCKET}/${CHECKSUM_FILE}"
  echo "🚀 Backup successfully uploaded to S3!"
else
  echo "ℹ️ AWS CLI not present. Backup stored locally at ${BACKUP_DIR}/${BACKUP_FILE}"
fi
