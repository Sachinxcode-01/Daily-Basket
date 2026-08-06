# 🛡️ Security Architecture & Safeguards — Daily Basket

This document describes the security architecture, role-based access control (RBAC), rate-limiting safeguards, Helmet headers, and security audit logging built into **Daily Basket**.

---

## 1. Role-Based Access Control (RBAC) Matrix

Roles are defined in Prisma enum `Role` and checked via `@Roles()` decorator and `RolesGuard`:

| Resource / Endpoint | `CUSTOMER` | `STORE_MANAGER` | `DELIVERY_PARTNER` | `ADMIN` |
| :--- | :---: | :---: | :---: | :---: |
| `POST /orders` | ✅ | ❌ | ❌ | ✅ |
| `GET /orders/:id` | ✅ (Own) | ✅ (Store) | ✅ (Assigned) | ✅ |
| `PATCH /orders/:id/status` | ❌ | ✅ | ✅ (Out for delivery/Delivered) | ✅ |
| `GET /analytics/:storeId` | ❌ | ✅ | ❌ | ✅ |
| `POST /products` | ❌ | ✅ | ❌ | ✅ |

---

## 2. API Protection & Throttling

- **NestJS Throttler**: Public endpoints are rate-limited to 100 requests per minute per IP address.
- **Helmet Middleware**: Configured in `main.ts` to enforce HTTP security headers (`Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security`).
- **Payment Verification**: Razorpay webhook payloads are authenticated using HMAC SHA-256 signatures before processing.
- **Audit Logging**: Sensitive events (password changes, failed logins, role grants) are logged to `SecurityAuditLog`.
