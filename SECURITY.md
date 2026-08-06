# Security Policy & Vulnerability Disclosure — Daily Basket

At **Daily Basket**, security and data privacy are top engineering priorities. We adhere to industry best practices, safe authentication protocols, and rigorous data protection standards across our API microservices, mobile apps, and web portals.

---

## 🛡️ Security Architecture Highlights

| Layer | Safeguard / Implementation |
| :--- | :--- |
| **Authentication** | Short-lived JWT Access Tokens (15m) + Secure HTTP-only Refresh Tokens (7d), Phone OTP PINs, Google OAuth 2.0 |
| **Multi-Factor Auth** | TOTP authenticator app support, email verification tokens, account lockout after 5 failed login attempts |
| **Authorization** | Strict Role-Based Access Control (`CUSTOMER`, `STORE_MANAGER`, `INVENTORY_MANAGER`, `DELIVERY_PARTNER`, `ADMIN`) |
| **Payment Gateway** | Razorpay SDK integration with mandatory HMAC SHA-256 webhook signature verification |
| **API Protection** | NestJS Throttler rate limiting (100 req/min), Helmet security headers, CORS origin validation |
| **Data Protection** | Parameterized SQL queries via Prisma ORM 5, bcrypt password hashing, encrypted secrets management |
| **Session Control** | Security audit logging, active device session tracking, instant remote session revocation |

---

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability within Daily Basket, please **do not open a public issue**. Instead, report it directly to our security team.

### Reporting Process
1. Email your findings to `security@dailybasket.com`.
2. Include a detailed description of the vulnerability, steps to reproduce, proof of concept (PoC), and potential impact.
3. Our security team will acknowledge receipt of your report within **24 hours**.

---

## ⏳ Disclosure Policy & Timeline

- **Acknowledgement**: Within 24 hours.
- **Assessment & Triage**: Within 48 hours.
- **Patch Resolution**: Within 7 to 14 business days depending on severity.
- **Public Disclosure**: Coordinated after the fix has been deployed to production.

---

## 🚫 Out of Scope

The following issues are considered out of scope:
- Social engineering or phishing attempts against Daily Basket employees.
- Denial of Service (DoS / DDoS) attacks testing infrastructure limits.
- Issues in third-party services (Razorpay, Google Firebase) not directly controllable by Daily Basket codebase.
