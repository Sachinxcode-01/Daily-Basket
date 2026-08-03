# Security Policy

## Supported Versions

We actively issue security updates for the following releases:

| Version | Supported |
|---|---|
| **1.0.x** | ✅ Yes |
| < 1.0 | ❌ No |

---

## 🔒 Reporting a Vulnerability

The Daily Basket team takes security seriously. If you discover a security vulnerability within the platform, please do **NOT** open a public GitHub issue.

Instead, please send an email to our Security Response Team at:
**`security@dailybasket.com`**

### Please Include:
1. Description of the vulnerability and potential impact.
2. Steps to reproduce the vulnerability (proof of concept script or API payload).
3. Any suggested remediation steps.

We will acknowledge receipt of your vulnerability report within 24 hours and strive to release a fix within 72 hours.

---

## 🛡️ Implemented Security Measures

- **Payment Verification**: Razorpay HMAC SHA-256 webhook signature verification.
- **Authentication**: JWT access tokens + refresh token rotation with bcrypt password hashing.
- **Database Safety**: Parameterized Prisma ORM database queries.
- **Rate Limiting**: NestJS `@nestjs/throttler` (100 req/min).
