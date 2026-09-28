# 🛵 Daily Basket — Delivery Partner PWA (`apps/delivery`)

![Next.js 14](https://img.shields.io/badge/Next.js-14.2-black?style=for-the-badge&logo=nextdotjs&logoColor=white)
![PWA Ready](https://img.shields.io/badge/PWA-Offline%20First-5A0FC8?style=for-the-badge&logo=pwa&logoColor=white)
![GPS Telemetry](https://img.shields.io/badge/GPS-Realtime%20Tracking-22c55e?style=for-the-badge&logo=googlemaps&logoColor=white)
![Doorstep OTP](https://img.shields.io/badge/Delivery-OTP%20Verified-006823?style=for-the-badge)

---

## 📌 Overview

The **Daily Basket Delivery Partner App** is a Progressive Web Application (PWA) optimized for delivery fleet riders. It features offline-first capability, real-time GPS telemetry broadcasting, turn-by-turn navigation triggers, and doorstep customer OTP verification.

---

## 🏗️ Architecture & Features

```
apps/delivery/app/
├── page.tsx                        # Delivery Partner Hub (Duty Switch, Active Order, Navigation)
├── globals.css                     # Mobile-first PWA CSS Styles
└── layout.tsx                      # Root PWA Layout with Manifest & Service Worker
```

### Key Rider Workflows:

1. **⚡ Duty Controller**: One-tap toggle to switch between `ONLINE` and `OFFLINE` duty status, broadcasting live telemetry via Socket.IO.
2. **📦 Order Pickup & Packing Manifest**: Displays dark store pickup location, customer delivery address, contact button, and item list.
3. **🗺️ Turn-by-Turn Route Trigger**: Single tap launches native Google Maps route navigation to customer doorstep.
4. **🔐 Doorstep OTP Verification**: Rider inputs customer 4-digit OTP to verify delivery before transitioning the order to `DELIVERED`.
5. **💰 Earnings Ledger**: Live view of daily base earnings, surge bonuses, delivery tips, and completed order count.

---

## ⚡ Running Locally

```bash
# From workspace root
pnpm --filter delivery dev
```

Open `http://localhost:3002` in your browser.
