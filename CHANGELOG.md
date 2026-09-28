# Changelog — Daily Basket

All notable changes to the **Daily Basket** monorepo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-09-28

### 🔐 Firebase & Google OAuth 2.0 SSO Engine & Documentation Refresh

#### ⚙️ Backend API & Authentication Services

- **Firebase Admin SDK Integration**: Added `FirebaseAuthService` loaded with official service account credentials (`daily-basket-8b266`).
- **Cryptographic Token Verification**: Implemented server-side token validation against Firebase public keys and Google certificates for `POST /api/v1/auth/google-login`.
- **Diagnostic Endpoint**: Added `GET /api/v1/auth/google/status` for real-time health checks on Firebase service account configurations.
- **Enterprise Test Suite**: Added dedicated Jest unit test coverage for Google OAuth and Firebase credentials validation.

#### 🌐 Customer Web Portal Updates

- **Sign-Up Parity**: Added "Sign up with Google" to `/register` with animated Google logo, guest cart merging, and session persistence.

#### 📱 Customer Mobile App Updates

- **Registration Integration**: Added single-tap "Sign up with Google" on `RegisterScreen` with provider state linking.

#### 📚 Enterprise Documentation Refresh

- **Documentation Overhaul**: Modernized markdown documentation across all applications (`apps/website`, `apps/mobile`, `apps/admin`, `apps/delivery`, `apps/daily_basket_admin`, `docs/AUTHENTICATION.md`, `README.md`) with official shields and professional icons.

---

## [1.0.0] - 2026-08-06

### 🚀 Initial Enterprise Release

#### 📱 Customer Mobile App Initial Release

- **Clean Architecture & Provider Pattern**: Production Flutter 3.19 codebase with Material Design 3 theme matching Google Stitch design source of truth.
- **Authentication Suite**: Phone OTP verification, Email/Password login, Google OAuth integration, TOTP MFA option, Biometric authentication enable screen.
- **Home & Shopping Feed**: Dynamic hero delivery ETA bar, live delivery address selector, flash deals carousel, interactive category grid.
- **Smart Catalog Search**: Debounced full-text search with trending tags, brand alias search, and category taxonomy filtering.
- **Cart & Checkout**: Interactive sliding drawer cart with free delivery progress meter, coupon validation (`DAILY100`), slot selection, and Razorpay gateway.
- **Live GPS Delivery Tracking**: Animated step-by-step telemetry progress timeline, real-time Socket.IO WebSocket driver route map, driver contact trigger.
- **Wallet & Loyalty**: Digital Daily Basket Wallet balance ledger, transaction history, instant refill, and Daily Basket Plus VIP perks page.
- **AI Voice & Vision Search**: Built-in microphone voice search and camera package freshness scanner powered by NestJS AI service.

#### 🌐 Customer Web Portal Initial Release

- **Next.js 14 App Router**: Responsive web application with server-side rendering, React 18, and TailwindCSS dark theme styling.
- **Account & Security Hub**: Active device session management, password policy rules, 2FA toggle, and security audit log.
- **Full Catalog Explorer**: Dynamic product filtering, wishlist management, address selector, and Razorpay checkout flow.

#### 🏢 Store Admin Dashboard Initial Release

- **Real-Time Fulfillment Queue**: Dark Store order dispatch stream (`NEW` → `CONFIRMED` → `PACKING` → `READY_FOR_PICKUP` → `DISPATCHED`).
- **Inventory Control**: Live stock adjustments, low-stock threshold warnings, SKU catalog editor, and customer insights.
- **Revenue Analytics**: Real-time sales KPIs, average dispatch latency metrics, and dark store performance indicators.

#### 🛵 Delivery Partner PWA Initial Release

- **Rider Duty Controller**: One-tap `ONLINE`/`OFFLINE` toggle with continuous background location broadcast.
- **Active Orders Manifest**: Store pickup details, dropoff coordinates, items manifest, turn-by-turn navigation trigger.
- **Doorstep Verification**: Customer OTP verification (`4821`) before completing order deliveries.

#### ⚙️ NestJS API Gateway & Microservices Initial Release

- **Auth & Security**: JWT access/refresh token rotation, bcrypt password hashing, NestJS Throttler rate-limiting (100 req/min), Helmet headers, custom `RolesGuard` for RBAC.
- **Database Architecture**: PostgreSQL 16 managed via Prisma ORM 5 with parameterized queries, composite indexes, and UUID primary keys.
- **Multi-Provider AI Engine**: Primary Google Gemini 1.5 Flash provider with automatic failover to Grok, OpenRouter, and local models. Includes prompt sanitization and `AiToolsRegistry` for function calling.
- **Payment & Webhook Security**: Razorpay SDK integration with mandatory HMAC SHA-256 webhook signature verification.
- **Queues & WebSockets**: Redis 7 caching, BullMQ job processing for notifications and email triggers, Socket.IO WebSockets for live tracking and support chat.
