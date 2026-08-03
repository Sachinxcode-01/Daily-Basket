# API Reference & Endpoint Directory — Daily Basket

**Base URL**: `http://localhost:3000/api/v1`  
**Swagger UI**: `http://localhost:3000/api/docs`

---

## Endpoint Summary

| Module | Method | Route | Description |
|---|---|---|---|
| **Auth** | `POST` | `/auth/login-otp` | Request 6-digit phone verification OTP |
| **Auth** | `POST` | `/auth/verify-otp` | Verify OTP PIN & receive JWT bearer token |
| **Products** | `GET` | `/products/home-feed` | Fetch home page flash deals & categories |
| **Search** | `GET` | `/search?query=...` | Case-insensitive catalog product search |
| **Coupons** | `POST` | `/coupons/apply` | Validate coupon code & subtotal |
| **Orders** | `POST` | `/orders` | Place new 10-minute delivery order |
| **Payments** | `POST` | `/payments/initiate` | Create Razorpay Order Intent (`rzp_order_*`) |
| **Payments** | `POST` | `/payments/verify` | Verify Razorpay HMAC SHA-256 signature |
| **Delivery** | `GET` | `/delivery/track/:orderId` | Live GPS telemetry & ETA countdown |
| **Admin** | `GET` | `/analytics/:storeId` | Dark Store sales KPIs & fulfillment metrics |
| **Rider** | `GET` | `/delivery-partner/dashboard/:driverId` | Rider duty status & wallet earnings |
