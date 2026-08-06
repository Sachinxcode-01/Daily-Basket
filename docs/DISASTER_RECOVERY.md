# 🚑 Disaster Recovery & Failover Plan — Daily Basket

This document details Recovery Time Objectives (RTO), Recovery Point Objectives (RPO), and database restoration playbooks for **Daily Basket**.

---

## 1. Recovery SLAs

- **Recovery Point Objective (RPO)**: `< 5 minutes` data loss limit (Continuous WAL archiving).
- **Recovery Time Objective (RTO)**: `< 15 minutes` total service restoration window.

---

## 2. Database Restoration Command

```bash
# Execute automated restoration script from latest backup archive
./scripts/backups/restore-postgres.sh /backups/postgres/daily_basket_backup_latest.sql.gz
```
