# 📊 Daily Basket — Enterprise Data Model & Entity Architecture

> **Authoritative Specification**: Defines all data entities, relationships, domain boundaries, state lifecycles, and relational topologies for the **Daily Basket** hyperlocal quick-commerce platform.
>
> **Related Documentation**:
> - 🧱 [Database Schema & Data Dictionary](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/SCHEMA.md)
> - 🔄 [Database Migrations & Change Management](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/MIGRATIONS.md)
> - 🔐 [Row-Level Security & Access Policies](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/RLS-POLICIES.md)
> - 🗄️ [Prisma Schema Definition](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/prisma/schema.prisma)

---

## 1. Architectural Overview & Design Philosophy

Daily Basket is built on a **Domain-Driven Design (DDD)** relational data model backed by **PostgreSQL 16** and managed via **Prisma ORM 5**. The architecture is optimized for:

- **Sub-250ms Query Latency**: Strict relational indexing, query projection, and composite keys ensure lightning-fast read operations for customer catalog browsing and dark store dispatch.
- **Hyperlocal Multi-Store Partitioning**: Every dark store (`Store`) acts as an operational nexus with isolated physical inventories, pricing overrides, and fulfillment radii.
- **Concurrency & Atomic State Preservation**: Two-phase stock reservation (`stockQuantity` vs `reservedQuantity`) eliminates race conditions during flash-sales and peak checkout bursts.
- **Multimodal AI Integration**: Dedicated sub-schemas capture conversational AI shopping sessions, multimodal visual searches, voice logs, and customer affinity models without polluting transactional tables.
- **End-to-End Enterprise Operations**: Complete data pipelines connecting dark store picking, warehouse transfers, fleet dispatch, supplier purchase orders, and daily financial ledgers.

```
+---------------------------------------------------------------------------------------+
|                                DAILY BASKET PLATFORM                                  |
+---------------------------------------------------------------------------------------+
|  +--------------------+  +----------------------+  +-------------------------------+  |
|  |   Catalog & Store  |  |    User & Identity   |  |   Cart, Orders & Payments     |  |
|  |   7 Tables         |  |    7 Tables          |  |   10 Tables                       |  |
|  +--------------------+  +----------------------+  +-------------------------------+  |
|  +--------------------+  +----------------------+  +-------------------------------+  |
|  |  Customer & Social |  |   Multimodal AI &    |  |  Voice Shopping Engine        |  |
|  |  9 Tables          |  |   Personalization    |  |  4 Tables                     |  |
|  |                    |  |   16 Tables          |  |                               |  |
|  +--------------------+  +----------------------+  +-------------------------------+  |
|  +--------------------+  +----------------------+  +-------------------------------+  |
|  |  Supply Chain & PO |  |  Financial Ledger &  |  |  Logistics, Fleet & Warehouse |  |
|  |  6 Tables          |  |  Reconciliation      |  |  7 Tables                     |  |
|  |                    |  |  2 Tables            |  |                               |  |
|  +--------------------+  +----------------------+  +-------------------------------+  |
|  +--------------------+  +---------------------------------------------------------+  |
|  | Customer Support   |  |  Enterprise Governance, Observability & Backups         |  |
|  | 3 Tables           |  |  8 Tables                                               |  |
|  +--------------------+  +---------------------------------------------------------+  |
+---------------------------------------------------------------------------------------+
Total: 79 Relational Models | 4 Native Enums | 729 Columns | 114 Foreign Key Relations
```

---

## 2. Bounded Contexts & Entity Domain Breakdown

The Daily Basket relational schema is segmented into **12 Bounded Contexts**:

