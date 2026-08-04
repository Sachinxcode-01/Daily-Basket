<p align="center">
  <img src="assets/banner.png" alt="Daily Basket — 10-Minute Grocery Delivery Platform" width="100%" />
</p>

<p align="center">
  <a href="https://github.com/Sachinxcode-01/Daily-Basket/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-22c55e.svg?style=for-the-badge" alt="MIT License" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.19.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://nestjs.com"><img src="https://img.shields.io/badge/NestJS-10.3-E0234E?style=for-the-badge&logo=nestjs&logoColor=white" alt="NestJS" /></a>
  <a href="https://nextjs.org"><img src="https://img.shields.io/badge/Next.js-14.2-black?style=for-the-badge&logo=nextdotjs&logoColor=white" alt="Next.js" /></a>
  <a href="https://github.com/Sachinxcode-01/Daily-Basket/actions"><img src="https://img.shields.io/badge/CI%2FCD-Passing-22c55e?style=for-the-badge&logo=githubactions&logoColor=white" alt="CI/CD" /></a>
  <img src="https://img.shields.io/badge/Build-Production%20Ready-006b23?style=for-the-badge" alt="Production Ready" />
</p>

<br/>

> **Daily Basket** is a production-grade, enterprise quick-commerce platform delivering groceries in 10 minutes. Built as a full-stack monorepo with Clean Architecture — powering a Flutter mobile app, three Next.js web portals, and a NestJS microservice backend. Designed for real Kirana dark stores, Gadag & beyond.

---

## 📱 Platform Overview

<table>
<tr>
<td align="center" width="25%">
<strong>📱 Customer App</strong><br/>
Flutter Mobile
</td>
<td align="center" width="25%">
<strong>🌐 Customer Website</strong><br/>
Next.js Web Portal
</td>
<td align="center" width="25%">
<strong>🏢 Admin Dashboard</strong><br/>
Store Management
</td>
<td align="center" width="25%">
<strong>🛵 Delivery PWA</strong><br/>
Rider App
</td>
</tr>
<tr>
<td align="center">Flutter 3.19 + Dart 3<br/>Material Design 3</td>
<td align="center">Next.js 14 App Router<br/>TailwindCSS + TanStack Query</td>
<td align="center">Next.js 14 + Zustand<br/>Real-time fulfillment queue</td>
<td align="center">Next.js PWA<br/>GPS + OTP verification</td>
</tr>
</table>

---

## ✨ Features

### 📱 Customer Mobile App (`apps/mobile`)

| Feature | Description |
|---------|-------------|
| 🏠 **Home Feed** | Hero delivery ETA bar, live location selector, category grid, flash deals carousel, and trending products |
| 🔍 **Smart Search** | Debounced full-text search with trending tags, voice-ready input, and instant results grid |
| 🛒 **Shopping Cart** | Interactive cart drawer with free-delivery threshold meter, coupon code entry, and live subtotal |
| 📦 **Browse Categories** | Taxonomy grid — Produce, Dairy, Bakery, Snacks, Beverages, Household, Personal Care |
| 💳 **Checkout** | Multi-step checkout with address selector, slot booking, UPI / Card / COD / Net Banking via Razorpay |
| 📍 **Live Tracking** | Real-time WebSocket order telemetry with driver GPS map route and animated ETA countdown |
| 🔔 **Notification Center** | In-app push feed for order updates, deals, and delivery alerts with read/unread states |
| 💰 **Wallet & Transactions** | Daily Basket Wallet ledger with credit/debit history and one-tap refill |
| ⭐ **Rate Your Delivery** | Post-delivery rating with star selector, quick-tag chips, and photo upload |
| 🌿 **Fresh Produce Explorer** | Freshness-score browser with origin-farm details, 3D product previews, and quality badges |
| 🥇 **Daily Basket Plus** | VIP membership screen with free-delivery perks, exclusive flash sales, and priority support |
| 🛒 **Empty Basket State** | Smart empty state with curated "You might like" suggestions to re-engage shoppers |
| 🔐 **Authentication Suite** | Phone OTP login, email/password, Google OAuth, MFA selection, biometric enable, account lock, email verification |
| 🗺️ **Onboarding Flow** | Animated multi-step intro → location permission → notification permission → ready-to-shop |
| ❓ **Help Center** | Searchable FAQ accordion with live chat trigger and ticket submission |
| 📋 **Order History** | Full order receipts with item breakdown, delivery timeline, and re-order one tap |

---

### 🌐 Customer Website (`apps/website`)

