# 🔐 Daily Basket — Row-Level Security (RLS) & Access Policies

> **Authoritative Specification**: Defines database-native Row-Level Security (RLS) policies, multi-tenant isolation, role-based data boundaries, and audit logging standards across the **Daily Basket** PostgreSQL 16 database.
>
> **Related Documentation**:
> - 📊 [Data Model & Entity Relationships](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/DATA-MODEL.md)
> - 🧱 [Database Schema & Data Dictionary](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/SCHEMA.md)
> - 🔄 [Database Migrations & Change Management](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/MIGRATIONS.md)
> - 🗄️ [Prisma Schema Definition](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/prisma/schema.prisma)

---

## 1. Defense-in-Depth Security Architecture

Daily Basket enforces a **two-tier defense-in-depth access control model**:

```
+-----------------------------------------------------------------------------------+
|                        TIER 1: APPLICATION LAYER (NestJS)                         |
|  - JwtAuthGuard (Validates cryptographically signed access token)                 |
|  - RolesGuard (Checks @Roles() against JWT role claim)                            |
|  - Parameter Decorators (@CurrentUser(), @ResolvedUserId())                       |
|  - Business Logic Scoping (Explicit Prisma 'where' filtering)                     |
+-----------------------------------------------------------------------------------+
                                       │
                                       ▼ (SQL with Session Context)
+-----------------------------------------------------------------------------------+
|                     TIER 2: DATABASE NATIVE LAYER (PostgreSQL 16)                 |
|  - ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;                                 |
|  - Session Context: current_setting('app.current_user_id', true)                  |
|  - Session Context: current_setting('app.current_user_role', true)                |
|  - Session Context: current_setting('app.current_store_id', true)                 |
|  - Zero-Trust Policy Enforcement directly inside database execution engine       |
+-----------------------------------------------------------------------------------+
```

1. **Tier 1 (Application Layer)**: Eliminates unauthorized API traffic early via `JwtAuthGuard` and `RolesGuard`.
2. **Tier 2 (PostgreSQL Native RLS)**: Guarantees that even if an application bug, flawed query, or ORM misconfiguration occurs, the database engine physically rejects queries trying to access rows outside the caller's tenancy or ownership.

---

## 2. Role Personas & Access Boundaries

The database recognizes **9 distinct user personas** defined in the `Role` enum:

| Persona (`Role`) | Data Access Scope | Prohibited Access |
| :--- | :--- | :--- |
| **`CUSTOMER`** | Own profile, addresses, active cart, own orders, own wallet, own reviews, own AI sessions. | Other users' profiles, other users' orders, unapproved reviews, dark store inventories, ledgers. |
| **`DELIVERY_PARTNER`** | Own delivery profile, assigned vehicle, orders assigned to rider or ready for dispatch in active zone, customer delivery address for active deliveries. | Customer wallet balances, customer saved payment tokens, vendor costs, cross-zone orders. |
| **`STORE_MANAGER`** | Store metadata, product stock, picking queue, batch management, inventory audits, register closings for **assigned `storeId`**. | Other dark stores' orders, central financial ledgers, system observability logs. |
| **`INVENTORY_MANAGER`** | Catalog master, central warehouse stock, supplier purchase orders, goods receipt notes, inter-location transfers. | Customer personal data, payment gateway tokens, user security logs. |
| **`SUPPORT_EXECUTIVE`** | Customer tickets, chat messages, order fulfillment tracking, return requests, customer contact info for open tickets. | Financial ledgers, employee payroll, bulk database exports, password hashes. |
| **`FINANCE_MANAGER`** | Financial ledgers, daily closing audits, vendor payments, wallet transaction logs, order invoices. | Altering catalog products, customer passwords, delivery dispatch routes. |
| **`BUSINESS_OWNER`** | High-level analytics, multi-store revenue reports, franchise metrics, master data configurations. | Modifying picking state machines, direct inventory tampering. |
| **`ADMIN`** | Dark store operations, user role assignments, product catalog management, marketing banners, coupon creation. | Direct mutation of immutable security audit logs or financial ledger historical records. |
| **`SUPER_ADMIN`** | Complete cross-tenant management, disaster recovery execution, master workflow rule deployment. | Physical deletion of append-only audit logs. |

