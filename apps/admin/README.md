# 🏢 Daily Basket — Dark Store Admin Dashboard (`apps/admin`)

![Next.js 14](https://img.shields.io/badge/Next.js-14.2-black?style=for-the-badge&logo=nextdotjs&logoColor=white)
![React 18](https://img.shields.io/badge/React-18.2-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![TailwindCSS](https://img.shields.io/badge/Tailwind-3.4-38B2AC?style=for-the-badge&logo=tailwindcss&logoColor=white)
![Real-time](https://img.shields.io/badge/WebSockets-Socket.IO-010101?style=for-the-badge&logo=socketdotio&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FCM%20Verified-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

---

## 📌 Overview

The **Daily Basket Admin Dashboard** is a high-performance operations portal built for Dark Store managers, fulfillment pickers, and operations leads. It provides real-time fulfillment management, inventory control, rider fleet dispatch, and business KPIs.

---

## 🏗️ Modules & Page Structure

```
apps/admin/app/
├── page.tsx                        # Dashboard Overview (Revenue, Active Orders, KPIs)
├── checklist/                      # Go-Live Production Readiness & Firebase Health
├── orders/                         # Real-Time Fulfillment Queue (CONFIRMED → PACKING → DISPATCHED)
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

1. **📦 Fulfillment Stream**: Real-time order cards updated via Socket.IO WebSocket events. Dark store packers update order status with one-tap buttons (`ACCEPT` → `PACK` → `DISPATCH`).
2. **📊 Inventory Stock Management**: Instant adjustments to stock quantity, low-stock threshold triggers, and multi-hub availability toggles.
3. **🛵 Driver Allocation & Fleet Tracking**: Monitor active riders, assign dispatched orders, and verify doorstep delivery status.
4. **🚀 Go-Live Verification Suite**: Built-in verification checklist confirming database, payment gateways, and Firebase Service Account configuration.

---

## ⚡ Running Locally

```bash
# From workspace root
pnpm --filter admin dev
```

Open `http://localhost:3001` in your browser.
