# 📦 Dark Store Inventory Management — Daily Basket (`docs/features/INVENTORY.md`)

This document describes real-time stock allocation, reserved quantities, and low-stock threshold monitoring across dark store hubs.

---

## 1. Inventory Logic & Multi-Store Allocation

- **`Inventory` Model**: Links `Store` and `ProductVariant` via a unique composite index `[storeId, variantId]`.
- **Stock Tracking**: Maintains `stockQuantity` (total physical stock) and `reservedQuantity` (stock reserved for pending orders).
- **Reservation Workflow**: When an order is placed (`POST /orders`), the system atomically increments `reservedQuantity`. Upon order completion or cancellation, stock is updated or released.
