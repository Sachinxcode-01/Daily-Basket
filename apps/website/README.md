# 🌐 Daily Basket — Customer Web Portal (`apps/website`)

The **Daily Basket Customer Website** is a modern, responsive web application built with Next.js 14 (App Router), React 18, TailwindCSS, and TanStack Query. It provides web shoppers with a lightning-fast grocery experience featuring dark-mode aesthetics, Razorpay payment processing, and live delivery tracking.

---

## 🏗️ Architecture & App Directory

```
apps/website/app/
├── (auth)/                         # Authentication routing group
│   ├── login/                      # Login page (Phone OTP / Password)
│   ├── register/                   # Registration page
│   ├── forgot-password/            # Password reset request
│   ├── verify-email/               # Email token verification
│   ├── account-locked/             # Security lockout notice
│   └── enable-biometrics/          # WebAuthn / Biometric setup
├── ai-assistant/                   # Natural language AI grocery chat interface
├── cart/                           # Shopping cart drawer & empty cart page
├── categories/                     # Dynamic category browser & category details `[id]`
├── checkout/                       # Multi-step checkout & Razorpay SDK launcher
├── freshness/                      # Produce freshness explorer & quality badges
├── loyalty/                        # Daily Basket Plus membership benefits page
├── notifications/                  # User notification feed with category grouping
├── order-success/                  # Order confirmation & receipt overview
├── rate-delivery/                  # Post-delivery rating & review form
├── search/                         # Filtered catalog search grid
├── security/                       # Account security settings & active sessions
├── tracking/[id]/                  # Real-time WebSocket delivery map tracker
├── wallet/                         # Digital wallet balance & transaction ledger
├── wishlist/                       # Saved items & quick add to cart
├── globals.css                     # TailwindCSS tokens & Google Stitch CSS rules
├── layout.tsx                      # Root layout, theme provider, & query client
└── page.tsx                        # Homepage (Hero banner, deals carousel, categories grid)
```

---

## 🛠️ Key Technologies

- **Framework**: Next.js 14 App Router (React 18)
- **Styling**: TailwindCSS, Framer Motion for micro-animations
- **State & Data Fetching**: `@tanstack/react-query`, `zustand`
- **Shared Monorepo Packages**: `@daily-basket/api-client`, `@daily-basket/design-system`, `@daily-basket/shared-types`, `@daily-basket/shared-utils`, `@daily-basket/theme`

---

## ⚡ Running Locally

```bash
# From workspace root
pnpm --filter website dev
```
Open `http://localhost:3005` in your browser.
