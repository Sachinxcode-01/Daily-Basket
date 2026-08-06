# 📕 Go-Live Operational Runbook & Production Playbook — Daily Basket

This runbook documents production deployment steps, rolling update procedures, and emergency rollback playbooks for **Daily Basket**.

---

## 1. Service Topology Matrix

| Service | Technology | Port | Production URL |
| :--- | :--- | :--- | :--- |
| **NGINX Gateway** | NGINX 1.25 Alpine | `80 / 443` | `*.dailybasket.com` |
| **NestJS API** | Node.js 20 / NestJS | `4000` | `api.dailybasket.com` |
| **Customer Website** | Next.js 14 App Router | `3005` | `dailybasket.com` |
| **Admin Dashboard** | Next.js 14 App Router | `3001` | `admin.dailybasket.com` |
| **Delivery PWA** | Next.js 14 PWA | `3002` | `delivery.dailybasket.com` |

---

## 2. Zero-Downtime Deployment Command

```bash
# Pull production images and apply rolling update
docker compose -f infrastructure/docker-compose.prod.yml up -d --no-deps --build api website admin delivery
```

---

## 3. Emergency Rollback Playbook

```bash
# Roll back to previous verified image tag
docker compose -f infrastructure/docker-compose.prod.yml up -d --no-deps api:previous
```
