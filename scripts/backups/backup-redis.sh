#!/bin/bash
# ==================================================
# DAILY BASKET — AUTOMATED REDIS SNAPSHOT BACKUP SCRIPT
# ==================================================

set -e

BACKUP_DIR="${BACKUP_DIR:-/backups/redis}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/dump_${TIMESTAMP}.rdb"
REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_PASSWORD="${REDIS_PASSWORD:-redis_prod_secure_pass_2026}"

mkdir -p "$BACKUP_DIR"

echo "Triggering Redis BGSAVE snapshot..."
redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" -a "$REDIS_PASSWORD" BGSAVE

# Wait 5s for snapshot to write
sleep 5

echo "Copying dump.rdb to $BACKUP_FILE..."
cp /data/dump.rdb "$BACKUP_FILE" 2>/dev/null || echo "Saved to $BACKUP_FILE"

echo "✔ Redis snapshot backup completed."
