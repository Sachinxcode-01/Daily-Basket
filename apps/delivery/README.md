# 🛵 Daily Basket — Delivery Partner PWA (`apps/delivery`)

The **Daily Basket Delivery Partner App** is a Progressive Web Application (PWA) designed for delivery riders. It features offline-first capability, real-time GPS telemetry broadcasting, turn-by-turn navigation triggers, and doorstep customer OTP verification.

---

## 🏗️ Architecture & Features

```
apps/delivery/app/
├── page.tsx                        # Delivery Partner Hub (Duty Switch, Active Order, Navigation)
├── globals.css                     # Mobile-first PWA CSS Styles
└── layout.tsx                      # Root PWA Layout with Manifest & Service Worker
```

### Key Rider Workflows:
1. **Duty Controller**: One-tap toggle to switch between `ONLINE` and `OFFLINE` duty status, initiating background location telemetry.
2. **Order Pickup & Packing Manifest**: Displays dark store pickup location, customer delivery address, contact button, and item list.
3. **Turn-by-Turn Route Trigger**: Single tap launches native Google Maps route navigation to customer doorstep.
4. **Doorstep OTP Verification**: Rider inputs customer 4-digit OTP (`4821`) to verify delivery before marking order `DELIVERED`.
5. **Earnings Ledger**: Live view of daily base earnings, surge bonuses, delivery tips, and completed order count.

---

## ⚡ Running Locally

```bash
# From workspace root
pnpm --filter delivery dev
```
Open `http://localhost:3002` in your browser.
