# 🌐 Customer Website Technical Specification (`apps/website`)

The **Next.js Customer Website** (`apps/website`) is built using Next.js 14 App Router, React 18, TailwindCSS, and TanStack Query.

---

## 1. Page Directory Overview (31 Pages)

- **Homepage (`/`)**: Hero section, 10-min delivery badge, flash deal timer, top categories grid.
- **Auth Routes (`/(auth)`)**: `/login`, `/register`, `/forgot-password`, `/verify-email`, `/account-locked`, `/enable-biometrics`.
- **Catalog & Search (`/categories`, `/search`)**: Sub-category explorer, price filter slider, debounced search grid.
- **Cart & Checkout (`/cart`, `/checkout`, `/order-success`)**: Sliding cart drawer, Razorpay modal launcher, receipt summary.
- **User Hub (`/wallet`, `/wishlist`, `/notifications`, `/security`)**: Wallet refills, saved items, notification feed, active sessions.
- **Experience Pages (`/freshness`, `/ai-assistant`, `/loyalty`, `/rate-delivery`)**: Produce freshness explorer, AI chat, VIP perks, feedback form.