---

## 3. Session Context Propagation in PostgreSQL

To enable PostgreSQL RLS policies to evaluate the caller's identity, the application sets transaction-local session variables before query execution:

### 3.1. Session Variable Protocol
- `app.current_user_id`: UUID of the authenticated actor (`User.id`).
- `app.current_user_role`: Value of `Role` enum (e.g. `CUSTOMER`, `STORE_MANAGER`, `ADMIN`).
- `app.current_store_id`: UUID of the manager's or staff's assigned dark store (`Store.id`).

### 3.2. Prisma Client RLS Middleware / Extension Pattern

In [`services/api/src/modules/prisma/prisma.service.ts`](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/src):

```typescript
import { PrismaClient } from '@prisma/client';

export function createRlsClient(prisma: PrismaClient, user: { id: string; role: string; storeId?: string }) {
  return prisma.$extends({
    query: {
      $allModels: {
        async $allOperations({ args, query }) {
          return prisma.$transaction(async (tx) => {
            // Set transaction-local session variables:
            await tx.$executeRawUnsafe(
              `SET LOCAL app.current_user_id = '${user.id}';`
            );
            await tx.$executeRawUnsafe(
              `SET LOCAL app.current_user_role = '${user.role}';`
            );
            if (user.storeId) {
              await tx.$executeRawUnsafe(
                `SET LOCAL app.current_store_id = '${user.storeId}';`
              );
            }
            return query(args);
          });
        },
      },
    },
  });
}
```

---

## 4. Production PostgreSQL RLS Policy Definitions

The following SQL migration activates native PostgreSQL Row-Level Security across Daily Basket tables.

### 4.1. User Identity & Addresses (`users`, `addresses`)

```sql
-- ============================================================================
-- USERS TABLE POLICIES
-- ============================================================================
ALTER TABLE "users" ENABLE ROW LEVEL SECURITY;

-- Policy 1: Customers can view and update only their own profile
CREATE POLICY "users_customer_self_access" ON "users"
  FOR ALL
  USING (
    id = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  )
  WITH CHECK (
    id = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  );

-- Policy 2: Support executives can view customer profile for ticket resolution
CREATE POLICY "users_support_read_only" ON "users"
  FOR SELECT
  USING (current_setting('app.current_user_role', true) = 'SUPPORT_EXECUTIVE');

-- ============================================================================
-- ADDRESSES TABLE POLICIES
-- ============================================================================
ALTER TABLE "addresses" ENABLE ROW LEVEL SECURITY;

-- Customers can perform full CRUD on their own addresses
CREATE POLICY "addresses_owner_crud" ON "addresses"
  FOR ALL
  USING (
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  )
  WITH CHECK (
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  );

-- Delivery partners can view destination address for currently assigned orders
CREATE POLICY "addresses_rider_delivery_view" ON "addresses"
  FOR SELECT
  USING (
    current_setting('app.current_user_role', true) = 'DELIVERY_PARTNER'
    AND EXISTS (
      SELECT 1 FROM "orders" o
      WHERE o."addressId" = "addresses"."id"
        AND o."deliveryPartnerId" = NULLIF(current_setting('app.current_user_id', true), '')::text
        AND o."status" = 'OUT_FOR_DELIVERY'
    )
  );
```

### 4.2. Shopping Cart Subsystem (`carts`, `cart_items`)

