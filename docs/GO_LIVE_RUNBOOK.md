# Daily Basket — Go-Live Operational Runbook & Production Playbook

This runbook documents operational procedures, incident response steps, disaster recovery workflows, and deployment procedures for the **Daily Basket Enterprise Quick-Commerce Platform**.

---

## 1. Architecture & Service Topology

| Microservice / App | Technology | Internal Port | External Domain |
| :--- | :--- | :--- | :--- |
| **Nginx Gateway** | Nginx 1.25 Alpine | 80 / 443 | `*.dailybasket.com` |
| **NestJS API** | Node.js 20 / NestJS | 4000 | `api.dailybasket.com` |
| **Customer Website** | Next.js 14 App Router | 3000 | `dailybasket.com` |
| **Admin Dashboard** | Next.js 14 App Router | 3001 | `admin.dailybasket.com` |
| **Delivery Partner App**| Next.js 14 / PWA | 3002 | `delivery.dailybasket.com` |
| **PostgreSQL** | PostgreSQL 15 Alpine | 5432 | Internal |
| **Redis Cache / Queues**| Redis 7 Alpine | 6379 | Internal |

---

## 2. Deployment Procedures

### Zero-Downtime Rolling Deployment
```bash
# 1. Pull latest verified production image tags from GHCR
docker compose -f infrastructure/docker-compose.prod.yml pull

# 2. Perform zero-downtime rolling restart
docker compose -f infrastructure/docker-compose.prod.yml up -d --no-deps --build api website admin delivery

# 3. Verify health status
curl -f https://api.dailybasket.com/api/v1/health/readiness
```

### Rollback Strategy
In the event of a critical failure during deployment:
```bash
# Revert to previous image tag
docker compose -f infrastructure/docker-compose.prod.yml up -d --no-deps api:previous
```

---

## 3. Database Operations & Backups

### Trigger Manual Backup
```bash
# Execute automated backup script
./scripts/backups/backup-postgres.sh
```

### Disaster Recovery Restoration Procedure
```bash
# Restore PostgreSQL from backup file
./scripts/backups/restore-postgres.sh /backups/postgres/daily_basket_backup_YYYYMMDD_HHMMSS.sql.gz
```

---

## 4. Monitoring, Metrics & Incident Escalation

### Key Health Endpoints
- **Liveness Probe**: `GET https://api.dailybasket.com/api/v1/health`
- **Readiness Probe**: `GET https://api.dailybasket.com/api/v1/health/readiness`
- **Telemetry & Metrics**: `GET https://api.dailybasket.com/api/v1/health/metrics`

### SLA Targets & Alert Thresholds
- **API Latency (p95)**: `< 200ms` (Alert if > 500ms for 3 consecutive minutes)
- **Error Rate**: `< 0.1%` (Alert if > 1% over 5 minutes)
- **Database Connection Pool**: `Max 50` connections
- **Redis Memory Usage**: `< 1.5 GB`
