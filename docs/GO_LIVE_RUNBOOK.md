# Daily Basket Enterprise Go-Live Launch Runbook & Incident Response

This runbook outlines the operational launch procedures, Blue/Green deployment strategy, Canary release thresholds, and emergency rollback runbooks for Daily Basket v2.0.

---

## 1. Pre-Launch Environment Validation
Before initiating deployment to production clusters, run pre-flight environment checks:
```bash
node scripts/env-validate.js
node scripts/disaster-recovery.js
node scripts/qa-runner.js
```

---

## 2. Zero-Downtime Blue/Green Deployment Strategy

1. **Deploy Green Stack**:
   - Apply Kubernetes manifests for Green release pods:
     ```bash
     kubectl apply -f infrastructure/k8s/deployment.yaml
     ```
2. **Execute Database Migrations**:
   - Run Prisma migration job:
     ```bash
     npx prisma migrate deploy
     ```
3. **Warm Up Caches & Verify Health**:
   - Probe readiness endpoint: `/health/readiness`
   - Verify metrics endpoint: `/health/metrics`
4. **Switch Traffic Ingress**:
   - Update NGINX / Kubernetes Ingress controller to point 100% traffic to Green stack.
5. **Retire Blue Stack**:
   - Scale down previous Blue deployment after 30 minutes of stable telemetry.

---

## 3. Incident Response & Rollback Procedures

### Scenario A: High Error Rate (>1% HTTP 5xx)
1. **Immediate Ingress Revert**:
   - Switch Ingress router back to Blue deployment (`kubectl rollout undo deployment/daily-basket-api -n production`).
2. **Clear Stale Caches**:
   - Flush Redis cache via admin service or redis-cli (`FLUSHDB`).
3. **Notify On-Call SRE**:
   - PagerDuty trigger to Senior Infrastructure Lead.

### Scenario B: Database Latency Spike (>200ms query time)
1. Check active connection pool count via `/health/metrics`.
2. Inspect slow queries in Postgres `pg_stat_activity`.
3. Auto-scale read replicas in Cloud SQL / Spanner.

---

## 4. Commercial Compliance & Legal Sign-off
- **GST Compliance**: GSTIN 29AABCD1234E1Z5 registered with automated CGST/SGST splitting.
- **Privacy & Data Protection**: Privacy Policy, Terms of Service, Cookie Policy, and Refund Policy published on customer portal.
- **User Consent**: Opt-in consent recorded for push notifications, SMS alerts, and marketing emails.
