# 🛒 Daily Basket — Enterprise 10-Minute Grocery Delivery Platform

![Daily Basket Banner](assets/banner.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e.svg?style=for-the-badge)](https://github.com/Sachinxcode-01/Daily-Basket/blob/main/LICENSE)
[![Firebase Auth](https://img.shields.io/badge/Firebase-Admin%20%26%20Auth-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Google OAuth](https://img.shields.io/badge/Google-OAuth%202.0%20SSO-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://developers.google.com/identity)
[![Flutter](https://img.shields.io/badge/Flutter-3.19.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![NestJS](https://img.shields.io/badge/NestJS-10.3-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com)
[![Next.js](https://img.shields.io/badge/Next.js-14.2-black?style=for-the-badge&logo=nextdotjs&logoColor=white)](https://nextjs.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Prisma](https://img.shields.io/badge/Prisma-5.10-2D3748?style=for-the-badge&logo=prisma&logoColor=white)](https://prisma.io)
[![Redis](https://img.shields.io/badge/Redis-7.2-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io)
[![Socket.IO](https://img.shields.io/badge/Socket.IO-4.8-black?style=for-the-badge&logo=socketdotio&logoColor=white)](https://socket.io)
[![CI/CD Status](https://img.shields.io/badge/CI%2FCD-Passing-22c55e?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/Sachinxcode-01/Daily-Basket/actions)
![Production Ready](https://img.shields.io/badge/Production-Ready-006b23?style=for-the-badge)

> **Daily Basket** is an enterprise-grade, hyper-local 10-minute quick-commerce platform delivering fresh groceries, vegetables, dairy, and household essentials. Built as a clean-architecture monorepo, it powers cross-platform Flutter customer and store admin mobile apps, three Next.js 14 web portals (Customer Storefront, Dark Store Admin, Delivery Partner PWA), and a 44-module NestJS microservices backend with real-time WebSockets, Redis caching, BullMQ job queues, end-to-end database persistence, and multi-provider AI engine.

---

## 📋 Table of Contents

- [Platform Overview](#platform-overview)
- [Single Source of Truth (Google Stitch)](#single-source-of-truth-google-stitch)
- [System Architecture](#system-architecture)
- [Monorepo Directory Structure](#monorepo-directory-structure)
- [Feature Matrix](#feature-matrix)
  - [Customer Mobile App](#customer-mobile-app)
  - [Customer Web Portal](#customer-web-portal)
  - [Store Admin Web Dashboard](#store-admin-web-dashboard)
  - [Store Admin Mobile App](#store-admin-mobile-app)
  - [Delivery Partner PWA](#delivery-partner-pwa)
  - [Backend Microservices & Database](#backend-microservices--database)
- [Tech Stack](#tech-stack)
- [Quick Start & Local Setup](#quick-start--local-setup)
- [API Directory Overview](#api-directory-overview)
- [AI Engine Architecture](#ai-engine-architecture)
- [Security & Compliance](#security--compliance)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [DevOps & CI/CD Pipeline](#devops--cicd-pipeline)
- [Enterprise Documentation Hub](#enterprise-documentation-hub)
- [Roadmap](#roadmap)
- [License & Author](#license--author)

---

## Platform Overview

Daily Basket seamlessly integrates local Kirana dark store hubs with real-time customer ordering, automated rider dispatch, live fleet map telemetry, and doorstep OTP verification.

| Application | Platform | Key Capabilities | Directory |
| :--- | :--- | :--- | :--- |
| **📱 Customer App** | Flutter 3.19 (Android / iOS) | 10-min delivery, live GPS tracking, phone OTP, Google OAuth SSO, address CRUD, 1-click reorder, Razorpay, Wallet, AI assistant | [`apps/mobile`](apps/mobile) |
| **🌐 Customer Website** | Next.js 14 (React 18 + Tailwind) | Flash deals, full catalog explorer, dark theme, address CRUD, 1-click reorder, Razorpay checkout, live tracking map | [`apps/website`](apps/website) |
| **🏢 Store Admin Web** | Next.js 14 (Zustand + Lucide) | Real-time fulfillment queue (`NEW` → `CONFIRMED` → `PACKING` → `DISPATCHED`), live rider assignment modal, fleet GPS map, KPIs | [`apps/admin`](apps/admin) |
| **📱 Store Admin App** | Flutter 3.19 (Android / iOS) | Mobile store manager companion for on-the-go order status inspection and inventory management | [`apps/daily_basket_admin`](apps/daily_basket_admin) |
| **🛵 Delivery Partner** | Next.js 14 PWA | Duty switch (`ONLINE`/`OFFLINE`), turn-by-turn map navigation, live telemetry broadcast, doorstep OTP verification | [`apps/delivery`](apps/delivery) |
| **⚙️ Backend API** | NestJS 10 + Prisma + Redis | 44 domain modules, JWT rotation, RBAC, WebSockets, BullMQ queues, multi-provider AI fallback, PostgreSQL persistence | [`services/api`](services/api) |

---

## Single Source of Truth (Google Stitch)

All user interface components, layouts, typography hierarchies, design tokens, color palettes, micro-animations, and visual flows are strictly anchored to the **Google Stitch Design Project**.

- Visual consistency is maintained across Flutter, Next.js web applications, and shared UI component packages.
- Shared design tokens are distributed via `@daily-basket/design-system` and `@daily-basket/theme`.
- Zero duplicate design tokens across apps: re-exports adhere to approved Stitch layouts, spacing, and atomic styling.
- Detailed UI guidelines are available in [`docs/GOOGLE_STITCH.md`](docs/GOOGLE_STITCH.md) and [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md).

---

## System Architecture

```mermaid
graph TD
    subgraph Client Applications
        Mobile["📱 Flutter Customer App\n(Android / iOS)"]
        AdminMobile["📱 Flutter Admin App\n(Store Manager Mobile)"]
        Web["🌐 Next.js Customer Web\n(Tailwind + React Query)"]
        Admin["🏢 Next.js Admin Dashboard\n(Real-time Order Queue & Fleet Map)"]
        Rider["🛵 Delivery Partner PWA\n(GPS + OTP Verification)"]
    end

    subgraph API Gateway & Ingress
        NGINX["🛡️ NGINX Reverse Proxy\n(SSL Termination + Rate Limit)"]
        NestGateway["⚙️ NestJS API Gateway\n(Global Auth Guards & Throttler)"]
    end

    subgraph Core Backend Microservices
        AuthModule["🔐 Auth & Security Module\n(OTP, JWT, OAuth, MFA, Audit Logs)"]
        UsersModule["👤 Users & Address Module\n(Address CRUD, Defaults, Geocoding)"]
        CatalogModule["📦 Catalog & Search Module\n(Categories, Brand Aliases, Keywords)"]
        CartModule["🛍️ Cart Persistence Module\n(Cart Sync, Guest Merging)"]
        OrdersModule["🛒 Orders & Quick-Buy Service\n(Cart, Pricing, Reorder, Fulfillment Queue)"]
        PaymentsModule["💳 Payments Service\n(Razorpay, HMAC Verification, Wallet)"]
        DeliveryModule["📍 Delivery & Fleet Service\n(GPS Tracking, Rider Assignment, Telemetry)"]
        AiEngine["🤖 Multi-Provider AI Engine\n(Gemini, Grok, OpenRouter, Local AI)"]
    end

    subgraph Persistence & Infrastructure
        PostgresDB[("🐘 PostgreSQL 16\n(Prisma ORM Models)")]
        RedisCache[("⚡ Redis 7\n(Session Store & Pub/Sub)")]
        BullMQWorkers["📩 BullMQ Queue Workers\n(Async Notification & Jobs)"]
        SocketServer["⚡ Socket.IO Gateways\n(Live Telemetry & Fleet Tracking)"]
    end

    Mobile -->|HTTPS / WSS| NGINX
    AdminMobile -->|HTTPS| NGINX
    Web -->|HTTPS / WSS| NGINX
    Admin -->|HTTPS / WSS| NGINX
    Rider -->|HTTPS / WSS| NGINX

    NGINX --> NestGateway

    NestGateway --> AuthModule
    NestGateway --> UsersModule
    NestGateway --> CatalogModule
    NestGateway --> CartModule
    NestGateway --> OrdersModule
    NestGateway --> PaymentsModule
    NestGateway --> DeliveryModule
    NestGateway --> AiEngine

    AuthModule --> PostgresDB
    UsersModule --> PostgresDB
    CatalogModule --> PostgresDB
    CartModule --> PostgresDB
    OrdersModule --> PostgresDB
    PaymentsModule --> PostgresDB
    DeliveryModule --> PostgresDB

    NestGateway --> RedisCache
    NestGateway --> BullMQWorkers
    NestGateway --> SocketServer
```

---

## Monorepo Directory Structure

```text
daily-basket/
├── .agents/                        # Workspace rules & customization configs
├── apps/
│   ├── admin/                      # 🏢 Next.js Dark Store Admin Dashboard (Fulfillment Queue & Fleet Map)
│   ├── daily_basket_admin/         # 🏢 Flutter Admin Mobile App (Store Manager Companion)
│   ├── delivery/                   # 🛵 Next.js Delivery Partner PWA (Turn-by-turn navigation & OTP)
│   ├── mobile/                     # 📱 Flutter Customer Mobile App (Clean Architecture, Material 3)
│   └── website/                    # 🌐 Next.js Customer Web Portal (App Router, Tailwind CSS)
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
│   └── api/                        # ⚙️ NestJS API Gateway & Microservices Backend (44 modules)
│       ├── prisma/                 # Database schema definitions & migrations
│       ├── src/                    # Domain modules, controllers, guards & services
│       └── firebase-service-account.json # Firebase Admin credentials
├── pnpm-workspace.yaml             # Monorepo workspace configuration
└── package.json                    # Workspace scripts & tooling
```

---

## Feature Matrix

### Customer Mobile App

- **High-Performance Architecture**: 60–120 FPS high refresh-rate animation pipeline built on Flutter Clean Architecture and Provider state management.
- **Authentication**: Phone OTP verification, Email/Password login, Google OAuth 2.0 / Firebase SSO, TOTP MFA, and secure token caching with Biometrics.
- **Home Feed**: Live delivery ETA timer badge (10-minute guarantee), dynamic category feed, Kirana flash deals carousel, and store availability indicator.
- **Smart Catalog & Search**: Debounced instant catalog search with trending queries, brand alias matching, and category filtering.
- **Cart & Database Sync**: Real-time cart synchronization with backend database, free delivery progress meter, and instant coupon validation (`DAILY100`).
- **End-to-End Address Management**: Add, edit, delete, and set default delivery addresses (Home, Work, Other) backed by Prisma PostgreSQL database with coordinates and floor details.
- **Live GPS Order Tracking**: Animated step-by-step order progress timeline (`CONFIRMED` → `PACKING` → `OUT_FOR_DELIVERY` → `DELIVERED`), interactive Google Maps live telemetry with rider vehicle icon, and driver contact trigger.
- **Order History & 1-Click Reorder**: Complete order history fetched from Prisma database, interactive order details, GST breakdown, and 1-click reorder flow adding items straight back to cart.
- **Razorpay Payments**: Seamless Razorpay checkout (UPI, Credit/Debit Cards, NetBanking, COD) with cryptographic HMAC SHA-256 verification.
- **Daily Basket Wallet**: In-app digital wallet balance, instant checkout, transaction ledger, and Daily Basket Plus VIP perks.
- **AI Voice & Visual Search**: Voice search interface and camera image recognition powered by backend multi-provider AI engine.

### Customer Web Portal

- **Responsive Web Experience**: Built on Next.js 14 App Router, React 18, and TailwindCSS with Google Stitch dark-mode design system.
- **Google & Firebase SSO**: Single-click sign-in and sign-up with automatic anonymous guest cart merging upon authentication.
- **Address CRUD Management**: Comprehensive address management (`/profile`, `/add-address`) with full Prisma database persistence, edit and delete actions, and default selection.
- **Order History & 1-Click Reorder**: Detailed order history, real-time live order tracking map, and instant 1-click reorder into cart.
- **Checkout & Razorpay**: Multi-step checkout with coupon code application, wallet balance toggle, and secure payment processing.
- **Account Security Hub**: Active session device management, password reset, 2FA toggle, and security audit activity log.

### Store Admin Web Dashboard

- **Real-Time Fulfillment Queue**: Live dispatch stream tracking order states (`NEW` → `CONFIRMED` → `PACKING` → `READY_FOR_PICKUP` → `DISPATCHED` → `DELIVERED`).
- **Live Dispatch & Fleet Map**: Rider assignment modal with instant partner selection and real-time live map tracking of delivery riders and active orders.
- **Inventory Control**: Live stock adjustments, low-stock threshold alerts, SKU search, and catalog editor.
- **Store KPIs**: Real-time revenue analytics, average packing time, driver dispatch efficiency, and customer satisfaction metrics.
- **Go-Live Checklist**: Pre-launch verification for database, payment gateways, and Firebase credentials.

### Store Admin Mobile App

- **On-the-Go Store Operations**: Flutter companion app (`apps/daily_basket_admin`) for dark store managers.
- **Mobile Fulfillment**: Inspect store metrics, pending packing orders, and inventory availability on mobile devices.

### Delivery Partner PWA

- **Duty Controller**: One-tap `ONLINE`/`OFFLINE` toggle with automated GPS telemetry broadcast via Socket.IO.
- **Active Orders Queue**: Dark store pickup location, customer drop-off instructions, and item packing manifest.
- **Doorstep Verification**: Customer OTP PIN verification required before marking orders as `DELIVERED`.
- **Earnings Ledger**: Daily base pay, surge incentives, tip breakdown, and performance stats.

### Backend Microservices & Database

- **NestJS Clean Architecture**: 44 domain modules with decoupled controllers, services, custom guards, logging interceptors, and exception filters.
- **Database Persistence**: PostgreSQL 16 managed by Prisma ORM 5 with strict relational integrity, UUID primary keys, and spatial coordinates.
- **Address & User Management**: Full CRUD endpoints for user delivery addresses (`/api/v1/addresses`) with default address tracking.
- **Cart & Order Persistence**: Persistent server-side cart with anonymous-to-user merging and transactional order placement with inventory reservation.
- **Firebase Admin SDK**: Cryptographic token verification for Google OAuth tokens using project credentials (`daily-basket-8b266`).
- **Queues & Real-time**: BullMQ job processing for notifications and email triggers alongside Socket.IO live telemetry gateways.
- **Multi-Provider AI Engine**: Primary Google Gemini 1.5 Flash with automated failover to xAI Grok, OpenRouter, and local Ollama models.

---

## Tech Stack

| Domain | Technology | Details |
| :--- | :--- | :--- |
| **Mobile App (Customer)** | Flutter 3.19 / Dart 3.3 | Provider pattern, Clean Architecture, Material 3, Google Maps |
| **Mobile App (Admin)** | Flutter 3.19 / Dart 3.3 | Dark store operations companion, Provider pattern |
| **Web Applications** | Next.js 14 / React 18 | App Router, TailwindCSS, TanStack Query, Framer Motion |
| **Backend API** | NestJS 10 / Node.js 20 | TypeScript 5.4, `@nestjs/swagger`, `@nestjs/throttler`, 44 modules |
| **Authentication & Push** | Firebase Admin / Google OAuth / JWT | Firebase Service Account, token verification, JWT rotation, OTP |
| **Database & ORM** | PostgreSQL 16 / Prisma 5 | Parameterized queries, UUID primary keys, spatial coordinates |
| **Caching & Messaging** | Redis 7.2 / BullMQ 6 | Session caching, Pub/Sub events, async queue processing |
| **Real-time Engine** | Socket.IO 4.8 | Dual-way WebSocket telemetry for live tracking & support chat |
| **Payment Gateway** | Razorpay SDK | Razorpay Order intent, HMAC SHA-256 webhook signature verification |
| **AI Integration** | Google Gemini / Grok / OpenRouter | Automated fallback manager, security sanitization, AI tool calling |
| **DevOps & Infra** | Docker / NGINX / K8s | Multi-stage Docker build, reverse proxy, GitHub Actions CI/CD |

---

## Quick Start & Local Setup

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

Copy the template `.env` file to API service:

```bash
cp .env.production.example services/api/.env
```

Ensure environment configurations are set:

```env
PORT=4000
NODE_ENV=development
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/daily_basket?schema=public"
REDIS_HOST="localhost"
REDIS_PORT=6379
JWT_SECRET="super-secret-jwt-key"
RAZORPAY_KEY_ID="rzp_test_sample"
RAZORPAY_KEY_SECRET="sample_secret"
FIREBASE_PROJECT_ID="daily-basket-8b266"
FIREBASE_SERVICE_ACCOUNT_PATH="./firebase-service-account.json"
```

### 3. Start Infrastructure (PostgreSQL + Redis)

```bash
# Using root workspace script
pnpm docker:up

# Or directly via docker compose:
docker compose -f infrastructure/docker-compose.yml up -d
```

### 4. Initialize Database

```bash
# Generate Prisma Client and apply migrations
pnpm prisma:generate
pnpm prisma:migrate

# Seed product catalog, categories, and dark store inventory
pnpm seed
```

### 5. Run Web & API Applications

```bash
# From root directory — runs API, Website, Admin, and Delivery applications concurrently
pnpm dev

# Or run individual applications as needed:
pnpm dev:api       # Starts NestJS API on port 4000
pnpm dev:website   # Starts Customer Website on port 3005
pnpm dev:admin     # Starts Admin Dashboard on port 3001
```

| Application | URL | Description |
| :--- | :--- | :--- |
| **API Gateway** | `http://localhost:4000/api/v1` | Core REST API Gateway |
| **Swagger Docs** | `http://localhost:4000/api/docs` | Interactive OpenAPI / Swagger UI |
| **Customer Web** | `http://localhost:3005` | Next.js Customer Web Storefront |
| **Store Admin** | `http://localhost:3001` | Dark Store Order Fulfillment Dashboard |
| **Delivery PWA** | `http://localhost:3002` | Delivery Partner Navigation & Dispatch PWA |

### 6. Run Flutter Mobile Apps

**Customer Mobile App:**

```bash
cd apps/mobile
flutter pub get
flutter run
```

**Admin Mobile Companion App:**

```bash
cd apps/daily_basket_admin
flutter pub get
flutter run
```

---

## API Directory Overview

Below is a summary of the primary API endpoints. For full details, see [`docs/API.md`](docs/API.md) or access Swagger UI at `/api/docs`.

| Module | Method | Endpoint Route | Description | Auth / Role |
| :--- | :--- | :--- | :--- | :--- |
| **Auth** | `POST` | `/api/v1/auth/login-otp` | Request 6-digit phone verification OTP | Public |
| **Auth** | `POST` | `/api/v1/auth/verify-otp` | Verify OTP & receive JWT token pair | Public |
| **Auth** | `POST` | `/api/v1/auth/google-login` | Authenticate using Google OAuth / Firebase token | Public |
| **Auth** | `GET` | `/api/v1/auth/google/status` | Firebase & Google credentials health diagnostic | Public |
| **Users** | `GET` | `/api/v1/profile` | Retrieve customer profile information | Optional JWT |
| **Users** | `PUT` | `/api/v1/profile` | Update customer profile details | Optional JWT |
| **Addresses** | `GET` | `/api/v1/addresses` | Fetch saved delivery addresses for authenticated user | Optional JWT |
| **Addresses** | `POST` | `/api/v1/addresses` | Create new delivery address (with lat/lng coordinates) | Optional JWT |
| **Addresses** | `PUT` | `/api/v1/addresses/:id` | Update existing delivery address | Optional JWT |
| **Addresses** | `DELETE` | `/api/v1/addresses/:id` | Delete delivery address | Optional JWT |
| **Cart** | `GET` | `/api/v1/cart` | Get current user's active cart items and subtotal | Optional JWT |
| **Cart** | `POST` | `/api/v1/cart/items` | Add or update item quantity in cart | Optional JWT |
| **Cart** | `DELETE` | `/api/v1/cart/items/:id` | Remove specific item from cart | Optional JWT |
| **Products** | `GET` | `/api/v1/products/home-feed` | Fetch home page flash deals, categories & banner items | Public |
| **Products** | `GET` | `/api/v1/products/search?query=` | Debounced full-text catalog search | Public |
| **Orders** | `POST` | `/api/v1/orders/calculate` | Calculate pricing, delivery fees, taxes, discounts | Optional JWT |
| **Orders** | `POST` | `/api/v1/orders` | Create new 10-minute grocery order with inventory lock | Optional JWT |
| **Orders** | `GET` | `/api/v1/orders` | Fetch user order history | Optional JWT |
| **Orders** | `GET` | `/api/v1/orders/:id` | Get single order details with itemized invoice | Optional JWT |
| **Orders** | `GET` | `/api/v1/orders/:id/tracking` | Fetch live GPS tracking status, ETA & rider position | Optional JWT |
| **Orders** | `POST` | `/api/v1/orders/:id/assign-rider` | Assign delivery rider and broadcast WebSocket update | Admin / Manager |
| **Orders** | `POST` | `/api/v1/orders/:id/start-delivery` | Mark order `OUT_FOR_DELIVERY` and initiate GPS stream | Rider / Admin |
| **Orders** | `POST` | `/api/v1/orders/:id/complete-delivery` | Doorstep OTP verification & complete delivery | Rider / Admin |
| **Payments** | `POST` | `/api/v1/payments/initiate` | Create Razorpay payment order intent | Optional JWT |
| **Payments** | `POST` | `/api/v1/payments/verify` | Verify Razorpay HMAC SHA-256 signature | Optional JWT |
| **Delivery** | `GET` | `/api/v1/delivery/track/:id` | Fetch real-time GPS telemetry & ETA | Customer |
| **Analytics** | `GET` | `/api/v1/analytics/:storeId` | Dark Store revenue, packing time & dispatch KPIs | Admin / Store Manager |

---

## AI Engine Architecture

Daily Basket integrates a multi-provider LLM engine capable of processing natural language customer support, recipe recommendations, voice search, and package image freshness analysis.

```mermaid
graph LR
    Client["Client Request\n(Text / Voice / Image)"] --> Security["AiSecurityService\n(Prompt Sanitization & Guardrails)"]
    Security --> ProviderMgr["ProviderManager\n(Health & Routing Engine)"]

    ProviderMgr -->|Primary| Gemini["Google Gemini 1.5 Flash"]
    ProviderMgr -->|Fallback 1| Grok["xAI Grok Provider"]
    ProviderMgr -->|Fallback 2| OpenRouter["OpenRouter API"]
    ProviderMgr -->|Fallback 3| Local["Local Ollama Provider"]

    Gemini -->|Failure / Timeout| FallbackMgr["FallbackManager"]
    FallbackMgr --> Grok

    ProviderMgr --> ToolReg["AiToolsRegistry\n(Function Calling)"]
    ToolReg --> Execute["Execute Store Actions\n(Check Stock / Track Order / Apply Coupon)"]
```

See [`docs/AI.md`](docs/AI.md) for full provider failover and tool registration details.

---

## Security & Compliance

- **Authentication & JWT Rotation**: Short-lived JWT access tokens paired with secure HTTP-only refresh tokens.
- **Firebase Cryptographic Verification**: Server-side token validation against Google public keys for Firebase users.
- **Role-Based Access Control (RBAC)**: Enforced across controllers using `@Roles()` decorator and `RolesGuard`.
- **Payment Security**: Strict HMAC SHA-256 signature validation on Razorpay payments and webhooks.
- **Throttling & Helmet**: NestJS Throttler protects endpoints from brute force and DDoS attacks.
- **Database Safety**: Prisma ORM enforces parameterized SQL queries, eliminating SQL injection vulnerabilities.
- **Detailed Security Specs**: See [`docs/SECURITY_ARCHITECTURE.md`](docs/SECURITY_ARCHITECTURE.md) and [`docs/AUTHENTICATION.md`](docs/AUTHENTICATION.md).

---

## Testing & Quality Assurance

- **Flutter Static Analysis**: `flutter analyze` — **0 Errors, 0 Warnings** across customer and admin mobile apps.
- **Flutter Unit & Widget Tests**: `flutter test` — Comprehensive test suites covering providers, services, and core UI widgets.
- **NestJS Unit Tests**: `pnpm --filter api test` — Jest test suites covering authentication, product catalog, cart calculation, address management, and AI fallback managers.
- **Type Checking & Linting**: `pnpm --recursive run lint` & `tsc --noEmit` across all apps and shared packages.
- **Comprehensive Guide**: See [`docs/TESTING.md`](docs/TESTING.md).

---

## DevOps & CI/CD Pipeline

The GitHub Actions automated pipeline validates all pull requests and deployment commits:

```yaml
Pipeline Workflow:
  1. Lint & Typecheck:
     - Next.js apps (website, admin, delivery): ESLint + tsc --noEmit
     - NestJS API service: ESLint + tsc
     - Shared packages: tsc --noEmit
  2. Automated Test Execution:
     - Flutter Customer & Admin Apps: flutter analyze + flutter test
     - NestJS API Service: pnpm test (Jest)
  3. Container Build & Push:
     - Multi-stage Docker build for NGINX, API, Website, Admin, and Delivery apps
```

See [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) and [`docs/DEVOPS.md`](docs/DEVOPS.md) for deployment runbooks.

---

## Enterprise Documentation Hub

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
| **Admin Dashboard** | [`docs/ADMIN_APP.md`](docs/ADMIN_APP.md) | Dark Store Admin Dashboard fulfillment queue & fleet map |
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

## Roadmap

- [x] **v1.0.0 (Core Foundation)**
  - Flutter Mobile App (35+ screens, Material 3, Clean Architecture)
  - Next.js Customer Web Portal (31 pages, TailwindCSS, Dark mode)
  - Next.js Admin Dashboard (Real-time dispatch queue, KPIs)
  - Next.js Delivery Partner PWA (GPS tracking, Doorstep OTP)
  - NestJS Backend Gateway & Prisma PostgreSQL ORM
  - Redis 7 Caching, BullMQ queues, Socket.IO WebSockets
  - Multi-Provider AI Fallback Engine (Gemini, Grok, OpenRouter, Local)
  - Razorpay Payment Gateway integration with HMAC SHA-256 verification
- [x] **v1.1.0 (Auth & Ecosystem Parity)**
  - Firebase Admin SDK Integration (`daily-basket-8b266`)
  - Google OAuth 2.0 & Firebase SSO Token Verification
  - Web & Mobile Google Single Sign-On / Registration Parity
  - Comprehensive Documentation Refresh with Badges & Enterprise Diagrams
- [x] **v1.2.0 (End-to-End Persistence & Live Telemetry)**
  - End-to-end database persistence for orders, cart sync, and order history
  - Full Address CRUD management with coordinates and defaults (Flutter & Next.js Web)
  - 1-Click Reorder workflow directly adding items back to cart
  - Admin live dispatching modal with rider assignment and fleet live map tracking
  - Flutter Store Admin companion application (`apps/daily_basket_admin`)
  - High refresh-rate 60–120 FPS authentication workflow
- [ ] **v2.0.0 (Planned)**
  - Automated multi-dark store clustering and intelligent cross-store routing
  - Predictive AI inventory demand forecasting and kirana restocking alerts
  - Drone delivery integration and hyper-local geofenced auto-dispatch

---

## License & Author

Distributed under the **MIT License** — see [`LICENSE`](LICENSE) for details.

Built with ❤️ by **Sachin** | [@Sachinxcode-01](https://github.com/Sachinxcode-01)

![Made in India](https://img.shields.io/badge/Made%20in-India%20🇮🇳-FF9933?style=flat)
![Built for Quick Commerce](https://img.shields.io/badge/Built%20for-Gadag%20%26%20Beyond-006b23?style=flat)
