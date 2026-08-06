# 📋 Product Requirements Document (PRD) — Daily Basket

**Version**: `1.0.0`  
**Status**: Implemented & Production Certified  
**Design Source of Truth**: **Google Stitch Project**

---

## 1. Product Vision & Value Proposition

**Daily Basket** is a hyper-local 10-minute grocery delivery platform designed to bring farm-fresh produce, dairy, staples, and daily essentials to customers' doorsteps in under 10 minutes. By digitizing dark store operations and automating rider assignment, Daily Basket combines ultra-fast fulfillment with transparent pricing.

---

## 2. Core User Personas

1. **Consumer / Shopper**:
   - Needs lightning-fast 10-minute delivery with accurate live tracking.
   - Values fresh produce, instant coupons, digital wallet payments, and voice/image search capabilities.
2. **Dark Store Operations Manager**:
   - Oversees real-time fulfillment queue (`NEW` → `CONFIRMED` → `PACKING` → `DISPATCHED`).
   - Manages stock levels, receives low-stock warnings, and updates product catalog entries.
3. **Delivery Partner / Rider**:
   - Needs seamless turn-by-turn map navigation to customer doorsteps.
   - Relies on doorstep 4-digit OTP PIN verification to complete orders securely.

---

## 3. Scope & Implementation Feature Matrix

- **Auth & Onboarding**: Phone OTP verification, Google OAuth, Email/Password, TOTP MFA, Account Lockout rules.
- **Store Catalog**: Category grid, flash sales banner, debounced search, brand alias matching, produce freshness inspector.
- **Cart & Checkout**: Free delivery threshold meter, coupon validation (`DAILY100`), Razorpay UPI/Card/COD payments.
- **Live GPS Tracking**: Real-time Socket.IO WebSocket order timeline, driver contact card, simulated route map.
- **Fulfillment & Dispatch**: Dark Store order dispatch stream, low-stock threshold triggers, rider assignment.
