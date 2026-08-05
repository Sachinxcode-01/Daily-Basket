#!/bin/bash
# ==================================================
# DAILY BASKET — AUTOMATED POSTGRESQL RESTORE SCRIPT
# ==================================================

set -e

if [ -z "$1" ]; then
    echo "Usage: ./restore-postgres.sh <path_to_backup_file.sql.gz>"
    exit 1
fi

BACKUP_FILE="$1"
DB_HOST="${DB_HOST:-postgres}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_NAME="${POSTGRES_DB:-daily_basket}"
PGPASSWORD="${POSTGRES_PASSWORD:-prod_secure_password_2026}"
export PGPASSWORD

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' not found."
    exit 1
fi

# Verify Checksum if .md5 exists
if [ -f "${BACKUP_FILE}.md5" ]; then
    echo "Verifying MD5 checksum..."
    md5sum -c "${BACKUP_FILE}.md5"
    echo "✔ Checksum verified successfully."
fi

echo "=================================================="
echo "Restoring PostgreSQL database '$DB_NAME' from '$BACKUP_FILE'..."
echo "=================================================="

# Decompress and restore
gunzip -c "$BACKUP_FILE" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"

echo "✔ Restoration completed successfully."
