# Monorepo & System Architecture — Daily Basket

> **Authoritative Specification**: Please refer to the primary architecture document at [`docs/ARCHITECTURE.md`](../ARCHITECTURE.md) and system design document at [`docs/SYSTEM_DESIGN.md`](../SYSTEM_DESIGN.md).

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
        BullMQ[(BullMQ Queues)]
    end

    Mobile --> NGINX
    Web --> NGINX
    Admin --> NGINX
    Delivery --> NGINX

    NGINX --> Nest
    Nest --> PG
    Nest --> Redis
    Nest --> BullMQ
```
