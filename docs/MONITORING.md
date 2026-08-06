# 📊 Health Monitoring & Probes (`modules/health`)

Daily Basket provides health monitoring probes powered by NestJS Terminus (`modules/health`).

---

## 1. Monitoring Endpoints

- **Liveness Probe**: `GET /api/v1/health`
- **Readiness Probe**: `GET /api/v1/health/readiness` (Checks PostgreSQL DB connectivity & Redis status)
- **Metrics Telemetry**: `GET /api/v1/health/metrics`
