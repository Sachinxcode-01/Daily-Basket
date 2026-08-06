# 🏢 Dark Store Admin Dashboard Specification (`apps/admin`)

The **Dark Store Admin Dashboard** (`apps/admin`) is built with Next.js 14 App Router, Zustand, and Framer Motion to provide store managers with real-time fulfillment queue controls and inventory management.

---

## 1. Key Modules

1. **Dashboard Overview (`/`)**: Today's revenue, active order count, average dispatch time, satisfaction score.
2. **Real-time Dispatch Queue (`/orders`)**: Real-time WebSocket order stream (`NEW` → `CONFIRMED` → `PACKING` → `READY_FOR_PICKUP` → `DISPATCHED`).
3. **Inventory Management (`/inventory`)**: Stock level editor, reserved quantity viewer, low-stock threshold warnings.
4. **Product Catalog Editor (`/products/editor`)**: Price, MRP, unit name, brand, category, and image URL editor.
5. **Riders & Fleet Monitor (`/riders`)**: Real-time online/offline duty state monitor for delivery partners.