| Feature | Description |
|---------|-------------|
| 🏠 **Homepage** | Hero section, category shortcuts, flash deal timer, testimonials, app download CTA |
| 🔍 **Search Results** | Filtered product grid with sorting, price range, and category filter chips |
| 🛒 **Cart & Checkout** | Dark-themed checkout flow with Razorpay payment integration |
| 📍 **Live Tracking** | Real-time delivery map tracker with step-by-step status timeline |
| 🔔 **Notifications** | Notification center with grouped alerts (Orders, Offers, System) |
| 💰 **Wallet** | Digital wallet with transaction history and quick-add funds |
| ⭐ **Rate Delivery** | Web-based delivery rating with emoji picker |
| 🌿 **Fresh Produce Explorer** | Freshness explorer with animated quality indicators |
| 🥇 **Daily Basket Plus** | Membership upgrade page with benefit cards and billing toggle |
| 🗂️ **Browse Categories** | Full category taxonomy explorer with sub-category depth |
| 🛡️ **Account Security** | Security settings, active session manager, and 2FA toggle |
| 📱 **How It Works** | Illustrated 3-step explainer page |
| 📄 **Legal Pages** | Privacy Policy, Terms of Service |
| 🔐 **Auth Pages** | Login, Register, Forgot Password, Reset Password, OTP, Email Verify, Account Locked, Enable Biometrics |

---

### 🏢 Store Admin Dashboard (`apps/admin`)

| Feature | Description |
|---------|-------------|
| 📊 **KPI Overview** | Today's Revenue, Orders Count, Avg Dispatch Time, Customer Satisfaction score |
| 📋 **Fulfillment Queue** | Real-time order queue: `NEW → ACCEPT → PACK → READY → DISPATCH` with one-tap action buttons |
| 📦 **Inventory Manager** | Stock level viewer, low-stock alerts, quick-adjust quantity, and SKU search |
| 🏆 **Top Products** | Best sellers by units sold and revenue with trend indicators |
| 👥 **Customer Insights** | Repeat customer rate, new customer count, average basket size |
| ⚡ **Live Activity Feed** | Real-time stream of order events and inventory changes |

---

### 🛵 Delivery Partner App (`apps/delivery`)

| Feature | Description |
|---------|-------------|
| 🟢 **Duty Toggle** | Online/Offline toggle with GPS tracking activation |
| 📋 **Active Delivery Queue** | Store pickup details, customer drop-off address, and order item manifest |
| 🗺️ **Navigation Trigger** | One-tap Google Maps route launch for pickup and delivery |
| 🔑 **Delivery OTP** | Customer OTP verification at doorstep before marking delivered |
| 💰 **Earnings Ledger** | Today's earnings breakdown: base pay + incentives + order count |
| 📈 **Performance Stats** | Acceptance rate, on-time delivery %, and weekly earnings graph |

---

## 🛠️ Technology Stack

