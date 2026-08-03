# Daily Basket - Enterprise Quick-Commerce Platform

**Daily Basket** is an enterprise-grade quick-commerce single-store grocery platform engineered with Clean Architecture, Domain-Driven Design (DDD), and multi-store expansion capabilities.

---

## 🚀 Repository Structure

```text
daily-basket/
├── apps/
│   ├── mobile/         # Flutter Mobile Application (Customer App)
│   ├── website/        # Next.js 14+ Customer Web Application
│   ├── admin/          # Next.js 14+ Admin & Inventory Management Portal
│   └── delivery/       # Flutter / Web Delivery Partner Application
├── services/
│   └── api/            # NestJS Modular Monolith API Service (Prisma + PostgreSQL + Redis)
├── packages/
│   ├── shared-types/   # Shared TypeScript Interfaces & DTOs
│   ├── shared-utils/   # Shared Formatting, Calculation & Validation Utilities
│   ├── api-client/     # Typed HTTP API Client Wrapper
│   ├── design-system/  # Cross-platform Design Tokens & Specifications
│   ├── theme/          # Material Design 3 Palette & Design System Specs
│   ├── constants/      # Shared Enums, Error Codes & App Routes
│   └── shared-ui/      # Shared React UI Components
├── docs/               # Architecture, PRD, TRD, API, Security, & Testing Docs
├── infrastructure/     # Docker, Docker Compose, NGINX, Prometheus, Terraform configs
└── scripts/            # Database Seeding & Development Environment Scripts
```

---

## 🛠️ Tech Stack Overview

- **Customer Website & Admin**: Next.js 14, React 18, TypeScript, Tailwind CSS, Material Design 3, Framer Motion, Zustand.
- **Mobile & Delivery Apps**: Flutter (3.x), Dart, Material Design 3.
- **Backend API Service**: NestJS, TypeScript, Prisma ORM, PostgreSQL, Redis, REST APIs, WebSockets.
- **Infrastructure & Cloud**: Docker, NGINX Reverse Proxy, AWS S3, Firebase Cloud Messaging (FCM), Razorpay Payments, Google Maps Platform.

---

## 🚦 Getting Started

### Prerequisites

- **Node.js**: >= 18.0.0
- **pnpm**: >= 8.0.0
- **Flutter SDK**: >= 3.19.0 (for mobile app development)
- **Docker & Docker Compose** (for database & cache infrastructure)

### Quick Start Commands

```bash
# 1. Install workspace dependencies
pnpm install

# 2. Start PostgreSQL & Redis services via Docker
pnpm docker:up

# 3. Generate Prisma client & run database migrations
pnpm prisma:generate
pnpm prisma:migrate

# 4. Start all applications concurrently in development mode
pnpm dev
```

---

## 📚 Documentation Links

Detailed technical specification and architecture documentation can be found in the [`docs/`](./docs) directory:

- [Product Requirements Document (PRD)](./docs/PRD/README.md)
- [Technical Requirements Document (TRD)](./docs/TRD/README.md)
- [System Architecture Specification](./docs/Architecture/README.md)
- [Database Schema & ERD](./docs/Database/README.md)
- [API & OpenAPI Guidelines](./docs/API/README.md)
- [Security & Compliance Specification](./docs/Security/README.md)
- [Coding Standards & SOLID Principles](./docs/Coding-Standards/README.md)
- [Filesystem & Symbol Naming Conventions](./docs/Naming-Convention/README.md)

---

## 📄 License

Internal Enterprise Codebase - Daily Basket Inc.
