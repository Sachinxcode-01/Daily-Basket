# 💾 Database & Media Backup Strategy — Daily Basket

This document describes automated backup procedures for PostgreSQL database instances and user asset uploads.

---

## 1. Automated Cron Backup Schedule

- **PostgreSQL Database**: Full `pg_dump` taken every 6 hours; WAL archives streamed continuously.
- **Retention Period**: Daily backups retained for 30 days; monthly backups retained for 1 year.
- **Backup Script Location**: `scripts/backups/backup-postgres.sh`.
