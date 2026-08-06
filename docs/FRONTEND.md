# 🌐 Frontend Architecture & Shared Monorepo Packages — Daily Basket

This document describes the web application architecture across the three Next.js 14 web portals (`apps/website`, `apps/admin`, `apps/delivery`) and shared monorepo packages (`packages/*`).

---

## 1. Web Portals Matrix

| Application | Framework | Purpose | Port | State Management |
| :--- | :--- | :--- | :--- | :--- |
| **`apps/website`** | Next.js 14 App Router | Customer eCommerce web portal & security hub | `3005` | React Query + Zustand |
| **`apps/admin`** | Next.js 14 App Router | Dark Store fulfillment queue & inventory control | `3001` | Zustand + Socket.IO |
| **`apps/delivery`** | Next.js 14 PWA | Delivery Partner rider PWA & OTP verification | `3002` | React local state + Geolocation API |

---

## 2. Shared Monorepo Packages (`packages/`)

To eliminate code duplication across web and mobile applications, shared code is modularized inside `packages/`:

```
packages/
├── api-client/                     # Typed Axios SDK client (`@daily-basket/api-client`)
├── constants/                      # Enums, roles, order status constants (`@daily-basket/constants`)
├── design-system/                  # Tailwind token presets & CSS utilities (`@daily-basket/design-system`)
├── shared-types/                   # TypeScript DTO interfaces (`@daily-basket/shared-types`)
├── shared-ui/                      # Shared React UI component library (`@daily-basket/shared-ui`)
├── shared-utils/                   # Currency formatters, date utilities (`@daily-basket/shared-utils`)
└── theme/                          # Color palettes & branding tokens (`@daily-basket/theme`)
```

---

## 3. Shared Utilities Usage Example

```typescript
import { formatCurrency, formatETA } from '@daily-basket/shared-utils';
import { OrderStatus } from '@daily-basket/constants';

const formattedPrice = formatCurrency(149.50); // "₹149.50"
const etaBadge = formatETA(10); // "⚡ 10 mins"
```