| Layer | Technologies |
|---|---|
| **Mobile App** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) ![Material Design 3](https://img.shields.io/badge/Material%20Design%203-757575?style=flat&logo=materialdesign&logoColor=white) |
| **Customer Web** | ![Next.js](https://img.shields.io/badge/Next.js-000?style=flat&logo=nextdotjs&logoColor=white) ![React](https://img.shields.io/badge/React-61DAFB?style=flat&logo=react&logoColor=black) ![TailwindCSS](https://img.shields.io/badge/TailwindCSS-06B6D4?style=flat&logo=tailwindcss&logoColor=white) ![TanStack Query](https://img.shields.io/badge/TanStack_Query-FF4154?style=flat&logo=reactquery&logoColor=white) |
| **Admin & Delivery** | ![Next.js](https://img.shields.io/badge/Next.js-000?style=flat&logo=nextdotjs&logoColor=white) ![Zustand](https://img.shields.io/badge/Zustand-brown?style=flat) ![Framer Motion](https://img.shields.io/badge/Framer_Motion-0055FF?style=flat&logo=framer&logoColor=white) |
| **Backend API** | ![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=flat&logo=nestjs&logoColor=white) ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat&logo=typescript&logoColor=white) ![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=nodedotjs&logoColor=white) |
| **Database & ORM** | ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white) ![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=flat&logo=prisma&logoColor=white) |
| **Cache & Queues** | ![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat&logo=redis&logoColor=white) ![BullMQ](https://img.shields.io/badge/BullMQ-CC0000?style=flat) ![WebSockets](https://img.shields.io/badge/WebSockets-010101?style=flat) |
| **Payments** | ![Razorpay](https://img.shields.io/badge/Razorpay-02042B?style=flat&logo=razorpay&logoColor=blue) |
| **DevOps & CI/CD** | ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) ![NGINX](https://img.shields.io/badge/NGINX-009639?style=flat&logo=nginx&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=githubactions&logoColor=white) |
| **Package Manager** | ![pnpm](https://img.shields.io/badge/pnpm-F69220?style=flat&logo=pnpm&logoColor=white) Monorepo Workspaces |
| **UI Design** | ![Google Stitch](https://img.shields.io/badge/Google_Stitch-4285F4?style=flat&logo=google&logoColor=white) Single Source of Truth |

---

## 📂 Monorepo Structure

```
daily-basket/
├── apps/
│   ├── mobile/             # 📱 Flutter Customer Mobile App (35+ screens)
│   ├── website/            # 🌐 Next.js Customer Web Portal (31 pages)
│   ├── admin/              # 🏢 Next.js Dark Store Admin Dashboard
│   └── delivery/           # 🛵 Next.js Delivery Partner PWA
│
├── services/
│   └── api/                # ⚙️  NestJS API Gateway + Microservices
│       ├── src/modules/
│       │   ├── auth/       #    JWT, OTP, OAuth, Sessions
│       │   ├── products/   #    Catalog, Search, Categories
│       │   ├── orders/     #    Checkout, Fulfillment, Tracking
│       │   ├── payments/   #    Razorpay Integration + Webhooks
│       │   ├── delivery/   #    GPS Telemetry + Driver Assignment
│       │   ├── wallet/     #    Balance, Transactions
│       │   ├── notifications/ # Push Notification Service
│       │   └── analytics/  #    Store KPIs + Reporting
│       └── prisma/         #    PostgreSQL Schema + Migrations
│
├── packages/
│   ├── api-client/         # Shared Axios SDK Client
│   ├── shared-types/       # TypeScript DTOs & Interfaces
│   ├── shared-utils/       # Formatting & Currency Utilities
│   ├── design-system/      # Web Design Tokens
│   ├── constants/          # Business Logic Constants
│   ├── theme/              # Branding & Theme Config
│   └── shared-ui/          # React Component Library
│
├── infrastructure/
│   ├── docker/             # Production Dockerfiles
│   ├── nginx/              # Reverse Proxy Config
│   └── docker-compose.yml  # Local Multi-Container Dev
│
├── docs/                   # PRD, TRD, Architecture & API Docs
├── scripts/                # DB Seeding & Setup Automation
└── .github/workflows/      # CI/CD — Lint, Test, Build, Deploy
```

---

## 🏗️ Architecture

```mermaid
graph TD
    Client[📱 Flutter App / 🌐 Next.js Web] -->|HTTPS| NGINX[NGINX Reverse Proxy]
    Admin[🏢 Admin Portal] -->|HTTPS| NGINX
    Rider[🛵 Delivery PWA] -->|HTTPS| NGINX
    NGINX -->|HTTP + WSS| NestJS[NestJS API Gateway]

    NestJS --> Auth[Auth Module\nJWT · OTP · OAuth]
    NestJS --> Products[Products Module\nSearch · Catalog]
    NestJS --> Orders[Orders Module\nCheckout · Fulfillment]
    NestJS --> Payments[Payments Module\nRazorpay · Webhooks]
    NestJS --> Delivery[Delivery Module\nGPS · Assignment]

    NestJS -->|Prisma ORM| PG[(PostgreSQL 16)]
    NestJS -->|Cache · Pub/Sub| Redis[(Redis 7)]
    NestJS -->|Background Jobs| Bull[BullMQ Workers]
    NestJS -->|WebSocket| WS[Live Tracking]
```

---

## 🔌 Core API Endpoints

| Module | Method | Endpoint | Description |
|--------|--------|----------|-------------|
| **Auth** | `POST` | `/api/v1/auth/login-otp` | Request 6-digit phone OTP |
| **Auth** | `POST` | `/api/v1/auth/verify-otp` | Verify OTP & receive JWT pair |
| **Auth** | `POST` | `/api/v1/auth/google` | Google OAuth login |
| **Auth** | `POST` | `/api/v1/auth/register` | Email + password registration |
| **Products** | `GET` | `/api/v1/products/home-feed` | Home page deals & categories |
| **Products** | `GET` | `/api/v1/products/search?query=` | Debounced catalog search |
| **Orders** | `POST` | `/api/v1/orders` | Create new order |
| **Orders** | `GET` | `/api/v1/orders/:id` | Order details & status |
| **Payments** | `POST` | `/api/v1/payments/initiate` | Create Razorpay Order intent |
| **Payments** | `POST` | `/api/v1/payments/verify` | HMAC SHA-256 signature verify |
| **Payments** | `POST` | `/api/v1/payments/webhook` | Razorpay webhook handler |
| **Delivery** | `GET` | `/api/v1/delivery/track/:id` | Live GPS telemetry & ETA |
| **Wallet** | `GET` | `/api/v1/wallet/:userId` | Wallet balance & transactions |
| **Analytics** | `GET` | `/api/v1/analytics/:storeId` | Store KPIs & fulfillment stats |
| **Notifications** | `GET` | `/api/v1/notifications/:userId` | User notification feed |

---

## ⚡ Quickstart

### Prerequisites

```
Node.js >= 18.0.0
Flutter SDK >= 3.19.0
pnpm >= 8.0.0
Docker & Docker Compose
PostgreSQL 16 (via Docker)
Redis 7 (via Docker)
```

### 1. Clone the Repository

```bash
git clone https://github.com/Sachinxcode-01/Daily-Basket.git
cd Daily-Basket
```

### 2. Configure Environment

Create `services/api/.env`:

```env
PORT=4000
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/daily_basket?schema=public"
REDIS_HOST="localhost"
REDIS_PORT=6379
JWT_SECRET="your_jwt_secret_here"
RAZORPAY_KEY_ID="rzp_test_xxxx"
RAZORPAY_KEY_SECRET="your_razorpay_secret"
```

### 3. Start Infrastructure (PostgreSQL + Redis)

```bash
docker-compose -f infrastructure/docker-compose.yml up -d
```

### 4. Install All Dependencies

```bash
pnpm install
```

### 5. Run Database Migrations & Seed

```bash
cd services/api
npx prisma db push
npx prisma generate
```

### 6. Start All Services in Parallel

```bash
# From monorepo root — starts API + Website + Admin + Delivery simultaneously
pnpm dev

# Or start individually:
pnpm dev:api        # NestJS API on :4000
pnpm dev:website    # Customer Web on :3005
pnpm dev:admin      # Admin Dashboard on :3001
```

### 7. Run Flutter Mobile App

```bash
cd apps/mobile
flutter pub get
flutter run
```

---

## 🔒 Security & Quality

| Safeguard | Implementation |
|-----------|---------------|
| **Payment Security** | Razorpay HMAC SHA-256 webhook signature verification |
| **Authentication** | JWT access + refresh token rotation, bcrypt hashing |
| **SQL Protection** | Prisma parameterized queries (zero raw SQL) |
| **Rate Limiting** | NestJS Throttler — 100 req/min on all public endpoints |
| **Static Analysis** | `flutter analyze` — **0 Errors, 0 Warnings** |
| **TypeScript** | Strict mode, zero `any` in production code |
| **CI/CD Checks** | ESLint + TypeCheck + Unit Tests required to merge |

---

## 🤖 CI/CD Pipeline

```yaml
# Runs on every push to main and develop
CI Jobs:
  ✅ Lint & Typecheck   — ESLint + tsc --noEmit (website, admin, delivery)
  ✅ Unit Tests          — NestJS Jest (2 suites, 3+ tests)
  ✅ Flutter CI          — flutter analyze + flutter test

CD Jobs (on main push):
  ✅ Customer Website    — lint → typecheck → next build (31 pages)
  ✅ Admin Dashboard     — lint → typecheck → next build (5 pages)
  ✅ API Service         — prisma generate → jest → nest build → Docker
```

---

## 🗺️ Roadmap

- [x] **v1.0** — Core platform: Flutter app (35 screens), Web portal (31 pages), Admin, Delivery PWA, NestJS API, Prisma schema, Docker, CI/CD
- [ ] **v1.1** — Firebase Cloud Messaging (FCM) push notifications
- [ ] **v1.2** — Multi-language support (Kannada, Hindi, English)
- [ ] **v2.0** — Multi-store dark store hub dispatch engine
- [ ] **v2.1** — AI-powered demand forecasting & auto-reorder

---

## 📚 Documentation

| Document | Path |
|----------|------|
| 📘 Product Requirements (PRD) | [`docs/PRD/`](docs/PRD/) |
| 📐 Technical Requirements (TRD) | [`docs/TRD/`](docs/TRD/) |
| 🏗️ Enterprise Architecture | [`docs/Architecture/`](docs/Architecture/) |
| 🗄️ Database Schema & ERD | [`docs/Database/`](docs/Database/) |
| 🔌 API Documentation | [`docs/API/`](docs/API/) |
| 🎨 Coding Standards | [`docs/Naming-Convention/`](docs/Naming-Convention/) |

---

## 📜 License & Author

Distributed under the **MIT License** — see [`LICENSE`](LICENSE) for details.

<br/>

<p align="center">
  Built with ❤️ and ☕ by <strong>Sachin</strong> &nbsp;|&nbsp;
  <a href="https://github.com/Sachinxcode-01">@Sachinxcode-01</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-India%20🇮🇳-FF9933?style=flat" />
  <img src="https://img.shields.io/badge/Built%20for-Gadag%20%26%20Beyond-006b23?style=flat" />
</p>
