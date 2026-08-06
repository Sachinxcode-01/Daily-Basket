# 👁️ Observability & Structured Logging — Daily Basket

Daily Basket uses Winston logger (`winston`) integrated with custom NestJS interceptors (`logging.interceptor.ts`) for structured JSON logging.

---

## 1. Log Schema Format

```json
{
  "timestamp": "2026-08-06T10:16:20.000Z",
  "level": "info",
  "correlationId": "req-98214",
  "path": "/api/v1/orders",
  "method": "POST",
  "statusCode": 201,
  "durationMs": 14
}
```