| # | Bounded Context | Core Entities | Primary Responsibility |
| :- | :--- | :--- | :--- |
| **1** | **Catalog & Store Topology** | `Store`, `Category`, `Product`, `ProductVariant`, `Inventory`, `StoreSettings`, `Banner` | Dark store metadata, hierarchical taxonomy, SKU variants, stock units, and storefront banners. |
| **2** | **Identity, Auth & Security** | `User`, `Address`, `DeviceSession`, `OtpVerification`, `SecurityAuditLog`, `PasswordHistory`, `EmployeeProfile` | Authentication, multi-factor auth (TOTP/SMS), device tokens, delivery addresses, and security audits. |
| **3** | **Cart, Orders & Invoicing** | `Cart`, `CartItem`, `Order`, `OrderItem`, `OrderInvoice` | Persistent customer baskets, atomic order creation, fulfillment queues, and GST-compliant tax invoices. |
| **4** | **Payments, Wallet & Promos** | `Payment`, `Wallet`, `WalletTransaction`, `Coupon`, `CouponRedemption` | Razorpay transactions, cashback balances, ledger credits/debits, discount vouchers, and usage tracking. |
| **5** | **Customer Engagement & CRM** | `Review`, `Favorite`, `Wishlist`, `RecentlyViewed`, `GroceryList`, `UserImpact`, `UserBadge`, `InAppNotification`, `CustomerManagementNote` | Product ratings, saved lists, recurring baskets, carbon offset impact metrics, gamification badges, and CRM notes. |
| **6** | **Customer Support & Care** | `SupportTicket`, `ChatMessage`, `StockAlert` | Live customer service ticketing, omnichannel messaging, and restock notification alerts. |
| **7** | **AI Intelligence & Discovery** | `AiConversationSession`, `AiChatMessage`, `AiAuditLog`, `AiAnalyticsMetric`, `PromptTemplate`, `SearchAnalytics`, `TrendingSearch`, `BlockedQuery`, `ProductAiInsight`, `UserPreferenceProfile`, `ImageSearchLog`, `ProductReferenceImage`, `VisualAiAnalyticsMetric`, `PredictiveReorderItem`, `PersonalizedOffer`, `PersonalizationRule`, `AiCopilotQueryLog` | Conversational shopping agent, visual image match vectors, predictive cart repopulation, and search ranking telemetry. |
| **8** | **Voice Shopping Engine** | `VoiceSession`, `VoiceCommandLog`, `VoiceSettings`, `VoiceAnalyticsMetric` | Multilingual speech-to-intent sessions (English, Hindi, Kannada, Tamil, Telugu), acoustic confidence logs, and speech metrics. |
| **9** | **Inventory Procurement & PO** | `BatchManagement`, `InventoryAudit`, `Supplier`, `PurchaseOrder`, `GoodsReceiptNote`, `VendorPayment` | Lot/batch expiry tracking, dark store stock counting, vendor master data, PO dispatch, and goods receipt verification. |
| **10** | **Financial Accounting** | `FinancialLedger`, `DailyClosing` | Double-entry journal entries, store-level end-of-day register balancing, and cash/digital settlement audits. |
| **11** | **Logistics, Fleet & Hubs** | `DeliveryPartnerProfile`, `DeliveryZone`, `FleetVehicle`, `Warehouse`, `WarehouseInventory`, `InterLocationTransfer`, `Franchise` | Delivery partner onboarding, geospatial delivery polygons, EV fleet telematics, central warehouse buffers, and inter-store stock transfers. |
| **12** | **Enterprise Governance** | `BusinessDocument`, `BusinessInsightLog`, `SystemObservabilityMetric`, `MasterDataConfig`, `WorkflowRule`, `IntegrationConnection`, `DisasterRecoveryBackup` | Compliance contracts, automated business rules, API connectors, telemetry traces, and point-in-time disaster backups. |

---

## 3. Visual Entity-Relationship Diagrams (Mermaid)

### 3.1. Core Customer, Catalog & Order Fulfillment Flow

