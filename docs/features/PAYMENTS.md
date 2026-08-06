# 💳 Payments & Wallet Integration — Daily Basket (`docs/features/PAYMENTS.md`)

This document describes the Razorpay payment gateway integration, HMAC SHA-256 signature verification, and Daily Basket Wallet ledger.

---

## 1. Razorpay Payment Flow

```mermaid
sequenceDiagram
    autonumber
    actor Customer
    participant App as Mobile / Web Client
    participant API as NestJS API Gateway
    participant RZP as Razorpay Gateway

    Customer->>App: Select Payment Method & Click "Pay Now"
    App->>API: POST /api/v1/payments/initiate
    API->>RZP: Create Razorpay Order Intent (`rzp_order_*`)
    RZP-->>API: Return Order ID & Amount
    API-->>App: Return Payment Options
    App->>Customer: Render Razorpay SDK Checkout Modal
    Customer->>RZP: Complete UPI / Card / NetBanking Payment
    RZP-->>App: Return `razorpay_payment_id` & `razorpay_signature`
    App->>API: POST /api/v1/payments/verify
    API->>API: Verify HMAC SHA-256 Signature
    API-->>App: Payment Verified Success (`paymentStatus: SUCCESS`)
```

---

## 2. Digital Wallet Ledger

- **Daily Basket Wallet**: Users can store funds, apply instant refunds, and complete one-tap checkout.
- **Transactions**: Every credit and debit operation is logged with a transaction reference ID and timestamp.
