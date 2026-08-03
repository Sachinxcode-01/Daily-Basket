# System Architecture Specification - Daily Basket

## 1. High-Level Architecture
The system employs a **Monorepo Modular Monolith Architecture** for the API service, coupled with client applications for Web, Admin, and Mobile.

```text
                               ┌─────────────────────────┐
                               │   Client Applications   │
                               │ Next.js Web / Admin    │
                               │ Flutter Mobile / Driver │
                               └───────────┬─────────────┘
                                           │ HTTPS / WSS
                                           ▼
                               ┌─────────────────────────┐
                               │   NGINX Reverse Proxy   │
                               └───────────┬─────────────┘
                                           │
                                           ▼
                               ┌─────────────────────────┐
                               │   NestJS API Service    │
                               │   (Modular Monolith)    │
                               └───────┬─────────┬───────┘
                                       │         │
                        Prisma / SQL   │         │ Cache / PubSub
                                       ▼         ▼
                                 ┌───────────┐ ┌───────────┐
                                 │PostgreSQL │ │   Redis   │
                                 └───────────┘ └───────────┘
```

## 2. Low-Level Module Architecture
Each NestJS module strictly implements Clean Architecture layers:
- **Controller Layer**: Handles HTTP requests, DTO validation, and route definitions.
- **Service Layer**: Implements business domain rules and transactions.
- **Repository Layer**: Encapsulates DB access via Prisma ORM.
- **Entity / DTO Layer**: Defines domain types and request/response contracts.
