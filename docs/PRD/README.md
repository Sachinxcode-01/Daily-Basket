# Product Requirements Document (PRD) — Daily Basket

**Platform**: 10-Minute Ultra-Fast Quick-Commerce Startup  
**Version**: `1.0.0`  
**Status**: Approved & Implemented  
**UI/UX Source of Truth**: **Google Stitch Project**

---

## 1. Product Vision & Goals

**Daily Basket** delivers farm-fresh groceries, vegetables, dairy, and household essentials directly to customers' doorsteps in under 10 minutes. By integrating hyper-local Kirana dark stores with real-time inventory tracking and automated rider dispatch, Daily Basket combines speed, reliability, and local store empowerment.

---

## 2. Core User Personas

1. **Customer**: Wants lightning-fast 10-minute grocery delivery with transparent pricing, instant coupons, and live GPS delivery tracking.
2. **Dark Store Manager**: Manages store inventory stock, accepts incoming order alerts, packs items, and dispatches riders.
3. **Delivery Partner**: Receives automated order assignment notifications, uses turn-by-turn navigation, verifies delivery via customer OTP PIN (`4821`), and tracks daily wallet earnings.

---

## 3. Implemented Product Features & User Flows

- **Authentication & Onboarding**: Phone number login with 6-digit OTP verification PIN.
- **Home & Product Catalog**: 10-minute ETA header badge, search bar with debounced query matching, flash deals grid, and category taxonomy.
- **Cart & Checkout**: Real-time quantity controls (`+` / `-`), free delivery threshold progress bar, coupon application (`DAILY100`), and Razorpay payment gateway (UPI, Cards, COD).
- **Live GPS Tracking**: Real-time order step status timeline (`Order Confirmed` -> `Packing` -> `Out for Delivery` -> `Delivered`), live ETA countdown timer, driver contact card (`Ramesh Kumar`), and simulated GPS map route.
- **Store Admin & Inventory**: Dark Store fulfillment queue (`CONFIRMED` -> `PACKING` -> `READY_FOR_PICKUP` -> `OUT_FOR_DELIVERY`), SKU stock adjustment manager, low-stock warnings, and sales analytics KPIs.
- **Delivery Partner App**: Rider duty switch (`ONLINE` / `OFFLINE`), active delivery dropoff details, customer phone call / maps navigation triggers, and rider wallet earnings ledger (`₹850` earned today).
