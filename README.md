<p align="center">
  <img src="assets/banner.png" alt="Daily Basket — Enterprise 10-Minute Grocery Delivery Platform" width="100%" />
</p>

<p align="center">
  <a href="https://github.com/Sachinxcode-01/Daily-Basket/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-22c55e.svg?style=for-the-badge" alt="MIT License" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.19.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://nestjs.com"><img src="https://img.shields.io/badge/NestJS-10.3-E0234E?style=for-the-badge&logo=nestjs&logoColor=white" alt="NestJS" /></a>
  <a href="https://nextjs.org"><img src="https://img.shields.io/badge/Next.js-14.2-black?style=for-the-badge&logo=nextdotjs&logoColor=white" alt="Next.js" /></a>
  <a href="https://prisma.io"><img src="https://img.shields.io/badge/Prisma-5.10-2D3748?style=for-the-badge&logo=prisma&logoColor=white" alt="Prisma" /></a>
  <a href="https://redis.io"><img src="https://img.shields.io/badge/Redis-7.2-DC382D?style=for-the-badge&logo=redis&logoColor=white" alt="Redis" /></a>
  <a href="https://github.com/Sachinxcode-01/Daily-Basket/actions"><img src="https://img.shields.io/badge/CI%2FCD-Passing-22c55e?style=for-the-badge&logo=githubactions&logoColor=white" alt="CI/CD Status" /></a>
  <img src="https://img.shields.io/badge/Production-Ready-006b23?style=for-the-badge" alt="Production Ready" />
</p>

<br/>

> **Daily Basket** is an enterprise-grade, hyper-local 10-minute quick-commerce platform delivering fresh groceries, vegetables, dairy, and household essentials. Built as a clean-architecture monorepo, it powers a cross-platform Flutter customer app, three Next.js 14 web portals (Customer, Store Admin, Delivery Partner PWA), and a NestJS microservices backend with real-time WebSockets, Redis caching, BullMQ job queues, and multi-provider AI engine.

---

## 📋 Table of Contents