```mermaid
erDiagram
    STORE ||--o{ PRODUCT : "catalogs"
    STORE ||--o{ ORDER : "fulfills"
    STORE ||--o{ INVENTORY : "stocks"
    STORE ||--o| STORE_SETTINGS : "configures"

    CATEGORY ||--o{ CATEGORY : "parent_of"
    CATEGORY ||--o{ PRODUCT : "groups"

    PRODUCT ||--|{ PRODUCT_VARIANT : "has_units"
    PRODUCT ||--o{ REVIEW : "rated_by"
    PRODUCT ||--o{ FAVORITE : "marked_in"
    PRODUCT ||--o| PRODUCT_AI_INSIGHT : "analyzed_by"

    PRODUCT_VARIANT ||--o{ INVENTORY : "allocated_in"
    PRODUCT_VARIANT ||--o{ CART_ITEM : "added_as"
    PRODUCT_VARIANT ||--o{ ORDER_ITEM : "purchased_as"

    USER ||--o{ ADDRESS : "saved_addresses"
    USER ||--o| CART : "current_cart"
    USER ||--o{ ORDER : "places"
    USER ||--o{ REVIEW : "publishes"
    USER ||--o| WALLET : "holds_balance"

    CART ||--o{ CART_ITEM : "contains"
    ORDER ||--|{ ORDER_ITEM : "comprises"
    ORDER ||--o| PAYMENT : "settled_via"
    ORDER ||--o| ORDER_INVOICE : "generates"
    ORDER }|--|| ADDRESS : "shipped_to"
```

### 3.2. User Authentication, Device Sessions & Security Subsystem

```mermaid
erDiagram
    USER ||--o{ DEVICE_SESSION : "authorizes"
    USER ||--o{ OTP_VERIFICATION : "verifies"
    USER ||--o{ SECURITY_AUDIT_LOG : "records"
    USER ||--o{ PASSWORD_HISTORY : "tracks_rotation"
    USER ||--o| USER_PREFERENCE_PROFILE : "personalizes"
    USER ||--o| DELIVERY_PARTNER_PROFILE : "onboards_rider"
    USER ||--o| EMPLOYEE_PROFILE : "onboards_staff"

    USER {
        string id PK "UUID"
        string phoneNumber UK "E.164 format"
        string email UK "Optional"
        string fullName "Customer name"
        enum role "Role enum"
        boolean mfaEnabled "MFA status"
        string mfaType "TOTP, SMS, EMAIL"
        int failedLoginAttempts "Brute force counter"
        datetime lockoutUntil "Temporary lock expiration"
    }

    DEVICE_SESSION {
        string id PK "UUID"
        string userId FK "References User"
        string refreshToken UK "Hashed refresh token"
        string deviceId "Unique device fingerprint"
        string platform "ANDROID, IOS, WEB"
        datetime expiresAt "Session validity"
    }

    SECURITY_AUDIT_LOG {
        string id PK "UUID"
        string userId FK "Actor user ID"
        string event "LOGIN_SUCCESS, MFA_CHALLENGE, etc."
        string ipAddress "IPv4 / IPv6"
        string userAgent "Client user-agent string"
        datetime createdAt "Timestamp"
    }
```

### 3.3. Payments, Digital Wallet & Financial Reconciliation

```mermaid
erDiagram
    USER ||--o| WALLET : "owns"
    WALLET ||--o{ WALLET_TRANSACTION : "records"
    ORDER ||--o| PAYMENT : "triggers"
    PAYMENT ||--o| WALLET_TRANSACTION : "refund_or_credit"
    COUPON ||--o{ COUPON_REDEMPTION : "redeemed_in"
    USER ||--o{ COUPON_REDEMPTION : "claims"
    STORE ||--o{ FINANCIAL_LEDGER : "journals"
    STORE ||--o{ DAILY_CLOSING : "closes_register"

    PAYMENT {
        string id PK "UUID"
        string orderId FK "References Order"
        float amount "Transaction sum"
        enum method "UPI, CARD, WALLET, COD"
        enum status "PENDING, SUCCESS, FAILED, REFUNDED"
        string transactionId "Gateway reference (Razorpay)"
    }

    WALLET_TRANSACTION {
        string id PK "UUID"
        string walletId FK "References Wallet"
        float amount "Transaction delta"
        string type "CREDIT, DEBIT"
        string description "Cashback, Order payment, Refund"
    }

    FINANCIAL_LEDGER {
        string id PK "UUID"
        string storeId FK "References Store"
        string entryType "DEBIT, CREDIT"
        float amount "Monetary value"
        string accountCode "General Ledger Code"
        string description "Daily balance or vendor invoice"
    }
```

### 3.4. Dark Store Supply Chain, Warehousing & Fleet Dispatch

