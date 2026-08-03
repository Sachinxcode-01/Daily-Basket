# Technical Requirements Document (TRD) — Daily Basket

**Platform Architecture**: Monorepo with Domain-Driven Microservices & Cross-Platform Frontend  
**Version**: `1.0.0`  
**Status**: Implemented & Certified Production-Ready

---

## 1. System Quality Attributes & Targets

- **Cart Calculation Latency**: <5ms client-side calculation.
- **API Response Latency**: <30ms average execution time.
- **Delivery Fulfillment Goal**: Order packing completed in <3.0 minutes; doorstep delivery in <10.0 minutes.
- **Code Quality**: Zero compilation errors or static analysis warnings (`flutter analyze` clean, `npx nest build` clean).

---

## 2. Technical Stack Specifications

- **Mobile**: Flutter 3.41, Material Design 3, Dart 3.11, `provider`, `http`.
- **Frontend Web**: Next.js 14 App Router, React 18, TailwindCSS, TanStack Query.
- **Backend API**: NestJS 10, TypeScript 5, `@nestjs/swagger`, `@nestjs/throttler`.
- **Database & Persistence**: PostgreSQL 16 + Prisma ORM 5.
- **Cache & Telemetry**: Redis 7.2.
- **DevOps**: Docker Multi-stage, NGINX, GitHub Actions.
