# Monorepo & System Architecture — Daily Basket

```mermaid
graph TD
    subgraph Frontend Applications
        Mobile[Flutter Customer App]
        Web[Next.js Customer Web]
        Admin[Next.js Dark Store Admin]
        Delivery[Next.js Delivery Partner PWA]
    end

    subgraph API Gateway & Microservices
        NGINX[NGINX Reverse Proxy]
        Nest[NestJS API Gateway]
    end

    subgraph Data & Infra
        PG[(PostgreSQL 16)]
        Redis[(Redis 7 Cache)]
        Razorpay[Razorpay Gateway]
    end

    Mobile --> NGINX
    Web --> NGINX
    Admin --> NGINX
    Delivery --> NGINX

    NGINX --> Nest
    Nest --> PG
    Nest --> Redis
    Nest --> Razorpay
```

---

## Clean Architecture Layers (NestJS Backend)

1. **Domain Layer**: Core business models & entities (`prisma/schema.prisma`).
2. **Application Layer**: Business logic services (`orders.service.ts`, `payments.service.ts`, `delivery.service.ts`).
3. **Infrastructure Layer**: Database connectors (`prisma.service.ts`), Redis cache (`redis.service.ts`), third-party SDKs (Razorpay, S3 uploads).
4. **Presentation Layer**: REST API controllers with OpenAPI annotations (`orders.controller.ts`, `payments.controller.ts`).
