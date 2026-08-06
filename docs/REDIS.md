# 📦 Redis 7 Caching & Messaging — Daily Basket

Daily Basket uses **Redis 7.2** (`modules/redis`) for session caching, rate-limit state, store inventory tracking, and Pub/Sub event broadcasting.

---

## 1. Key Namespaces & Caching Policies

- `session:<token>`: Stores authenticated user session metadata (7-day TTL).
- `otp:<phone>`: Stores 6-digit verification OTP PINs (5-minute TTL).
- `inventory:store:<storeId>:variant:<variantId>`: Atomic stock counter.
- `pubsub:order-events`: Redis Pub/Sub channel for distributing WebSocket events across API instances.
