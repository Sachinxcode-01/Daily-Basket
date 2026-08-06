# ⚡ Performance Benchmarks & SLAs — Daily Basket

This document defines performance SLAs, latency benchmarks, database query optimization rules, and load testing guidelines.

---

## 1. Latency Targets & SLAs

- **Cart Subtotal Calculation**: `< 5ms` client-side calculation.
- **REST API Latency (p95)**: `< 30ms` average response latency.
- **WebSocket Order Stream**: `< 100ms` latency for order status state updates.
- **Dark Store Packing SLA**: `< 3.0 minutes` average packing time.
- **Doorstep Delivery SLA**: `< 10.0 minutes` total delivery duration.
