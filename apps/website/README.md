# 🌐 Daily Basket — Customer Web Portal (`apps/website`)

![Next.js 14](https://img.shields.io/badge/Next.js-14.2-black?style=for-the-badge&logo=nextdotjs&logoColor=white)
![React 18](https://img.shields.io/badge/React-18.2-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![TailwindCSS](https://img.shields.io/badge/Tailwind-3.4-38B2AC?style=for-the-badge&logo=tailwindcss&logoColor=white)
![Firebase Auth](https://img.shields.io/badge/Firebase-Google%20SSO-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![TanStack Query](https://img.shields.io/badge/TanStack%20Query-5.24-FF4154?style=for-the-badge&logo=reactquery&logoColor=white)

---

## 📌 Overview

The **Daily Basket Customer Website** is a modern, responsive web application built with Next.js 14 (App Router), React 18, TailwindCSS, and TanStack Query. It provides shoppers with an ultra-fast grocery delivery experience featuring Google Stitch dark-mode aesthetics, Firebase & Google OAuth 2.0 single sign-on, Razorpay payments, and live Socket.IO delivery tracking.

---

## 🔐 Authentication & Single Sign-On

- **Google OAuth 2.0 & Firebase SSO**: Single-click sign-in (`/login`) and sign-up (`/register`) integrating seamlessly with backend Firebase Admin SDK (`daily-basket-8b266`).
- **Cart Migration**: Automatic merging of anonymous guest carts into the authenticated user account on successful login.
- **Biometric Security**: WebAuthn / Passkeys authentication setup (`/enable-biometrics`).
- **Security Hub**: Active device sessions overview, password change, and security audit log (`/security`).

---

## 🏗️ Architecture & App Directory

```
apps/website/app/
├── (auth)/                         # Authentication routing group
│   ├── login/                      # Login page (Google SSO / Email / Phone)
│   ├── register/                   # Registration page (Google SSO / Email)
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

## 🛠️ Key Technologies & Dependencies

- **Framework**: Next.js 14 App Router (React 18)
- **Styling**: TailwindCSS, Framer Motion for micro-animations
- **Authentication**: Firebase Admin backend integration, `@daily-basket/api-client`
- **State & Data Fetching**: `@tanstack/react-query`, `zustand`
- **Monorepo Packages**: `@daily-basket/api-client`, `@daily-basket/design-system`, `@daily-basket/shared-types`, `@daily-basket/shared-utils`, `@daily-basket/theme`

---

## ⚡ Running Locally

```bash
# From workspace root
pnpm --filter website dev
```

Open `http://localhost:3005` in your browser.
