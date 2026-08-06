# 🛵 Delivery Partner PWA Specification (`apps/delivery`)

The **Delivery Partner App** (`apps/delivery`) is a Next.js 14 Progressive Web Application designed for mobile delivery riders.

---

## 1. Key Workflows & Features

1. **Duty State Toggle**: One-tap toggle to switch between `ONLINE` and `OFFLINE` status. When online, the PWA broadcasts GPS location coordinates to the API backend every 10 seconds.
2. **Order Pickup & Packing Manifest**: Displays dark store pickup location, customer delivery address, phone call trigger, and item manifest.
3. **Turn-by-Turn Route Navigation**: Single tap launches native Google Maps route navigation from current location to dark store or customer doorstep.
4. **Doorstep OTP Verification**: Rider verifies delivery by inputting customer's 4-digit OTP PIN (`4821`).
5. **Earnings Ledger**: Live ledger tracking daily base pay, order counts, surge bonuses, and tip earnings.
