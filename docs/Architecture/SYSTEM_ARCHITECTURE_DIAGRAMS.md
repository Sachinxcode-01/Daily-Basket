# Daily Basket — System Architecture & Flow Diagrams

## 1. High-Level System Architecture & Component Diagram

```mermaid
graph TD
    ClientApp["Flutter Mobile App / Next.js Web"] -->|HTTPS / WSS| Ingress["NGINX Ingress Controller / ALB"]
    
    subgraph K8sCluster["Kubernetes Cluster (daily-basket)"]
        Ingress -->|Route /api/v1| APIGateway["Daily Basket NestJS API (HPA 2-20 Replicas)"]
        
        APIGateway -->|ORM Queries| Postgres["PostgreSQL Primary DB"]
        APIGateway -->|Cache / PubSub / Redlock| Redis["Redis Master / Subscriber Cluster"]
        APIGateway -->|Async Queue Jobs| BullMQ["BullMQ Workers (Concurrency=10)"]
        
        BullMQ -->|Async Jobs| Notifications["Push Notifications / Email Service"]
        BullMQ -->|Image Processing| SharpWorker["Sharp WebP Media Worker"]
        
        APIGateway -->|Prometheus Metrics| PromExporter["/metrics Endpoint"]
    end
    
    PromExporter -->|Scrape| Prometheus["Prometheus Server"]
    Prometheus -->|Visualize| Grafana["Grafana Dashboards"]
```

---

## 2. Authentication & JWT Token Rotation Sequence

```mermaid
sequenceDiagram
    autonumber
    actor User as Mobile App User
    participant AuthAPI as NestJS AuthController
    participant DB as PostgreSQL DB
    participant Redis as Redis Cache

    User->>AuthAPI: POST /auth/request-otp { phone }
    AuthAPI->>DB: Check rate-limit cooldown
    AuthAPI->>User: 200 OK { demoOtp: "123456" }
    
    User->>AuthAPI: POST /auth/verify-otp { phone, otp: "123456" }
    AuthAPI->>DB: Verify OTP hash & user status
    AuthAPI->>AuthAPI: Generate Access Token (15m) & Refresh Token (30d)
    AuthAPI->>DB: Save DeviceSession with hashed Refresh Token
    AuthAPI->>User: 200 OK { accessToken, refreshToken, user }

    Note over User, AuthAPI: When Access Token Expires (15 mins)
    User->>AuthAPI: POST /auth/refresh-token { refreshToken }
    AuthAPI->>DB: Validate active DeviceSession
    AuthAPI->>AuthAPI: Rotate Refresh Token & Issue New Access Token
    AuthAPI->>DB: Update DeviceSession with new Refresh Token
    AuthAPI->>User: 200 OK { accessToken, newRefreshToken }
```

---

## 3. 10-Minute Quick-Commerce Order Fulfillment Sequence

```mermaid
sequenceDiagram
    autonumber
    actor Customer as Customer
    participant API as Orders API
    participant InvService as Inventory Service
    participant DB as PostgreSQL DB
    participant Gateway as Socket.IO EventsGateway
    participant DarkStore as Dark Store Picker App
    participant Rider as Delivery Partner App

    Customer->>API: POST /orders { items, storeId, addressId }
    API->>InvService: reserveStockAtomic(storeId, variantId, quantity)
    InvService->>DB: UPDATE inventories SET stockQuantity = stockQuantity - Q WHERE stockQuantity >= Q
    DB-->>InvService: Success (1 row updated)
    
    API->>DB: INSERT INTO orders & order_items
    API->>Gateway: broadcastOrderCreated(order)
    Gateway-->>DarkStore: Emit "order_created" event (<50ms)
    API-->>Customer: 201 Created { orderId, eta: "10 mins" }

    DarkStore->>Gateway: Order Packed
    Gateway-->>Customer: Emit "order_packing" update
    Gateway-->>Rider: Emit "new_order_assigned"
    
    Rider->>Gateway: rider_gps_tick { lat, lng }
    Gateway-->>Customer: Emit "rider_location_update" live map tracking
```

---

## 4. Atomic Inventory Locking & Concurrency Control Sequence

```mermaid
sequenceDiagram
    autonumber
    actor User1 as Customer A (Flash Sale)
    actor User2 as Customer B (Flash Sale)
    participant Redis as Redis Redlock
    participant DB as PostgreSQL DB

    par Simultaneous Requests
        User1->>Redis: acquireLock("inventory:store_1:var_1")
        User2->>Redis: acquireLock("inventory:store_1:var_1")
    end
    
    Redis-->>User1: Lock Acquired (Token A)
    Redis-->>User2: Lock Busy (Null)

    User1->>DB: UPDATE inventories SET stockQuantity = stockQuantity - 1 WHERE stockQuantity >= 1
    DB-->>User1: Success (Row Updated)
    User1->>Redis: releaseLock("inventory:store_1:var_1", Token A)

    User2->>Redis: Retry acquireLock (Token B)
    Redis-->>User2: Lock Acquired
    User2->>DB: UPDATE inventories SET stockQuantity = stockQuantity - 1 WHERE stockQuantity >= 1
    DB-->>User2: Failure (0 rows updated - Stock Depleted)
    User2-->>User2: Return Out of Stock
```
