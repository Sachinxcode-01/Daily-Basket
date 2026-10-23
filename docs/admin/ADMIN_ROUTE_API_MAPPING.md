# Daily Basket Admin Panel — Screen, Route, API & Database Mapping

## Batch 1: Authentication, Access Control, Navigation & Dashboard

### 1. Architectural Overview

```text
Admin Screen (Next.js 14 App Router)
    ↓
Frontend Component / Form / Action
    ↓
Session / Cookie Verification (apps/admin/middleware.ts & AuthContext)
    ↓
Next.js Internal Route Handler (/api/dashboard/...) or Direct ApiClient Call
    ↓
NestJS API Backend (/api/v1/admin/dashboard/...)
    ↓
Authentication & Authorization (JwtAuthGuard + RolesGuard)
    ↓
Service Layer (AdminDashboardService, AuthService)
    ↓
Prisma ORM & PostgreSQL Database (Order, Inventory, Product, User)
    ↓
JSON Response
    ↓
Hydrated UI (Google Stitch Locked Parity)
```

---

### 2. Route & API Mapping Table

| Screen Name | Frontend Route | UI Component | API Endpoint | HTTP Method | Service / Handler | Database Models | Permission / Roles | User Workflow |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Admin Login** | `/login` | `AdminLoginPage` (`apps/admin/app/login/page.tsx`) | `/api/v1/auth/login-email` & `/api/auth/login` | `POST` | `AuthService.loginEmail` | `User`, `DeviceSession`, `SecurityAuditLog` | Public (Rate-limited: 5 attempts/min) | Admin enters company email & credentials, validates 2FA if enabled, sets HTTP-only secure cookie `db_admin_session`, and redirects to target route. |
| **Admin Session Hydration** | Global Layout | `AuthProvider` (`apps/admin/app/lib/auth-context.tsx`) | `/api/auth/me` | `GET` | Next.js API Route | `User` (token payload decode) | Bearer Token / Cookie | On page load/reload, verifies active session, decodes user identity and role. Redirects unauthenticated access to `/login`. |
| **Admin Logout** | Topbar / Sidebar | `AdminShell` dropdown | `/api/auth/logout` | `POST` | Next.js API Route | `DeviceSession` | Authenticated | Clears `db_admin_session` cookie with past expiry date, resets in-memory auth state, and redirects to `/login`. |
| **Dashboard Overview** | `/` & `/dashboard` | `AdminOverviewPage` (`apps/admin/app/page.tsx`) | `/api/v1/admin/dashboard/summary` | `GET` | `AdminDashboardController.getSummary` -> `AdminDashboardService.getSummary` | `Order`, `Inventory`, `Product`, `User` | `ADMIN`, `SUPER_ADMIN`, `STORE_MANAGER`, `INVENTORY_MANAGER`, `BUSINESS_OWNER` | Displays real-time database-derived KPI metrics: today's revenue, yesterday comparison %, active orders, packing/delivery split, 10-min SLA delivery time, new customers, and active alerts. |
| **Sales Trend Visualization** | `/` (Dashboard Chart) | `AdminOverviewPage` (Middle Section) | `/api/v1/admin/dashboard/sales` | `GET` | `AdminDashboardController.getSalesTrend` -> `AdminDashboardService.getSalesTrend` | `Order` | `ADMIN`, `SUPER_ADMIN`, `STORE_MANAGER`, `BUSINESS_OWNER` | Aggregates actual 7-day database order totals and revenue with daily breakdown, hover tooltips, and bar chart rendering matching Stitch. |
| **Recent Order Queue** | `/` (Live Order Feed) | `AdminOverviewPage` (Bottom Table) | `/api/v1/admin/dashboard/recent-orders` | `GET` | `AdminDashboardController.getRecentOrders` -> `AdminDashboardService.getRecentOrders` | `Order`, `OrderItem`, `User` | `ADMIN`, `SUPER_ADMIN`, `STORE_MANAGER`, `BUSINESS_OWNER` | Live order queue with customer initials badge, items summary, amount, elapsed timer, status pill, and deep link to order details. |
| **Inventory Alerts** | `/` (Inventory Card) | `AdminOverviewPage` (Middle Section) | `/api/v1/admin/dashboard/inventory-alerts` | `GET` | `AdminDashboardController.getInventoryAlerts` -> `AdminDashboardService.getInventoryAlerts` | `Inventory`, `ProductVariant`, `Product` | `ADMIN`, `SUPER_ADMIN`, `STORE_MANAGER`, `INVENTORY_MANAGER` | Real-time low-stock and out-of-stock SKU alerts with severity indicators (Critical/Urgent/Low) and quick restock link to `/inventory`. |

---

### 3. Google Stitch Visual Parity Mapping

* **Stitch Source**: `docs/stitch/admin_overview.html`
* **Tailwind Design System Tokens**:
  * Surface Background: `#f9f9fc` / `#f7f8fa`
  * Card Background: `#ffffff` (`bg-surface-container-lowest`) with `rounded-xl`
  * Primary Green: `#006b23` / `#2d9d43` (`primary`)
  * Typography: `Outfit` (Headlines, large KPI metrics) & `Inter` (Labels, data tables, body copy)
* **Bento Grid Layout**:
  * Top Row: 4 equal cards (Revenue, Orders Today, New Customers, Avg Delivery Time)
  * Middle Row (2:1): 7-Day Sales Trend Bar Chart + Inventory Alerts
  * Bottom Row: Full-width Live Order Feed Table with status badges and quick action links.
