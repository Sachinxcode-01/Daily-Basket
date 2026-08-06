# ⚙️ NestJS Backend Architecture & Service Layer (`services/api`)

The **Daily Basket API Gateway & Microservices Backend** is built with NestJS 10, Node.js 20, and TypeScript 5. It uses Clean Architecture to decouple controllers, application services, domain models, and infrastructure providers.

---

## 1. Directory Topology

```
services/api/src/
├── app.module.ts                   # Root NestJS module & provider registration
├── main.ts                         # App bootstrap, Swagger UI setup, global pipes/filters
├── common/                         # Global cross-cutting concerns
│   ├── decorators/                 # Custom decorators (`@CurrentUser()`, `@Roles()`)
│   ├── dto/                        # Global pagination & wrapper DTOs
│   ├── filters/                    # Global exception filter (`http-exception.filter.ts`)
│   ├── guards/                     # Global RBAC guards (`roles.guard.ts`)
│   ├── interceptors/               # Logging & transform interceptors
│   └── middleware/                 # Request context tracing middleware
├── config/                         # Environment validation & Joi configuration
├── database/                       # Prisma database service wrapper (`prisma.service.ts`)
├── modules/                        # Isolated domain feature modules
│   ├── ai/                         # Multi-provider LLM manager & AI security sandbox
│   ├── analytics/                  # Dark store revenue & KPI reporting
│   ├── auth/                       # Phone OTP, JWT rotation, TOTP MFA, Password policy
│   ├── categories/                 # Category taxonomy management
│   ├── coupons/                    # Discount coupon calculation & validation
│   ├── delivery/                   # GPS telemetry tracking & driver assignment
│   ├── delivery-partner/           # Delivery partner dashboard & duty state
│   ├── email/                      # Email sending templates & Nodemailer wrapper
│   ├── events/                     # Socket.IO WebSocket gateway (`events.gateway.ts`)
│   ├── favorites/                  # Customer saved items & wishlist
│   ├── finance/                    # Store finance ledger & payouts
│   ├── health/                     # Terminus health probes (`/health`, `/health/readiness`)
│   ├── impact/                     # Customer sustainability impact score
│   ├── inventory/                  # Dark store stock allocation & low-stock alerts
│   ├── loyalty/                    # VIP membership & rewards calculation
│   ├── marketing/                  # Promo campaign manager
│   ├── notifications/              # In-app push feed & notification dispatch
│   ├── orders/                     # Order creation, status pipeline, cart calculations
│   ├── payments/                   # Razorpay payment intents & HMAC webhook verifier
│   ├── products/                   # Catalog search, brand aliases, product variants
│   ├── queue/                      # BullMQ queue processors (`queue.processor.ts`)
│   ├── quick-buy/                  # Quick checkout shortcut service
│   ├── redis/                      # Redis 7 wrapper service (`redis.service.ts`)
│   ├── referrals/                  # User referral rewards & code generator
│   ├── reviews/                    # Product rating & customer reviews
│   ├── search/                     # Full-text search engine
│   ├── stock-alerts/               # Back-in-stock alert notifications
│   ├── support/                    # Customer support tickets & live chat gateway
│   ├── uploads/                    # File uploads & S3/local asset manager
│   └── users/                      # User profile & address management
└── prisma/                         # Prisma schema (`schema.prisma`) & migrations
```

---

## 2. Core Request Lifecycle

1. **Ingress**: Request hits NGINX reverse proxy → forwarded to NestJS Express server (`:4000`).
2. **Middleware**: `RequestContextMiddleware` attaches correlation ID to request header.
3. **Guards**: `JwtAuthGuard` validates Bearer token → `RolesGuard` checks `@Roles()` permissions against user role.
4. **Interceptors**: `LoggingInterceptor` records request duration; `ValidationPipe` validates DTO payloads against `class-validator` rules.
5. **Service Execution**: Controller invokes Domain Service → executes business logic → communicates with Prisma ORM / Redis / BullMQ.
6. **Response Transformation**: `TransformInterceptor` wraps response payload in standard JSON format:
   ```json
   {
     "statusCode": 200,
     "success": true,
     "data": { ... },
     "timestamp": "2026-08-06T10:16:20.000Z"
   }
   ```
