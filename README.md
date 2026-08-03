<p align="center">
  <img src="assets/banner.png" alt="Daily Basket GitHub Banner" width="100%" />
</p>

<p align="center">
  <strong>⚡ Enterprise-Grade 10-Minute Quick-Commerce Startup Monorepo</strong>
</p>

<p align="center">
  <a href="https://github.com/Sachinxcode-01/Daily-Basket/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-emerald.svg?style=for-the-badge" alt="License" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.41.9-02569B.svg?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://nestjs.com"><img src="https://img.shields.io/badge/NestJS-10.3.0-E0234E.svg?style=for-the-badge&logo=nestjs&logoColor=white" alt="NestJS" /></a>
  <a href="https://nextjs.org"><img src="https://img.shields.io/badge/Next.js-14.2.0-black.svg?style=for-the-badge&logo=nextdotjs&logoColor=white" alt="Next.js" /></a>
  <a href="https://www.postgresql.org"><img src="https://img.shields.io/badge/PostgreSQL-16.2-4169E1.svg?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" /></a>
  <a href="https://redis.io"><img src="https://img.shields.io/badge/Redis-7.2-DC382D.svg?style=for-the-badge&logo=redis&logoColor=white" alt="Redis" /></a>
  <a href="https://docker.com"><img src="https://img.shields.io/badge/Docker-Enabled-2496ED.svg?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" /></a>
  <a href="https://github.com/Sachinxcode-01/Daily-Basket/actions"><img src="https://img.shields.io/badge/Build-Passing-brightgreen.svg?style=for-the-badge&logo=githubactions&logoColor=white" alt="CI/CD" /></a>
</p>

---

## 📌 Executive Summary

**Daily Basket** is a production-ready, ultra-fast 10-minute quick-commerce startup platform built with Clean Architecture, microservices, and a modular monorepo structure. Designed to empower local Kirana dark stores, Daily Basket integrates ultra-low latency inventory management, instant payment processing via Razorpay, real-time driver GPS tracking, and multi-platform support across Mobile (Flutter iOS & Android), Web (Next.js App Router), and Dark Store Admin Dashboards.

> [!NOTE]
> **Single Source of Truth UI/UX**: Designed and verified against the official **Google Stitch** design specs.

---

## 🌟 Core Applications & Features

```mermaid
graph TD
    Client[Customer Touchpoints] -->|Flutter App / Next.js Web| Gateway[NGINX Reverse Proxy]
    Store[Dark Store Operations] -->|Next.js Admin Portal| Gateway
    Rider[Delivery Fleet] -->|Next.js Delivery PWA| Gateway
    Gateway -->|HTTP / WebSockets| NestJS[NestJS API Gateway & Microservices]
    NestJS -->|ORM| Prisma[(Prisma ORM)]
    Prisma --> Postgres[(PostgreSQL 16)]
    NestJS -->|Pub/Sub & Cache| Redis[(Redis 7)]
    NestJS -->|Payments| Razorpay[Razorpay Gateway]
```

### 📱 1. Customer Mobile App (`apps/mobile`)
- **Built with**: Flutter 3.41, Material Design 3, Dart 3.11
- **Key Features**: 
  - 10-Minute Delivery ETA Promise Bar & Live Location Selector
  - Category Grid Taxonomy (Produce, Dairy, Bakery, Snacks, Household)
  - Debounced Product Search with Trending Search Tags
  - Interactive Shopping Cart with Free Delivery Threshold Meter
  - Razorpay UPI, Cards, Net Banking, and COD Checkout Flow
  - Real-time Order Telemetry & Live Driver Map Route Tracking

### 🌐 2. Customer Website (`apps/website`)
- **Built with**: Next.js 14 App Router, React 18, TailwindCSS, TanStack Query
- **Key Features**: Server-Side Rendered (SSR) product pages, instant cart drawer, SEO optimized categories, and interactive order receipt generator.