```mermaid
erDiagram
    WAREHOUSE ||--o{ WAREHOUSE_INVENTORY : "central_stock"
    WAREHOUSE ||--o{ INTER_LOCATION_TRANSFER : "source_or_target"
    STORE ||--o{ INTER_LOCATION_TRANSFER : "receives_or_sends"
    STORE ||--o{ BATCH_MANAGEMENT : "monitors_expiry"
    STORE ||--o{ INVENTORY_AUDIT : "conducts_counts"

    SUPPLIER ||--o{ PURCHASE_ORDER : "issues_to"
    PURCHASE_ORDER ||--o{ GOODS_RECEIPT_NOTE : "fulfills_via"
    SUPPLIER ||--o{ VENDOR_PAYMENT : "receives_settlement"

    DELIVERY_ZONE ||--o{ STORE : "covers"
    DELIVERY_ZONE ||--o{ FLEET_VEHICLE : "assigned_to"
    USER ||--o| DELIVERY_PARTNER_PROFILE : "operates"
    DELIVERY_PARTNER_PROFILE ||--o{ ORDER : "delivers"
```

---

## 4. Entity Cardinality & Relational Foreign Key Rules

| Parent Entity | Child Entity | Cardinality | Foreign Key (`Child.FK`) | Referential Action (`onDelete`) | Business Reason |
| :--- | :--- | :---: | :--- | :---: | :--- |
| `Store` | `Product` | `1 : N` | `Product.storeId` | `Cascade` | Catalog items belong to their local dark store. |
| `Store` | `Inventory` | `1 : N` | `Inventory.storeId` | `Cascade` | Physical stock levels belong to the specific store. |
| `Store` | `Order` | `1 : N` | `Order.storeId` | `Restrict` | Historical orders must never be deleted if a store is archived. |
| `Category` | `Category` | `1 : N` | `Category.parentId` | `SetNull` | Root categories have `parentId = null`; subcategories link upwards. |
| `Category` | `Product` | `1 : N` | `Product.categoryId` | `Restrict` | Products must not be orphaned when reorganizing categories. |
| `Product` | `ProductVariant` | `1 : N` | `ProductVariant.productId`| `Cascade` | SKUs, weights, and pack sizes belong strictly to their parent product. |
| `ProductVariant` | `Inventory` | `1 : N` | `Inventory.variantId` | `Cascade` | Variant stock tracking across dark store nodes. |
| `User` | `Address` | `1 : N` | `Address.userId` | `Cascade` | User-saved addresses are purged if the customer account is deleted. |
| `User` | `Order` | `1 : N` | `Order.userId` | `Restrict` | Financial compliance mandates keeping order history for auditing. |
| `User` | `Cart` | `1 : 1` | `Cart.userId` | `Cascade` | Each customer has exactly one active shopping basket. |
| `Cart` | `CartItem` | `1 : N` | `CartItem.cartId` | `Cascade` | Clearing a cart atomically purges its associated line items. |
| `Order` | `OrderItem` | `1 : N` | `OrderItem.orderId` | `Cascade` | Order items form an immutable snapshot of items ordered. |
| `Order` | `Payment` | `1 : N` | `Payment.orderId` | `Cascade` | Payment transactions belong to their respective order. |
| `Order` | `OrderInvoice` | `1 : 1` | `OrderInvoice.orderId` | `Cascade` | Legal tax invoice generated upon order confirmation. |
| `User` | `Wallet` | `1 : 1` | `Wallet.userId` | `Cascade` | Digital customer wallet for cashbacks and credits. |
| `Wallet` | `WalletTransaction` | `1 : N` | `WalletTransaction.walletId` | `Cascade` | Append-only financial ledger of wallet balance adjustments. |
| `User` | `DeviceSession` | `1 : N` | `DeviceSession.userId` | `Cascade` | Multiple active mobile/web sessions for single user. |
| `User` | `SecurityAuditLog` | `1 : N` | `SecurityAuditLog.userId` | `Cascade` | Security incident timeline for authentication actions. |
| `User` | `AiConversationSession` | `1 : N` | `AiConversationSession.userId` | `Cascade` | AI chat sessions initiated by the user. |
| `AiConversationSession` | `AiChatMessage` | `1 : N` | `AiChatMessage.sessionId` | `Cascade` | Conversational messages between shopper and AI agent. |
| `Warehouse` | `WarehouseInventory` | `1 : N` | `WarehouseInventory.warehouseId`| `Cascade` | Bulk buffer stock maintained at distribution hubs. |
| `Supplier` | `PurchaseOrder` | `1 : N` | `PurchaseOrder.supplierId` | `Restrict` | Vendor procurement history must remain immutable. |

