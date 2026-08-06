# API Reference & Endpoint Directory — Daily Basket

> **Authoritative Specification**: Please refer to the primary API documentation at [`docs/API.md`](../API.md) and OpenAPI guide at [`docs/OPENAPI.md`](../OPENAPI.md).

**Base URL**: `http://localhost:4000/api/v1`  
**Swagger UI**: `http://localhost:4000/api/docs`

---

## Endpoint Quick Directory

| Module | Method | Route | Description | Auth / Role |
| :--- | :--- | :--- | :--- | :--- |
| **Auth** | `POST` | `/auth/login-otp` | Request 6-digit phone verification OTP | Public |
| **Auth** | `POST` | `/auth/verify-otp` | Verify OTP & receive JWT token pair | Public |
| **Products** | `GET` | `/products/home-feed` | Fetch home page flash deals & categories | Public |
| **Search** | `GET` | `/search?query=` | Debounced full-text catalog search | Public |
| **Orders** | `POST` | `/orders` | Place new 10-minute grocery order | Customer |
| **Payments** | `POST` | `/payments/initiate` | Create Razorpay Order Intent (`rzp_order_*`) | Customer |
| **Payments** | `POST` | `/payments/verify` | Verify Razorpay HMAC SHA-256 signature | Customer |
| **Delivery** | `GET` | `/delivery/track/:id` | Live GPS telemetry & ETA countdown | Customer |
| **Analytics** | `GET` | `/analytics/:storeId` | Dark Store revenue & fulfillment KPIs | Admin / Manager |
