#!/bin/bash
# ==================================================
# DAILY BASKET — AUTOMATED POSTGRESQL BACKUP SCRIPT
# ==================================================

set -e

BACKUP_DIR="${BACKUP_DIR:-/backups/postgres}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/daily_basket_backup_${TIMESTAMP}.sql.gz"

DB_HOST="${DB_HOST:-postgres}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_NAME="${POSTGRES_DB:-daily_basket}"
PGPASSWORD="${POSTGRES_PASSWORD:-prod_secure_password_2026}"
export PGPASSWORD

mkdir -p "$BACKUP_DIR"

echo "=================================================="
echo "Starting PostgreSQL Backup for $DB_NAME..."
echo "Timestamp: $TIMESTAMP"
echo "Target File: $BACKUP_FILE"
echo "=================================================="

# Perform compressed pg_dump
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -F p | gzip -9 > "$BACKUP_FILE"

# Calculate MD5 Checksum
md5sum "$BACKUP_FILE" > "${BACKUP_FILE}.md5"

echo "✔ Backup created successfully."
echo "Checksum: $(cat "${BACKUP_FILE}.md5")"

# S3 Upload (if AWS_S3_BUCKET is configured)
if [ -n "$AWS_S3_BUCKET" ]; then
    echo "Uploading backup to s3://${AWS_S3_BUCKET}/backups/postgres/..."
    aws s3 cp "$BACKUP_FILE" "s3://${AWS_S3_BUCKET}/backups/postgres/"
    echo "✔ Upload to S3 complete."
fi

# Retention policy: remove local backups older than RETENTION_DAYS
echo "Cleaning up local backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -type f -name "daily_basket_backup_*.sql.gz*" -mtime +${RETENTION_DAYS} -delete

echo "✔ PostgreSQL backup job completed successfully."