### 🏢 3. Store Manager Admin Dashboard (`apps/admin`)
- **Built with**: Next.js 14, Zustand, Recharts
- **Key Features**: 
  - Real-Time Store Fulfillment Queue (`ACCEPT` -> `PACK` -> `READY` -> `DISPATCH`)
  - Inventory Stock Adjustment Manager with automatic Low-Stock Warnings
  - Store Sales KPIs (Today's Revenue, Orders Count, Avg Dispatch Time)
  - Top Selling Products breakdown by units sold and revenue.

### 🛵 4. Delivery Partner App (`apps/delivery`)
- **Built with**: Next.js 14 Progressive Web App (PWA)
- **Key Features**: 
  - Online/Offline Duty Toggle switch
  - Active Delivery Queue with Store Pickup & Customer Dropoff details
  - Turn-by-turn Navigation Map route triggers
  - Delivery OTP Verification PIN entry (`4821`)
  - Rider Wallet Earnings ledger (`₹850` earned today, `18` orders).

---

## 🛠️ Technology Stack

| Domain | Technologies |
|---|---|
| **Mobile App** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) |
| **Frontend Web** | ![Next.js](https://img.shields.io/badge/Next.js-000000?style=flat&logo=nextdotjs&logoColor=white) ![React](https://img.shields.io/badge/React-61DAFB?style=flat&logo=react&logoColor=black) ![TailwindCSS](https://img.shields.io/badge/TailwindCSS-06B6D4?style=flat&logo=tailwindcss&logoColor=white) |
| **Backend API** | ![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=flat&logo=nestjs&logoColor=white) ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat&logo=typescript&logoColor=white) ![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=nodedotjs&logoColor=white) |
| **Database & Cache** | ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white) ![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=flat&logo=prisma&logoColor=white) ![Redis](https://img.shields.io/badge/Redis-DC382D?style=flat&logo=redis&logoColor=white) |
| **DevOps & Cloud** | ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) ![NGINX](https://img.shields.io/badge/NGINX-009639?style=flat&logo=nginx&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=githubactions&logoColor=white) |
| **Payments & Maps** | ![Razorpay](https://img.shields.io/badge/Razorpay-02042B?style=flat&logo=razorpay&logoColor=blue) ![Google Maps](https://img.shields.io/badge/Google_Maps-4285F4?style=flat&logo=googlemaps&logoColor=white) |

---

## 📂 Repository Monorepo Structure

```text
daily-basket/
├── apps/
│   ├── mobile/             # Flutter Customer Mobile Application
│   ├── website/            # Next.js Customer Web Portal
│   ├── admin/              # Next.js Dark Store Admin & Fulfillment Portal
│   └── delivery/           # Next.js Delivery Partner PWA Application
├── services/
│   └── api/                # NestJS API Gateway & Domain Microservices
├── packages/
│   ├── api-client/         # Shared Axios API SDK Client
│   ├── shared-types/       # Shared TypeScript DTOs & Interfaces
│   ├── shared-utils/       # Shared Formatting & Currency Helper Utilities
│   ├── design-system/      # Shared Web Design Tokens
│   ├── constants/          # Shared Business Logic Constants
│   ├── theme/              # Shared Branding Theme Config
│   └── shared-ui/          # Shared Web React Component Library
├── infrastructure/
│   ├── docker/             # Production Dockerfiles
│   ├── nginx/              # Reverse Proxy NGINX configuration
│   └── docker-compose.yml  # Local Environment Multi-Container Orchestration
├── docs/                   # PRD, TRD, Architecture & API Documentation
└── scripts/                # Database Seeding & Setup Automation
```

---

## 🔄 Development Lifecycle & Workflow

```mermaid
flowchart LR
    A[Planning & PRD] --> B[Architecture & DB Schema]
    B --> C[Clean Architecture Implementation]
    C --> D[Google Stitch UI Synchronization]
    D --> E[Flutter & NestJS Testing]
    E --> F[Docker & CI/CD Deployment]
```

---

## ⚡ Quickstart & Installation

### Prerequisites
- **Node.js**: `v18.0.0+`
- **Flutter SDK**: `v3.19.0+`
- **Docker & Docker Compose**: Installed and running
- **Git**: Installed

### 1. Clone Repository
```bash
git clone https://github.com/Sachinxcode-01/Daily-Basket.git
cd Daily-Basket
```

### 2. Environment Configuration
Create `.env` file inside `services/api/.env`:
```env
PORT=3000
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/daily_basket?schema=public"
REDIS_HOST="localhost"
REDIS_PORT=6379
JWT_SECRET="daily_basket_jwt_secret_key_2026"
RAZORPAY_KEY_ID="rzp_test_daily_basket_2026"
RAZORPAY_KEY_SECRET="rzp_secret_daily_basket_2026"
```

### 3. Spin Up Database & Infrastructure via Docker
```bash
docker-compose -f infrastructure/docker-compose.yml up -d
```

### 4. Run Database Schema Migrations & Seeding
```bash
cd services/api
npx prisma db push
npm run seed
```

### 5. Start Backend API Service
```bash
npm run start:dev
```

### 6. Run Flutter Mobile Application
```bash
cd ../../apps/mobile
flutter pub get
flutter run
```

---

## 🔌 Core API Endpoints

| Module | HTTP Method | Endpoint | Description |
|---|---|---|---|
| **Auth** | `POST` | `/api/v1/auth/login-otp` | Request 6-digit phone OTP |
| **Auth** | `POST` | `/api/v1/auth/verify-otp` | Verify OTP & receive JWT token |
| **Products** | `GET` | `/api/v1/products/home-feed` | Fetch home page deals & categories |
| **Search** | `GET` | `/api/v1/search?query=...` | Debounced catalog search |
| **Coupons** | `POST` | `/api/v1/coupons/apply` | Validate coupon code & subtotal |
| **Payments**| `POST` | `/api/v1/payments/initiate` | Create Razorpay Order Intent |
| **Payments**| `POST` | `/api/v1/payments/verify` | Verify Razorpay HMAC SHA-256 signature |
| **Delivery**| `GET` | `/api/v1/delivery/track/:orderId` | Live GPS telemetry & ETA |
| **Admin** | `GET` | `/api/v1/analytics/:storeId` | Store KPIs & fulfillment metrics |

---

## 🔒 Security & Quality Safeguards

- **Payment Security**: Razorpay HMAC SHA-256 webhook signature verification.
- **Authentication**: JWT access tokens + refresh token rotation with bcrypt password hashing.
- **Data Protection**: Parameterized database queries protecting against SQL injection attacks.
- **Rate Limiting**: NestJS `@nestjs/throttler` (100 req/min) guarding public API endpoints.
- **Static Analysis**: `flutter analyze` completed with **0 Errors, 0 Warnings**.

---

## 🗺️ Roadmap

- [x] **v1.0**: Core Platform Foundation, Customer App, Web App, Store Admin & Delivery PWA.
- [ ] **v1.1**: Firebase Cloud Messaging (FCM) Web Push Notifications.
- [ ] **v2.0**: Multi-Store Dark Store Hub Dispatch Engine & AI Demand Forecasting.

---

## 📄 Documentation Directory

For in-depth technical specifications, explore the internal documentation in `docs/`:

- 📘 [Product Requirements Document (PRD)](docs/PRD/README.md)
- 📐 [Technical Requirements Document (TRD)](docs/TRD/README.md)
- 🏗️ [Enterprise Architecture Guide](docs/Architecture/README.md)
- 🗄️ [Database Schema & ERD](docs/Database/README.md)
- 🔌 [API Documentation & Swagger](docs/API/README.md)
- 🎨 [Coding Standards & Naming Conventions](docs/Naming-Convention/README.md)

---

## 📜 License & Author

Distributed under the **MIT License**. See `LICENSE` for details.

Developed with ❤️ by **Sachin** ([@Sachinxcode-01](https://github.com/Sachinxcode-01)).