---

## 5. State Lifecycles & Transition Machines

### 5.1. Order Fulfillment State Machine (`OrderStatus`)

The order lifecycle adheres to a deterministic state machine managed by dark store picking systems and delivery rider telemetry:

```mermaid
stateDiagram-v2
    [*] --> CREATED : Customer initiates checkout
    CREATED --> CONFIRMED : Payment validated (Razorpay / COD)
    CREATED --> CANCELLED : Payment failed or checkout expired
    
    CONFIRMED --> PACKING : Dark store picker accepts order
    CONFIRMED --> CANCELLED : Customer cancel window (<60s)
    
    PACKING --> READY_FOR_PICKUP : Picker bags items & attaches QR code
    
    READY_FOR_PICKUP --> OUT_FOR_DELIVERY : Rider scans QR code & accepts batch
    
    OUT_FOR_DELIVERY --> DELIVERED : Doorstep OTP verified
    OUT_FOR_DELIVERY --> CANCELLED : Customer unreachable / address incorrect
    
    CANCELLED --> REFUNDED : Wallet credit / Razorpay webhook refund
    DELIVERED --> REFUNDED : Quality dispute / return approved
    
    DELIVERED --> [*]
    REFUNDED --> [*]
```

### 5.2. Payment State Machine (`PaymentStatus`)

```mermaid
stateDiagram-v2
    [*] --> PENDING : Payment intent created
    PENDING --> SUCCESS : Webhook verified (HMAC SHA-256)
    PENDING --> FAILED : Card declined / UPI timeout
    SUCCESS --> REFUNDED : Return or cancellation initiated
    FAILED --> [*]
    REFUNDED --> [*]
```

### 5.3. Inventory Reservation Dynamics

To prevent overselling, stock allocation uses atomic two-phase updates:

$$\text{Available Stock} = \text{stockQuantity} - \text{reservedQuantity}$$

1. **Cart Checkout**: When an order enters `CREATED`, `reservedQuantity` increments by the required units.
2. **Payment Confirmation**: Upon transition to `CONFIRMED`, `stockQuantity` and `reservedQuantity` decrement simultaneously:
   $$\Delta \text{stockQuantity} = -N, \quad \Delta \text{reservedQuantity} = -N$$
3. **Cart Abandonment / Payment Failure**: If payment fails or times out (10 minutes), `reservedQuantity` is released:
   $$\Delta \text{reservedQuantity} = -N$$

---

## 6. Data Integrity & Normalization Standards

1. **Third Normal Form (3NF) Baseline**: All core business transactional entities adhere strictly to 3NF. Redundancies are prohibited except where denormalization is purposefully applied for sub-second read performance (e.g., `OrderItem.unitPrice` and `OrderItem.productName` capturing the point-in-time catalog state).
2. **Immutable Point-in-Time Snapshots**:
   - `OrderItem`: Stores frozen `price`, `productName`, and `unitName` at the moment of order placement to guarantee historical invoicing accuracy even if product details change later.
   - `OrderInvoice`: Persists generated tax breakdowns, CGST/SGST/IGST rates, and store registration numbers.
3. **Geospatial Precision**:
   - Geolocation coordinates (`latitude`, `longitude`) are stored as 64-bit IEEE 754 Floating Points (`DOUBLE PRECISION`), providing sub-meter physical accuracy for dark store dispatch polygons and rider telemetry.
4. **Soft Deletions vs Explicit Deletions**:
   - Products and Variants utilize availability flags (`isAvailable = false`) rather than hard physical deletions to preserve historical order integrity.
   - Session tokens, cart items, and OTPs are hard-deleted upon expiration or invalidation to keep table sizes compact.