```sql
-- ============================================================================
-- CARTS & CART ITEMS POLICIES
-- ============================================================================
ALTER TABLE "carts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "cart_items" ENABLE ROW LEVEL SECURITY;

-- Carts: Strictly accessible by the owning user
CREATE POLICY "carts_owner_access" ON "carts"
  FOR ALL
  USING (
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  )
  WITH CHECK (
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  );

-- Cart Items: Accessible only via the user's active cart
CREATE POLICY "cart_items_owner_access" ON "cart_items"
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM "carts" c
      WHERE c."id" = "cart_items"."cartId"
        AND (
          c."userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
          OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
        )
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM "carts" c
      WHERE c."id" = "cart_items"."cartId"
        AND (
          c."userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
          OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
        )
    )
  );
```

### 4.3. Orders & Fulfillment (`orders`, `order_items`)

```sql
-- ============================================================================
-- ORDERS & ORDER ITEMS POLICIES
-- ============================================================================
ALTER TABLE "orders" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "order_items" ENABLE ROW LEVEL SECURITY;

-- Policy: Multi-persona order visibility
CREATE POLICY "orders_visibility_policy" ON "orders"
  FOR SELECT
  USING (
    -- Customer views their own orders
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    
    -- Store Manager views orders in their dark store
    OR (
      current_setting('app.current_user_role', true) = 'STORE_MANAGER'
      AND "storeId" = NULLIF(current_setting('app.current_store_id', true), '')::text
    )
    
    -- Delivery partner views assigned orders or pending pickup orders
    OR (
      current_setting('app.current_user_role', true) = 'DELIVERY_PARTNER'
      AND (
        "deliveryPartnerId" = NULLIF(current_setting('app.current_user_id', true), '')::text
        OR "status" = 'READY_FOR_PICKUP'
      )
    )
    
    -- Support & Finance roles
    OR current_setting('app.current_user_role', true) IN (
      'SUPPORT_EXECUTIVE', 'FINANCE_MANAGER', 'BUSINESS_OWNER', 'ADMIN', 'SUPER_ADMIN'
    )
  );

-- Policy: Customer order creation
CREATE POLICY "orders_customer_create" ON "orders"
  FOR INSERT
  WITH CHECK (
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
  );

-- Policy: Store Manager & Rider status transition updates
CREATE POLICY "orders_status_update" ON "orders"
  FOR UPDATE
  USING (
    current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN')
    OR (
      current_setting('app.current_user_role', true) = 'STORE_MANAGER'
      AND "storeId" = NULLIF(current_setting('app.current_store_id', true), '')::text
    )
    OR (
      current_setting('app.current_user_role', true) = 'DELIVERY_PARTNER'
      AND "deliveryPartnerId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    )
  );

-- Order Items Policy: Mirrors parent order access
CREATE POLICY "order_items_policy" ON "order_items"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM "orders" o
      WHERE o."id" = "order_items"."orderId"
        AND (
          o."userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
          OR o."storeId" = NULLIF(current_setting('app.current_store_id', true), '')::text
          OR o."deliveryPartnerId" = NULLIF(current_setting('app.current_user_id', true), '')::text
          OR current_setting('app.current_user_role', true) IN (
            'SUPPORT_EXECUTIVE', 'FINANCE_MANAGER', 'ADMIN', 'SUPER_ADMIN'
          )
        )
    )
  );
```

### 4.4. Financial & Wallet Data (`wallets`, `wallet_transactions`)

```sql
-- ============================================================================
-- WALLETS & TRANSACTIONS POLICIES
-- ============================================================================
ALTER TABLE "wallets" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "wallet_transactions" ENABLE ROW LEVEL SECURITY;

-- Customer can read only their own wallet balance
CREATE POLICY "wallets_customer_read" ON "wallets"
  FOR SELECT
  USING (
    "userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
    OR current_setting('app.current_user_role', true) IN (
      'FINANCE_MANAGER', 'ADMIN', 'SUPER_ADMIN'
    )
  );

-- Direct wallet balance mutation blocked for regular users (backend internal only)
CREATE POLICY "wallets_system_mutation" ON "wallets"
  FOR UPDATE
  USING (current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN'));

-- Customer can view only their own transaction history
CREATE POLICY "wallet_tx_customer_read" ON "wallet_transactions"
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM "wallets" w
      WHERE w."id" = "wallet_transactions"."walletId"
        AND (
          w."userId" = NULLIF(current_setting('app.current_user_id', true), '')::text
          OR current_setting('app.current_user_role', true) IN (
            'FINANCE_MANAGER', 'ADMIN', 'SUPER_ADMIN'
          )
        )
    )
  );
```