- [Platform Overview](#-platform-overview)
- [Single Source of Truth (Google Stitch)](#-single-source-of-truth-google-stitch)
- [System Architecture](#-system-architecture)
- [Monorepo Directory Structure](#-monorepo-directory-structure)
- [Feature Matrix](#-feature-matrix)
  - [Customer Mobile App](#1-customer-mobile-app-appsmobile)
  - [Customer Web Portal](#2-customer-web-portal-appswebsite)
  - [Store Admin Dashboard](#3-store-admin-dashboard-appsadmin)
  - [Delivery Partner PWA](#4-delivery-partner-pwa-appsdelivery)
  - [Backend Services](#5-backend-microservices-servicesapi)
- [Tech Stack](#-tech-stack)
- [Quick Start & Local Setup](#-quick-start--local-setup)
- [API Directory Overview](#-api-directory-overview)
- [AI Engine Architecture](#-ai-engine-architecture)
- [Security & Compliance](#-security--compliance)
- [Testing & Quality Assurance](#-testing--quality-assurance)
- [DevOps & CI/CD Pipeline](#-devops--cicd-pipeline)
- [Enterprise Documentation Hub](#-enterprise-documentation-hub)
- [Roadmap](#-roadmap)
- [License & Author](#-license--author)

---

## 📱 Platform Overview

Daily Basket seamlessly integrates local Kirana dark store hubs with real-time customer ordering, automated rider dispatch, and doorstep OTP verification.

| Application | Platform | Key Capabilities | Directory |
| :--- | :--- | :--- | :--- |
| **📱 Customer App** | Flutter 3.19 (Android / iOS) | 10-min delivery, live GPS tracking, phone OTP, Razorpay, Wallet, AI assistant | [`apps/mobile`](apps/mobile) |
| **🌐 Customer Website** | Next.js 14 (React 18 + Tailwind) | Flash deals, full catalog explorer, dark theme, Razorpay checkout, live map | [`apps/website`](apps/website) |
| **🏢 Store Admin** | Next.js 14 (Zustand + Motion) | Real-time fulfillment queue (`CONFIRMED` → `DELIVERED`), stock management, KPIs | [`apps/admin`](apps/admin) |
| **🛵 Delivery Partner** | Next.js 14 PWA | Duty switch (`ONLINE`/`OFFLINE`), turn-by-turn map navigation, doorstep OTP verification | [`apps/delivery`](apps/delivery) |
| **⚙️ Backend API** | NestJS 10 + Prisma + Redis | JWT rotation, RBAC, WebSockets, BullMQ queues, multi-provider AI fallback | [`services/api`](services/api) |

---

## 🎨 Single Source of Truth (Google Stitch)

All user interface components, layouts, typography hierarchies, design tokens, color palettes, micro-animations, and visual flows are strictly anchored to the **Google Stitch Design Project**.

- Visual consistency is maintained across Flutter, Next.js web applications, and shared UI component packages.
- Shared design tokens are distributed via `@daily-basket/design-system` and `@daily-basket/theme`.
- Detailed UI guidelines are available in [`docs/GOOGLE_STITCH.md`](docs/GOOGLE_STITCH.md) and [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md).

---

## 🏗️ System Architecture

```mermaid
graph TD
    subgraph Client Applications
        Mobile["📱 Flutter Mobile App\n(Android / iOS)"]
        Web["🌐 Next.js Customer Web\n(Tailwind + React Query)"]
        Admin["🏢 Next.js Admin Dashboard\n(Real-time Order Queue)"]
        Rider["🛵 Delivery Partner PWA\n(GPS + OTP Verification)"]
    end

    subgraph API Gateway & Ingress
        NGINX["🛡️ NGINX Reverse Proxy\n(SSL Termination + Rate Limit)"]
        NestGateway["⚙️ NestJS API Gateway\n(Global Auth Guards & Throttler)"]
    end

    subgraph Core Backend Microservices
        AuthModule["🔐 Auth & Security Module\n(OTP, JWT, OAuth, MFA, Audit Logs)"]
        CatalogModule["📦 Catalog & Search Module\n(Categories, Brand Aliases, Keywords)"]
        OrdersModule["🛒 Orders & Quick-Buy Service\n(Cart, Subtotal, Fulfillment Queue)"]
        PaymentsModule["💳 Payments Service\n(Razorpay, HMAC Verification, Wallet)"]
        DeliveryModule["📍 Delivery Telemetry Service\n(GPS Tracking, Rider Assignment)"]
        AiEngine["🤖 Multi-Provider AI Engine\n(Gemini, Grok, OpenRouter, Local AI)"]
    end

    subgraph Persistence & Infrastructure
        PostgresDB[("🐘 PostgreSQL 16\n(Prisma ORM Models)")]
        RedisCache[("⚡ Redis 7\n(Session Store & Pub/Sub)")]
        BullMQWorkers["📩 BullMQ Queue Workers\n(Async Notification & Jobs)"]
        SocketServer["⚡ Socket.IO Gateways\n(Live Telemetry & Support Chat)"]
    end

    Mobile -->|HTTPS / WSS| NGINX
    Web -->|HTTPS / WSS| NGINX
    Admin -->|HTTPS / WSS| NGINX
    Rider -->|HTTPS / WSS| NGINX

    NGINX --> NestGateway

    NestGateway --> AuthModule
    NestGateway --> CatalogModule
    NestGateway --> OrdersModule
    NestGateway --> PaymentsModule
    NestGateway --> DeliveryModule
    NestGateway --> AiEngine

    AuthModule --> PostgresDB
    CatalogModule --> PostgresDB
    OrdersModule --> PostgresDB
    PaymentsModule --> PostgresDB
    DeliveryModule --> PostgresDB

    NestGateway --> RedisCache
    NestGateway --> BullMQWorkers
    NestGateway --> SocketServer
```

---

## 📂 Monorepo Directory Structure

```
daily-basket/
├── .agents/                        # Workspace rules & customization configs
├── apps/
│   ├── admin/                      # 🏢 Next.js Dark Store Admin Dashboard
│   ├── daily_basket_admin/         # 🏢 Flutter Admin App
│   ├── delivery/                   # 🛵 Next.js Delivery Partner PWA
│   ├── mobile/                     # 📱 Flutter Customer Mobile App (Clean Architecture)
│   └── website/                    # 🌐 Next.js Customer Web Portal (App Router)
├── assets/                         # Graphic banners, logos, and UI screenshot assets
├── docs/                           # 📘 Enterprise Documentation Hub
│   ├── features/                   # Feature specification guides (Products, Inventory, Payments, Notifications)
│   ├── ARCHITECTURE.md             # End-to-End System Architecture
│   ├── API.md                      # Comprehensive REST API Directory
│   ├── DATABASE.md                 # PostgreSQL Database Schema & Prisma Models
│   ├── AI.md                       # AI Engine Architecture & Provider Fallbacks
│   ├── DEPLOYMENT.md               # Production Deployment Specs (Docker, Compose, NGINX, K8s)
│   └── ...                         # Dedicated engineering, security & operations docs
├── infrastructure/
│   ├── docker/                     # Multi-stage production Dockerfiles
│   ├── k8s/                        # Kubernetes deployment manifests
│   ├── nginx/                      # NGINX reverse proxy configuration
│   ├── docker-compose.yml          # Local multi-container development environment
│   └── docker-compose.prod.yml     # Production orchestration compose setup
├── packages/
│   ├── api-client/                 # Shared Axios API SDK Client
│   ├── constants/                  # Business logic constants and enums
│   ├── design-system/              # Web design tokens and utilities
│   ├── shared-types/               # TypeScript interfaces & DTO contracts
│   ├── shared-ui/                  # Shared React UI component library
│   ├── shared-utils/               # Currency, date, and validation utilities
│   └── theme/                      # Daily Basket branding and color palette definitions
├── scripts/                        # Database seeding, backup & setup automation scripts
├── services/
│   └── api/                        # ⚙️ NestJS API Gateway & Microservices Backend
│       ├── prisma/                 # Database schema definitions & migrations
│       └── src/                    # NestJS modules (auth, products, orders, payments, delivery, AI)
├── CHANGELOG.md                    # Keep a Changelog version history
├── CONTRIBUTING.md                 # Developer contribution guidelines
├── CODE_OF_CONDUCT.md              # Contributor code of conduct
├── LICENSE                         # MIT License
├── ROADMAP.md                      # Feature & milestone roadmap
├── SECURITY.md                     # Security vulnerability disclosure policy
└── SUPPORT.md                      # Technical support & community channels
```

---

## ✨ Feature Matrix

### 1. Customer Mobile App (`apps/mobile`)
- **Authentication**: Phone OTP verification, Email/Password login, Google OAuth, TOTP MFA, Biometric login support.
- **Home Feed**: Live delivery ETA timer badge, delivery address selector, dynamic categories, flash deals carousel.
- **Smart Catalog & Search**: Instant debounced catalog search with trending keywords, brand alias matching, and category filtering.
- **Cart & Checkout**: Interactive cart drawer with free delivery progress meter, instant coupon validation (`DAILY100`), Razorpay payment gateway (UPI, Card, NetBanking, COD).
- **Live GPS Order Tracking**: Animated step-by-step order progress timeline, driver contact trigger, and live GPS map routing via Socket.IO.
- **Wallet & Loyalty**: Digital Daily Basket Wallet balance, transaction ledger, instant refill, and Daily Basket Plus VIP perks.
- **AI Voice & Visual Search**: Voice search interface and camera image recognition powered by backend multi-provider AI.

### 2. Customer Web Portal (`apps/website`)
- **Responsive Web Portal**: Built using Next.js 14 App Router, React 18, and TailwindCSS.
- **Dark Mode Aesthetic**: Google Stitch compliant dark-mode design system with rich micro-interactions.
- **Order Management**: Order placement, address management, coupon redemption, active delivery map, and delivery feedback rating.
- **Account Security Hub**: Active session device management, password reset, 2FA toggle, and security audit activity log.

### 3. Store Admin Dashboard (`apps/admin`)
- **Fulfillment Queue**: Real-time order dispatch stream (`NEW` → `CONFIRMED` → `PACKING` → `READY_FOR_PICKUP` → `DISPATCHED`).
- **Inventory Control**: Live stock adjustments, low-stock threshold alerts, SKU search, and catalog editor.
- **Store KPIs**: Real-time revenue analytics, average packing time, driver dispatch efficiency, and customer satisfaction metrics.

### 4. Delivery Partner PWA (`apps/delivery`)
- **Duty Controller**: One-tap `ONLINE`/`OFFLINE` toggle with automated GPS telemetry broadcast.
- **Active Orders Queue**: Dark store pickup location, customer drop-off instructions, item packing manifest.
- **Doorstep Verification**: Customer OTP PIN verification before marking orders as `DELIVERED`.
- **Earnings Ledger**: Daily base pay, surge incentives, tip breakdown, and performance stats.

### 5. Backend Microservices (`services/api`)
- **NestJS Clean Architecture**: Decoupled controllers, domain services, custom guards, logging interceptors, and exception filters.
- **Database & Cache**: PostgreSQL 16 managed by Prisma ORM 5 paired with Redis 7 caching and session storage.
- **Queues & Realtime**: BullMQ job processing for notifications and email triggers alongside Socket.IO event gateways.
- **Multi-Provider AI Engine**: Primary Gemini model with automatic fallback to Grok, OpenRouter, and local models.

---

## 🛠️ Tech Stack

| Domain | Technology | Details |
| :--- | :--- | :--- |
| **Mobile App** | Flutter 3.19 / Dart 3.3 | Provider pattern, Clean Architecture, Material 3 |
| **Web Applications** | Next.js 14 / React 18 | App Router, TailwindCSS, TanStack Query, Framer Motion |
| **Backend API** | NestJS 10 / Node.js 20 | TypeScript 5.3, `@nestjs/swagger`, `@nestjs/throttler` |
| **Database & ORM** | PostgreSQL 16 / Prisma 5 | Parameterized queries, UUID primary keys, spatial coordinates |
| **Caching & Messaging** | Redis 7.2 / BullMQ 5 | Session caching, Pub/Sub events, async queue processing |
| **Real-time Engine** | Socket.IO 4 | Dual-way WebSocket telemetry for live tracking & support chat |
| **Payment Gateway** | Razorpay SDK | Razorpay Order intent, HMAC SHA-256 webhook signature verification |
| **AI Integration** | Google Gemini / Grok / OpenRouter | Automated fallback manager, security sanitization, AI tool calling |
| **DevOps & Infra** | Docker / NGINX / K8s | Multi-stage Docker build, reverse proxy, GitHub Actions CI/CD |

---

## ⚡ Quick Start & Local Setup

### Prerequisites
- Node.js >= 18.18.0
- pnpm >= 8.15.0
- Flutter SDK >= 3.19.0
- Docker & Docker Compose

### 1. Clone & Install Dependencies
```bash
git clone https://github.com/Sachinxcode-01/Daily-Basket.git
cd Daily-Basket
pnpm install
```

### 2. Configure Environment Variables
Copy template `.env` file to API service:
```bash
cp .env.production.example services/api/.env
```
Ensure database credentials match local or container settings:
```env
PORT=4000
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/daily_basket?schema=public"
REDIS_HOST="localhost"
REDIS_PORT=6379
JWT_SECRET="super-secret-jwt-key"
RAZORPAY_KEY_ID="rzp_test_sample"
RAZORPAY_KEY_SECRET="sample_secret"
```

### 3. Start Infrastructure (PostgreSQL + Redis)
```bash
docker compose -f infrastructure/docker-compose.yml up -d
```

### 4. Initialize Database
```bash
cd services/api
npx prisma db push
npx prisma generate
```

### 5. Run Web & API Applications
```bash
# From root directory — runs API, Website, Admin, and Delivery applications concurrently
pnpm dev
```
- **API Gateway**: `http://localhost:4000/api/v1`
- **Swagger Documentation**: `http://localhost:4000/api/docs`
- **Customer Web**: `http://localhost:3005`
- **Admin Dashboard**: `http://localhost:3001`
- **Delivery PWA**: `http://localhost:3002`

### 6. Run Flutter Mobile App
```bash
cd apps/mobile
flutter pub get
flutter run
```

---

## 🔌 API Directory Overview

Below is a summary of primary API routes. For full details, see [`docs/API.md`](docs/API.md) or access Swagger UI at `/api/docs`.

| Module | Method | Endpoint Route | Description | Auth / Role |
| :--- | :--- | :--- | :--- | :--- |
| **Auth** | `POST` | `/api/v1/auth/login-otp` | Request 6-digit phone verification OTP | Public |
| **Auth** | `POST` | `/api/v1/auth/verify-otp` | Verify OTP & receive JWT token pair | Public |
| **Auth** | `POST` | `/api/v1/auth/google` | Authenticate using Google OAuth token | Public |
| **Products** | `GET` | `/api/v1/products/home-feed` | Fetch home page flash deals & categories | Public |
| **Products** | `GET` | `/api/v1/products/search?query=` | Debounced full-text catalog search | Public |
| **Orders** | `POST` | `/api/v1/orders` | Create new 10-minute grocery order | Customer |
| **Payments** | `POST` | `/api/v1/payments/initiate` | Create Razorpay payment order intent | Customer |
| **Payments** | `POST` | `/api/v1/payments/verify` | Verify Razorpay HMAC SHA-256 signature | Customer |
| **Delivery** | `GET` | `/api/v1/delivery/track/:id` | Fetch real-time GPS telemetry & ETA | Customer |
| **Analytics** | `GET` | `/api/v1/analytics/:storeId` | Dark Store revenue & packing KPIs | Admin / Store Manager |

---

## 🤖 AI Engine Architecture

Daily Basket integrates a multi-provider LLM engine capable of processing natural language customer support, recipe recommendations, voice search, and package image freshness analysis.

```mermaid
graph LR
    Client["Client Request\n(Text / Voice / Image)"] --> Security["AiSecurityService\n(Prompt Sanitization)"]
    Security --> ProviderMgr["ProviderManager\n(Health & Routing)"]

    ProviderMgr -->|Primary| Gemini["Google Gemini 1.5 Flash"]
    ProviderMgr -->|Fallback 1| Grok["xAI Grok Provider"]
    ProviderMgr -->|Fallback 2| OpenRouter["OpenRouter API"]
    ProviderMgr -->|Fallback 3| Local["Local Ollama Provider"]

    Gemini -->|Failure / Timeout| FallbackMgr["FallbackManager"]
    FallbackMgr --> Grok

    ProviderMgr --> ToolReg["AiToolsRegistry\n(Function Calling)"]
    ToolReg --> Execute["Execute Store Actions\n(Check Inventory / Track Order)"]
```

See [`docs/AI.md`](docs/AI.md) for full provider failover and tool registration details.

---

## 🔒 Security & Compliance

- **Authentication & JWT Rotation**: Short-lived JWT access tokens paired with secure HTTP-only refresh tokens.
- **Role-Based Access Control (RBAC)**: Enforced across controllers using `@Roles()` decorator and `RolesGuard`.
- **Payment Security**: Strict HMAC SHA-256 signature validation on Razorpay payments and webhooks.
- **Throttling & Helmet**: NestJS Throttler protects endpoints from brute force and DDoS attacks.
- **Database Safety**: Prisma ORM enforces parameterized SQL queries, eliminating SQL injection.
- **Detailed Security Specs**: See [`docs/SECURITY_ARCHITECTURE.md`](docs/SECURITY_ARCHITECTURE.md) and [`docs/AUTHENTICATION.md`](docs/AUTHENTICATION.md).

---

## 🧪 Testing & Quality Assurance

- **Flutter Static Analysis**: `flutter analyze` — **0 Errors, 0 Warnings**.
- **Flutter Unit & Widget Tests**: `flutter test` — Complete coverage for providers, services, and core UI widgets.
- **NestJS Unit Tests**: `pnpm --filter api test` — Jest test suites covering authentication, product catalog, cart calculation, and AI fallback managers.
- **Comprehensive Guide**: See [`docs/TESTING.md`](docs/TESTING.md).

---

## 🚀 DevOps & CI/CD Pipeline

The GitHub Actions automated pipeline validates all pull requests and deployment commits:

```yaml
Pipeline Workflow:
  1. Lint & Typecheck:
     - Next.js apps (website, admin, delivery): ESLint + tsc --noEmit
     - NestJS API service: ESLint + tsc
  2. Automated Test Execution:
     - Flutter Customer App: flutter analyze + flutter test
     - NestJS API Service: pnpm test (Jest)
  3. Container Build & Push:
     - Multi-stage Docker build for NGINX, API, Website, Admin, and Delivery apps
```

See [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) and [`docs/DEVOPS.md`](docs/DEVOPS.md) for deployment runbooks.

---

## 📚 Enterprise Documentation Hub

Every document in the Daily Basket repository is fully detailed and maintained:

| Document Category | Document Link | Description |
| :--- | :--- | :--- |
| **Documentation Matrix** | [`docs/README.md`](docs/README.md) | Complete documentation index & navigation hub |
| **Architecture** | [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | End-to-end system topology & component hierarchy |
| **System Design** | [`docs/SYSTEM_DESIGN.md`](docs/SYSTEM_DESIGN.md) | Low-level design, data pipelines & state management |
| **REST API Reference** | [`docs/API.md`](docs/API.md) | Endpoint specifications, DTOs, & validation schemas |
| **OpenAPI / Swagger** | [`docs/OPENAPI.md`](docs/OPENAPI.md) | Interactive Swagger UI setup & OpenAPI spec |
| **Database & ERD** | [`docs/DATABASE.md`](docs/DATABASE.md) / [`docs/ERD.md`](docs/ERD.md) | PostgreSQL Prisma models, constraints & ER diagrams |
| **Product Specs (PRD)** | [`docs/PRD.md`](docs/PRD.md) | Product vision, personas, features & user stories |
| **Technical Specs (TRD)** | [`docs/TRD.md`](docs/TRD.md) | SLA benchmarks, tech stack specs & quality targets |
| **Google Stitch UI** | [`docs/GOOGLE_STITCH.md`](docs/GOOGLE_STITCH.md) | Single source of truth design system & assets |
| **Design Tokens** | [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md) | Color palettes, typography, icons, & shared components |
| **Backend API Spec** | [`docs/BACKEND.md`](docs/BACKEND.md) | NestJS microservices, controllers, & ORM layer |
| **Frontend Architecture** | [`docs/FRONTEND.md`](docs/FRONTEND.md) | Next.js App Router, SSR/ISR, Zustand, & packages |
| **Mobile Architecture** | [`docs/MOBILE.md`](docs/MOBILE.md) | Flutter Clean Architecture, Provider state, & native features |
| **Customer Web App** | [`docs/WEBSITE.md`](docs/WEBSITE.md) | Next.js Customer Web portal technical breakdown |
| **Admin Dashboard** | [`docs/ADMIN_APP.md`](docs/ADMIN_APP.md) | Dark Store Admin Dashboard fulfillment queue |
| **Delivery PWA** | [`docs/DELIVERY_APP.md`](docs/DELIVERY_APP.md) | Rider PWA, GPS tracking, & doorstep OTP logic |
| **Auth & Security** | [`docs/AUTHENTICATION.md`](docs/AUTHENTICATION.md) | Phone OTP, JWT rotation, TOTP MFA, & OAuth |
| **Security Architecture** | [`docs/SECURITY_ARCHITECTURE.md`](docs/SECURITY_ARCHITECTURE.md) | Security safeguards, RBAC, Helmet, & auditing |
| **AI Integration** | [`docs/AI.md`](docs/AI.md) | Gemini/Grok multi-provider AI engine & tools |
| **Realtime Engine** | [`docs/REALTIME.md`](docs/REALTIME.md) / [`docs/SOCKETS.md`](docs/SOCKETS.md) | Socket.IO event dictionary & WebSocket gateways |
| **Cache & Redis** | [`docs/REDIS.md`](docs/REDIS.md) | Redis key namespaces, caching policies, & Pub/Sub |
| **Queue Workers** | [`docs/BULLMQ.md`](docs/BULLMQ.md) | BullMQ background jobs & notification processors |
| **DevOps & Containers** | [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) / [`docs/DEVOPS.md`](docs/DEVOPS.md) | Docker, Docker Compose, NGINX proxy, & K8s |
| **Installation & Setup** | [`docs/INSTALLATION.md`](docs/INSTALLATION.md) / [`docs/SETUP.md`](docs/SETUP.md) | Environment setup, database seeding, & execution |
| **Getting Started** | [`docs/GETTING_STARTED.md`](docs/GETTING_STARTED.md) | Onboarding guide for new developers |
| **Environment Vars** | [`docs/ENVIRONMENT.md`](docs/ENVIRONMENT.md) | Complete environment variable specification |
| **Testing & Quality** | [`docs/TESTING.md`](docs/TESTING.md) / [`docs/PERFORMANCE.md`](docs/PERFORMANCE.md) | Unit tests, static analysis, & load testing specs |
| **Operations Runbook** | [`docs/GO_LIVE_RUNBOOK.md`](docs/GO_LIVE_RUNBOOK.md) / [`docs/OPERATIONS.md`](docs/OPERATIONS.md) | Deployment runbook, monitoring, & on-call rules |
| **Disaster Recovery** | [`docs/DISASTER_RECOVERY.md`](docs/DISASTER_RECOVERY.md) / [`docs/BACKUP_STRATEGY.md`](docs/BACKUP_STRATEGY.md) | Backup automation, recovery RTO/RPO SLAs |
| **Troubleshooting & FAQ** | [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) / [`docs/FAQ.md`](docs/FAQ.md) | Common errors, solutions, & architectural FAQs |
| **Features Deep-Dives** | [`docs/features/PRODUCTS.md`](docs/features/PRODUCTS.md) | Catalog, category taxonomy, search keywords |
| **Inventory Feature** | [`docs/features/INVENTORY.md`](docs/features/INVENTORY.md) | Multi-store dark store stock allocation |
| **Payments Feature** | [`docs/features/PAYMENTS.md`](docs/features/PAYMENTS.md) | Razorpay checkout, webhooks & wallet ledger |
| **Notifications Feature** | [`docs/features/NOTIFICATIONS.md`](docs/features/NOTIFICATIONS.md) | FCM push, SMS OTP, and email notification feeds |

---

## 🗺️ Roadmap

- [x] **v1.0.0 (Current Release)**
  - Flutter Mobile App (35+ screens, Material 3, Clean Architecture)
  - Next.js Customer Web Portal (31 pages, TailwindCSS, Dark mode)
  - Next.js Admin Dashboard (Real-time dispatch queue, KPIs)
  - Next.js Delivery Partner PWA (GPS tracking, Doorstep OTP)
  - NestJS Backend Gateway & Prisma PostgreSQL ORM
  - Redis 7 Caching, BullMQ queues, Socket.IO WebSockets
  - Multi-Provider AI Fallback Engine (Gemini, Grok, OpenRouter, Local)
  - Razorpay Payment Gateway integration with HMAC SHA-256 verification
- [ ] **v1.1.0 (Upcoming)**
  - FCM Push Notification service integration
  - Multi-language localization (Kannada, Hindi, English)
- [ ] **v2.0.0 (Planned)**
  - Multi-dark store automated dispatcher hub
  - Predictive AI inventory demand forecasting

---

## 📜 License & Author

Distributed under the **MIT License** — see [`LICENSE`](LICENSE) for details.

<br/>

<p align="center">
  Built with ❤️ by <strong>Sachin</strong> &nbsp;|&nbsp;
  <a href="https://github.com/Sachinxcode-01">@Sachinxcode-01</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20in-India%20🇮🇳-FF9933?style=flat" />
  <img src="https://img.shields.io/badge/Built%20for-Gadag%20%26%20Beyond-006b23?style=flat" />
</p>
