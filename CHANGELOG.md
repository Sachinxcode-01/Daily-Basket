# Changelog

All notable changes to the **Daily Basket** quick-commerce platform will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-08-03

### 🚀 Initial Enterprise Release

#### Mobile Application (`apps/mobile`)
- Built 14 production-ready Flutter screens fully synchronized with the **Google Stitch** design specs.
- Material Design 3 dark theme (`app_theme.dart`).
- Customer Phone & OTP Login authentication flow.
- 10-Minute Express Delivery ETA banner and live location header.
- Interactive Shopping Cart with free delivery progress meter and coupon application (`DAILY100`).
- Razorpay Multi-Payment Checkout (UPI, Credit/Debit Cards, Net Banking, COD).
- Live 10-Minute ETA Order Telemetry Tracking with Driver Contact Card & simulated map route.

#### Web Applications (`apps/website`, `apps/admin`, `apps/delivery`)
- **Customer Web App (`apps/website`)**: Next.js 14 App Router SSR product catalog, debounced search, categories taxonomy, and interactive order receipt generator.
- **Store Manager Admin (`apps/admin`)**: Dark Store Fulfillment Queue (`CONFIRMED` -> `PACKING` -> `READY_FOR_PICKUP` -> `OUT_FOR_DELIVERY`), real-time SKU stock adjustment manager, low-stock warnings, and store sales KPIs.
- **Delivery Partner PWA (`apps/delivery`)**: Online/Offline Rider Duty switch, active order dropoff workflow, 4-digit delivery OTP verification (`4821`), and rider wallet earnings ledger.

#### Backend API Service (`services/api`)
- NestJS 10 microservices architecture with modular Domain Driven Design (`auth`, `products`, `search`, `coupons`, `orders`, `payments`, `delivery`, `delivery-partner`, `analytics`).
- Razorpay HMAC SHA-256 payment signature verification (`PaymentsService`).
- PostgreSQL 16 + Prisma ORM data persistence.
- Redis 7 caching and Pub/Sub telemetry stream simulation.

#### Infrastructure & CI/CD (`infrastructure/`)
- Multi-stage production Dockerfiles for NestJS and Next.js applications.
- NGINX Reverse Proxy configuration with SSL termination and HTTP/2.
- Docker Compose multi-container orchestration setup.
- GitHub Actions automated CI/CD pipeline (`.github/workflows/ci.yml`).