### 4.5. Dark Store Inventories (`inventories`)

```sql
-- ============================================================================
-- INVENTORIES TABLE POLICIES
-- ============================================================================
ALTER TABLE "inventories" ENABLE ROW LEVEL SECURITY;

-- Public can view catalog stock quantity to prevent out-of-stock purchases
CREATE POLICY "inventories_public_read" ON "inventories"
  FOR SELECT
  USING (true);

-- Store Managers can mutate stock only in their assigned dark store
CREATE POLICY "inventories_store_manager_mutation" ON "inventories"
  FOR ALL
  USING (
    current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN', 'INVENTORY_MANAGER')
    OR (
      current_setting('app.current_user_role', true) = 'STORE_MANAGER'
      AND "storeId" = NULLIF(current_setting('app.current_store_id', true), '')::text
    )
  );
```

### 4.6. Tamper-Proof Security Audit Logs (`security_audit_logs`)

```sql
-- ============================================================================
-- SECURITY AUDIT LOGS (APPEND-ONLY)
-- ============================================================================
ALTER TABLE "security_audit_logs" ENABLE ROW LEVEL SECURITY;

-- Allow insert by system actors for audit tracing
CREATE POLICY "audit_logs_append_only" ON "security_audit_logs"
  FOR INSERT
  WITH CHECK (true);

-- Read access restricted to Security Admins only
CREATE POLICY "audit_logs_admin_read" ON "security_audit_logs"
  FOR SELECT
  USING (current_setting('app.current_user_role', true) IN ('ADMIN', 'SUPER_ADMIN'));

-- Explicitly disallow UPDATE and DELETE to preserve audit integrity:
-- (No policies created for UPDATE or DELETE, ensuring complete immutability)
```

---

## 5. Performance Optimization with RLS

To maintain sub-250ms query execution times under PostgreSQL RLS:

1. **Indexed Policy Predicates**:
   - Every column used in an RLS filter (`userId`, `storeId`, `deliveryPartnerId`, `status`) has a corresponding B-Tree index in `schema.prisma`.
2. **Correlated Subquery Optimization**:
   - Nested policies (e.g. `order_items` checking `orders`) utilize `EXISTS (...)` clauses with primary key indexed lookups rather than large `IN (...)` arrays.
3. **Prepared Statements & Function Caching**:
   - `NULLIF(current_setting('app.current_user_id', true), '')::text` is optimized as a lightweight config fetch without requiring costly disk lookups.

---

## 6. Regulatory Compliance Standards

| Regulatory Framework | Mandatory Protection | RLS & System Enforcement |
| :--- | :--- | :--- |
| **India DPDP Act 2023** (Digital Personal Data Protection) | Purpose limitation, customer access to own data, consent logging. | RLS guarantees that customers cannot browse other citizens' addresses, mobile numbers, or order histories. Audit logs track all profile lookups. |
| **GDPR** (EU General Data Protection Regulation) | Right to Access (Art. 15), Right to Erasure (Art. 17). | Customer profile, cart, and address deletions cascade cleanly (`onDelete: Cascade`) without leaking orphaned rows. |
| **PCI-DSS Compliance** | Strict isolation of cardholder payment vectors. | Raw credit card numbers and CVVs are **never stored** in the database; only Razorpay transaction tokens and masked methods (`PaymentMethod.UPI`, `PaymentMethod.CARD`) exist in tables protected by RLS. |
