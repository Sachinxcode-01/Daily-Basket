# 🏗️ End-to-End System Architecture — Daily Basket

This document provides a detailed overview of the system topology, monorepo structure, microservices breakdown, and infrastructure layout of the **Daily Basket** enterprise 10-minute grocery delivery platform.

---

## 1. High-Level Architectural Overview

Daily Basket is designed as a distributed, event-driven, microservices-ready monorepo. It connects client applications across mobile, web, store admin, and delivery partners through an NGINX ingress gateway to a central NestJS microservices backend powered by PostgreSQL 16, Redis 7, BullMQ, and Socket.IO.

```mermaid
graph TD
    subgraph Client Layer
        FlutterApp["📱 Flutter Customer Mobile App\n(Android / iOS)"]
        CustomerWeb["🌐 Next.js Customer Web Portal\n(Tailwind + React Query)"]
        AdminPortal["🏢 Next.js Dark Store Admin\n(Fulfillment Dispatch Queue)"]
        RiderPWA["🛵 Delivery Partner PWA\n(GPS Telemetry & OTP)"]
    end

    subgraph Gateway & Proxy Layer
        NginxProxy["🛡️ NGINX Reverse Proxy\n(SSL Termination, Compression, Rate-Limit)"]
        NestGateway["⚙️ NestJS API Gateway\n(Global Auth, Guards, Throttler, Pipes)"]
    end

    subgraph Service Layer (NestJS API)
        AuthService["🔐 Auth & Security Service"]
        CatalogService["📦 Products & Categories Service"]
        OrderService["🛒 Orders & Quick-Buy Service"]
        PaymentService["💳 Payments & Wallet Service"]
        DeliveryService["📍 Delivery & Telemetry Service"]
        AiEngineService["🤖 Multi-Provider AI Engine"]
        NotificationService["🔔 Notification & Email Service"]
    end

    subgraph Data & Async Layer
        PostgreSQL[("🐘 PostgreSQL 16\n(Prisma ORM)")]
        RedisCache[("⚡ Redis 7\n(Session Store & Pub/Sub)")]
        BullMQ["📩 BullMQ Job Queue\n(Notification Processors)"]
        WebSocketServer["⚡ Socket.IO Gateway\n(Live Tracking & Chat)"]
    end

    FlutterApp -->|HTTPS / WSS| NginxProxy
    CustomerWeb -->|HTTPS / WSS| NginxProxy
    AdminPortal -->|HTTPS / WSS| NginxProxy
    RiderPWA -->|HTTPS / WSS| NginxProxy

    NginxProxy --> NestGateway

    NestGateway --> AuthService
    NestGateway --> CatalogService
    NestGateway --> OrderService
    NestGateway --> PaymentService
    NestGateway --> DeliveryService
    NestGateway --> AiEngineService
    NestGateway --> NotificationService

    AuthService --> PostgreSQL
    CatalogService --> PostgreSQL
    OrderService --> PostgreSQL
    PaymentService --> PostgreSQL
    DeliveryService --> PostgreSQL

    NestGateway --> RedisCache
    NestGateway --> BullMQ
    NestGateway --> WebSocketServer
```

---

## 2. Microservice Layer Breakdown

Each module in `services/api/src/modules` operates as an isolated domain service:

1. **Auth & Security Module (`modules/auth`)**: Handles phone OTP generation, JWT token pair issuance, Google OAuth token verification, TOTP MFA secret generation, password hash verification, and security audit log tracking.
2. **Catalog & Products Module (`modules/products`, `modules/categories`, `modules/search`)**: Manages store product catalogs, sub-category trees, debounced search index matching, brand aliases, and product variants.
3. **Orders & Inventory Module (`modules/orders`, `modules/inventory`, `modules/quick-buy`)**: Handles cart calculations, stock reservations per dark store hub, checkout creation, and order state transitions (`CREATED` → `CONFIRMED` → `PACKING` → `READY_FOR_PICKUP` → `OUT_FOR_DELIVERY` → `DELIVERED`).
4. **Payments & Wallet Module (`modules/payments`, `modules/loyalty`, `modules/referrals`)**: Initiates Razorpay payment orders, processes Razorpay webhook payloads with HMAC SHA-256 validation, and manages user wallet balances.
5. **Delivery Telemetry Module (`modules/delivery`, `modules/delivery-partner`)**: Tracks rider online status, assigns riders to packed orders, broadcasts continuous GPS location updates via Socket.IO, and verifies doorstep OTP.
6. **Multi-Provider AI Engine (`modules/ai`)**: Implements an LLM manager that routes queries to Google Gemini 1.5 Flash, xAI Grok, OpenRouter, or local models, equipped with fallback detection and tool execution.

---

## 3. Communication Patterns

- **Synchronous HTTP/REST**: Used for authentication, product browsing, cart updates, order creation, and account settings.
- **Asynchronous WebSockets (Socket.IO)**: Used for real-time order status timeline broadcasts, live rider GPS telemetry, and live support chat.
- **Asynchronous Message Queues (BullMQ + Redis)**: Used for offloading background tasks including order confirmation emails, push notifications, and webhook processing.
