# 📐 Technical Requirements Document (TRD) — Daily Basket

**Version**: `1.0.0`  
**Status**: Certified Production-Ready

---

## 1. System Quality Attributes & SLAs

| Attribute | Target SLA | Verification Method |
| :--- | :--- | :--- |
| **API Response Latency (p95)** | `< 30ms` average | NestJS Throttler + Winston benchmarks |
| **Cart Calculation Latency** | `< 5ms` client-side | Benchmark suite in `@daily-basket/shared-utils` |
| **Store Dispatch SLA** | `< 3.0 minutes` packing | Dark Store Admin Queue telemetry |
| **Doorstep Delivery Goal** | `< 10.0 minutes` total | Driver GPS telemetry & doorstep OTP timestamp |
| **Flutter Static Analysis** | `0 Errors, 0 Warnings` | `flutter analyze` |
| **TypeScript Strictness** | Zero `any` in production code | `tsc --noEmit` strict mode |

---

## 2. Technical Stack Specifications

- **Mobile Application**: Flutter 3.19, Dart 3.3, Provider pattern, Material Design 3.
- **Web Applications**: Next.js 14 App Router, React 18, TailwindCSS, TanStack Query, Zustand.
- **Backend Services**: NestJS 10, TypeScript 5.3, `@nestjs/swagger`, `@nestjs/throttler`.
- **Database & ORM**: PostgreSQL 16 + Prisma ORM 5.
- **Caching & Queues**: Redis 7.2 + BullMQ 5.
- **Real-time Gateway**: Socket.IO 4 WebSockets.
- **DevOps**: Multi-stage Docker, NGINX Alpine, Kubernetes deployment manifests.
