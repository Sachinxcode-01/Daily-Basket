#!/usr/bin/env bash
# ==============================================================================
# Automated Redis RDB / AOF Snapshot Backup Script
# ==============================================================================

set -eo pipefail

REDIS_HOST="${REDIS_HOST:-localhost}"
REDIS_PORT="${REDIS_PORT:-6379}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="${BACKUP_DIR:-/tmp/dailybasket-redis-backups}"

mkdir -p "$BACKUP_DIR"

echo "⚡ [Redis Backup Engine] Triggering BGSAVE snapshot on ${REDIS_HOST}:${REDIS_PORT}..."

redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" BGSAVE

echo "✅ Redis background snapshot triggered successfully at ${TIMESTAMP}."
