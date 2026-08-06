# 🏢 Daily Basket — Dark Store Admin Dashboard (`apps/admin`)

The **Daily Basket Admin Dashboard** is a high-performance web portal built for Dark Store managers, inventory controllers, and operations leads. It provides real-time fulfillment management, inventory control, and revenue analytics.

---

## 🏗️ Modules & Page Structure

```
apps/admin/app/
├── page.tsx                        # Dashboard Overview (Today's Revenue, Active Orders, KPIs)
├── orders/                         # Real-Time Fulfillment Queue (`NEW` → `CONFIRMED` → `PACKING` → `DISPATCHED`)
├── inventory/                      # Stock Manager (Stock Quantity, Low-stock alerts, SKU Search)
├── products/
│   └── editor/                     # Product Catalog Editor (Price, MRP, Category, Tags, Images)
├── customers/                      # Customer Insights & Order History
├── riders/                         # Delivery Partner Fleet Status & Duty Monitor
├── marketing/                      # Coupon Management & Banner Campaigns
├── ai-analytics/                   # Predictive AI Analytics & Sales Forecasting
├── settings/                       # Dark Store Hub Operational Settings
├── globals.css                     # Admin Design System CSS
└── layout.tsx                      # Root Admin Layout & Navigation Sidebar
```

---

## ⚡ Key Operational Features

1. **Fulfillment Stream**: Real-time order cards updated via Socket.IO WebSocket events. Dark store packers update order status with one-tap buttons (`ACCEPT` → `PACK` → `DISPATCH`).
2. **Inventory Stock Management**: Quick adjust stock quantity, receive low-stock alerts, and manage product availability per hub.
3. **Driver Allocation**: Assign available online riders to packed orders for immediate 10-minute doorstep dispatch.

---

## ⚡ Running Locally

```bash
# From workspace root
pnpm --filter admin dev
```
Open `http://localhost:3001` in your browser.
