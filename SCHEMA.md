# 🧱 Daily Basket — Database Schema & Data Dictionary Reference

> **Authoritative Specification**: Complete reference documentation of all database tables, columns, physical data types, constraints, default values, and relational indexes across the **Daily Basket** PostgreSQL 16 database.
>
> **Related Documentation**:
> - 📊 [Data Model & Entity Relationships](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/DATA-MODEL.md)
> - 🔄 [Database Migrations & Change Management](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/MIGRATIONS.md)
> - 🔐 [Row-Level Security & Access Policies](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/RLS-POLICIES.md)
> - 🗄️ [Prisma Schema Definition](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/prisma/schema.prisma)

---

## 1. Database Architecture & Technical Specs

- **Database Engine**: PostgreSQL 16
- **ORM / Query Engine**: Prisma ORM 5 (`@prisma/client`)
- **Total Relational Tables**: 79 tables
- **Total Columns**: 729 scalar and enum columns
- **Foreign Key Relationships**: 114 explicit relational constraints
- **Primary Key Format**: UUID v4 (`@id @default(uuid())`)
- **Timezone Standard**: UTC (`TIMESTAMP(3)` with millisecond precision)
- **Monetary & Geospatial Precision**: `Float` (Double Precision) for geolocation coordinates and monetary totals

---

## 2. Global Enumerations

```sql
-- User Roles Enum
CREATE TYPE "Role" AS ENUM (
  'CUSTOMER', 'ADMIN', 'STORE_MANAGER', 'INVENTORY_MANAGER',
  'SUPPORT_EXECUTIVE', 'FINANCE_MANAGER', 'DELIVERY_PARTNER',
  'BUSINESS_OWNER', 'SUPER_ADMIN'
);

-- Order Status Progression Enum
CREATE TYPE "OrderStatus" AS ENUM (
  'CREATED', 'CONFIRMED', 'PACKING', 'READY_FOR_PICKUP',
  'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED', 'REFUNDED'
);

-- Supported Payment Methods Enum
CREATE TYPE "PaymentMethod" AS ENUM (
  'UPI', 'CARD', 'NET_BANKING', 'WALLET', 'CASH_ON_DELIVERY'
);

-- Payment Settlement Status Enum
CREATE TYPE "PaymentStatus" AS ENUM (
  'PENDING', 'SUCCESS', 'FAILED', 'REFUNDED'
);
```

---

## 3. Comprehensive Data Dictionary by Bounded Context

### 1. Catalog & Dark Store Infrastructure

#### Table: `stores` (Model: `Store`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `code` | `String` | No | - | **UNIQUE** | Unique business identifier code |
| `address` | `String` | No | - | - | Attribute value |
| `city` | `String` | No | - | - | Attribute value |
| `pincode` | `String` | No | - | - | Unique business identifier code |
| `latitude` | `Float` | No | - | - | Attribute value |
| `longitude` | `Float` | No | - | - | Attribute value |
| `isOpen` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `products (Product[])`, `orders (Order[])`, `inventories (Inventory[])`, `settings (StoreSettings?)`

---

#### Table: `categories` (Model: `Category`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `slug` | `String` | No | - | **UNIQUE** | Attribute value |
| `description` | `String` | Yes | - | - | Attribute value |
| `imageUrl` | `String` | Yes | - | - | Attribute value |
| `bannerImage` | `String` | Yes | - | - | Attribute value |
| `iconName` | `String` | Yes | - | - | Attribute value |
| `parentId` | `String` | Yes | - | - | Foreign key reference to parent |
| `sortOrder` | `Int` | No | `0` | - | Attribute value |
| `isFeatured` | `Boolean` | No | `false` | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `parent (Category?)`, `children (Category[])`, `products (Product[])`

---

#### Table: `products` (Model: `Product`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `categoryId` | `String` | No | - | - | Foreign key reference to category |
| `name` | `String` | No | - | - | Attribute value |
| `slug` | `String` | No | - | **UNIQUE** | Attribute value |
| `description` | `String` | No | - | - | Attribute value |
| `images` | `String[]` | No | - | - | Attribute value |
| `packageImages` | `String[]` | No | `[]` | - | Attribute value |
| `barcode` | `String` | Yes | - | **UNIQUE** | Unique business identifier code |
| `brand` | `String` | Yes | - | - | Attribute value |
| `brandAliases` | `String[]` | No | `[]` | - | Attribute value |
| `searchKeywords` | `String[]` | No | `[]` | - | Attribute value |
| `isOrganic` | `Boolean` | No | `false` | - | Attribute value |
| `tags` | `String[]` | No | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([storeId, categoryId])`, `@@index([brand])`, `@@index([createdAt])`

**Relational Links:** `store (Store)`, `category (Category)`, `variants (ProductVariant[])`, `reviews (Review[])`, `favorites (Favorite[])`, `wishlists (Wishlist[])`, `recentlyViewed (RecentlyViewed[])`, `aiInsight (ProductAiInsight?)`, `referenceImages (ProductReferenceImage[])`

---

#### Table: `product_variants` (Model: `ProductVariant`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `unitName` | `String` | No | - | - | Attribute value |
| `price` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `mrp` | `Float` | No | - | - | Attribute value |
| `sku` | `String` | No | - | **UNIQUE** | Attribute value |
| `isAvailable` | `Boolean` | No | `true` | - | Attribute value |

**Indexes & Constraints:**
- Indexes: `@@index([productId, isAvailable])`, `@@index([price])`

**Relational Links:** `product (Product)`, `inventories (Inventory[])`, `orderItems (OrderItem[])`, `stockAlerts (StockAlert[])`

---

#### Table: `inventories` (Model: `Inventory`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `variantId` | `String` | No | - | - | Foreign key reference to variant |
| `stockQuantity` | `Int` | No | `0` | - | Inventory count unit |
| `reservedQuantity` | `Int` | No | `0` | - | Inventory count unit |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Composite Uniques: `@@unique([storeId, variantId])`
- Indexes: `@@index([storeId])`, `@@index([variantId])`, `@@index([stockQuantity])`

**Relational Links:** `store (Store)`, `variant (ProductVariant)`

---

#### Table: `store_settings` (Model: `StoreSettings`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | **UNIQUE** | Foreign key reference to store |
| `isOpen` | `Boolean` | No | `true` | - | Attribute value |
| `businessHours` | `Json` | No | - | - | Attribute value |
| `holidaySchedule` | `Json` | Yes | - | - | Attribute value |
| `deliveryRadiusKm` | `Float` | No | `5.0` | - | Attribute value |
| `minOrderValue` | `Float` | No | `149.0` | - | Attribute value |
| `maxDeliveryDistanceKm` | `Float` | No | `10.0` | - | Attribute value |
| `storeCapacityPerHour` | `Int` | No | `60` | - | Attribute value |
| `orderCutoffTime` | `String` | No | `"21:30"` | - | Attribute value |
| `isMaintenanceMode` | `Boolean` | No | `false` | - | Attribute value |
| `maintenanceMessage` | `String` | Yes | - | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `store (Store)`

---

#### Table: `banners` (Model: `Banner`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `title` | `String` | No | - | - | Attribute value |
| `subtitle` | `String` | Yes | - | - | Attribute value |
| `imageUrl` | `String` | No | - | - | Attribute value |
| `targetType` | `String` | No | `"CATEGORY"` | - | Attribute value |
| `targetValue` | `String` | No | - | - | Attribute value |
| `position` | `Int` | No | `0` | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `startDate` | `DateTime` | No | `now(` | - | Attribute value |
| `endDate` | `DateTime` | Yes | - | - | Attribute value |
| `badge` | `String` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([isActive, position])`

---

### 2. User Identity, Authentication & Security

#### Table: `users` (Model: `User`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `phoneNumber` | `String` | No | - | **UNIQUE** | E.164 normalized phone number |
| `email` | `String` | Yes | - | **UNIQUE** | User RFC-5322 email address |
| `fullName` | `String` | No | - | - | Attribute value |
| `passwordHash` | `String` | Yes | - | - | Attribute value |
| `role` | `Role` | No | `CUSTOMER` | - | Attribute value |
| `avatarUrl` | `String` | Yes | - | - | Attribute value |
| `isVerified` | `Boolean` | No | `false` | - | Attribute value |
| `emailVerificationToken` | `String` | Yes | - | **UNIQUE** | User RFC-5322 email address |
| `emailVerificationExpires` | `DateTime` | Yes | - | - | User RFC-5322 email address |
| `passwordResetToken` | `String` | Yes | - | **UNIQUE** | Cryptographic / security hash token |
| `passwordResetExpires` | `DateTime` | Yes | - | - | Attribute value |
| `mfaEnabled` | `Boolean` | No | `false` | - | Attribute value |
| `mfaType` | `String` | Yes | - | - | Attribute value |
| `mfaSecret` | `String` | Yes | - | - | Attribute value |
| `mfaBackupCodes` | `String[]` | No | `[]` | - | Unique business identifier code |
| `failedLoginAttempts` | `Int` | No | `0` | - | Attribute value |
| `lockoutUntil` | `DateTime` | Yes | - | - | Attribute value |
| `lastLoginAt` | `DateTime` | Yes | - | - | Attribute value |
| `lastPasswordChange` | `DateTime` | Yes | - | - | Attribute value |
| `termsAccepted` | `Boolean` | No | `true` | - | Attribute value |
| `privacyAccepted` | `Boolean` | No | `true` | - | Attribute value |
| `marketingConsent` | `Boolean` | No | `false` | - | Attribute value |
| `referralCode` | `String` | Yes | - | - | Unique business identifier code |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `addresses (Address[])`, `orders (Order[])`, `deliveries (Order[])`, `wallet (Wallet?)`, `reviews (Review[])`, `impact (UserImpact?)`, `badges (UserBadge[])`, `tickets (SupportTicket[])`, `stockAlerts (StockAlert[])`, `aiSessions (AiConversationSession[])`, `wishlist (Wishlist[])`, `favorites (Favorite[])`, `recentlyViewed (RecentlyViewed[])`, `deviceSessions (DeviceSession[])`, `otpVerifications (OtpVerification[])`, `securityAuditLogs (SecurityAuditLog[])`, `passwordHistories (PasswordHistory[])`, `preferenceProfile (UserPreferenceProfile?)`, `voiceSessions (VoiceSession[])`, `voiceLogs (VoiceCommandLog[])`, `voiceSettings (VoiceSettings?)`, `imageSearchLogs (ImageSearchLog[])`, `groceryLists (GroceryList[])`, `predictiveItems (PredictiveReorderItem[])`, `personalizedOffers (PersonalizedOffer[])`, `cart (Cart?)`, `couponRedemptions (CouponRedemption[])`, `notifications (InAppNotification[])`

---

#### Table: `addresses` (Model: `Address`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `label` | `String` | No | - | - | Attribute value |
| `houseNo` | `String` | No | - | - | Attribute value |
| `street` | `String` | No | - | - | Attribute value |
| `landmark` | `String` | Yes | - | - | Attribute value |
| `city` | `String` | No | - | - | Attribute value |
| `pincode` | `String` | No | - | - | Unique business identifier code |
| `latitude` | `Float` | No | - | - | Attribute value |
| `longitude` | `Float` | No | - | - | Attribute value |
| `isDefault` | `Boolean` | No | `false` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`, `orders (Order[])`

---

#### Table: `device_sessions` (Model: `DeviceSession`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `deviceId` | `String` | No | - | - | Foreign key reference to device |
| `deviceName` | `String` | Yes | - | - | Attribute value |
| `platform` | `String` | Yes | - | - | Attribute value |
| `osVersion` | `String` | Yes | - | - | Attribute value |
| `ipAddress` | `String` | Yes | - | - | Attribute value |
| `location` | `String` | Yes | - | - | Attribute value |
| `refreshTokenHash` | `String` | No | - | **UNIQUE** | Cryptographic / security hash token |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `lastActive` | `DateTime` | No | `now(` | - | Attribute value |
| `expiresAt` | `DateTime` | No | `now(` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Relational Links:** `user (User)`

---

#### Table: `otp_verifications` (Model: `OtpVerification`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `identifier` | `String` | No | - | - | Attribute value |
| `otpHash` | `String` | No | - | - | Attribute value |
| `type` | `String` | No | - | - | Attribute value |
| `attempts` | `Int` | No | `0` | - | Attribute value |
| `maxAttempts` | `Int` | No | `3` | - | Attribute value |
| `expiresAt` | `DateTime` | No | - | - | Attribute value |
| `resendAfter` | `DateTime` | No | - | - | Attribute value |
| `consumedAt` | `DateTime` | Yes | - | - | Attribute value |
| `ipAddress` | `String` | Yes | - | - | Attribute value |
| `otpCountThisHour` | `Int` | No | `0` | - | Attribute value |
| `otpCountToday` | `Int` | No | `0` | - | Attribute value |
| `userId` | `String` | Yes | - | - | Foreign key reference to user |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([identifier, type])`

**Relational Links:** `user (User?)`

---

#### Table: `security_audit_logs` (Model: `SecurityAuditLog`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | Yes | - | - | Foreign key reference to user |
| `event` | `String` | No | - | - | Attribute value |
| `ipAddress` | `String` | Yes | - | - | Attribute value |
| `userAgent` | `String` | Yes | - | - | Attribute value |
| `metadata` | `Json` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId, event])`, `@@index([createdAt])`

**Relational Links:** `user (User?)`

---

#### Table: `password_histories` (Model: `PasswordHistory`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `passwordHash` | `String` | No | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Relational Links:** `user (User)`

---

#### Table: `employee_profiles` (Model: `EmployeeProfile`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `storeId` | `String` | Yes | - | - | Foreign key reference to store |
| `warehouseId` | `String` | Yes | - | - | Foreign key reference to warehouse |
| `department` | `String` | No | - | - | Attribute value |
| `designation` | `String` | No | - | - | Attribute value |
| `shiftHours` | `String` | No | `"08:00 - 17:00"` | - | Attribute value |
| `attendance` | `Json` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

### 3. Cart, Ordering & Invoicing

#### Table: `carts` (Model: `Cart`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`, `items (CartItem[])`

---

#### Table: `cart_items` (Model: `CartItem`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `cartId` | `String` | No | - | - | Foreign key reference to cart |
| `variantId` | `String` | No | - | - | Foreign key reference to variant |
| `productName` | `String` | No | - | - | Attribute value |
| `unitName` | `String` | No | - | - | Attribute value |
| `price` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `quantity` | `Int` | No | `1` | - | Inventory count unit |
| `imageUrl` | `String` | Yes | - | - | Attribute value |
| `isSavedForLater` | `Boolean` | No | `false` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([cartId])`, `@@index([variantId])`

**Relational Links:** `cart (Cart)`

---

#### Table: `orders` (Model: `Order`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `orderNumber` | `String` | No | - | **UNIQUE** | Attribute value |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `addressId` | `String` | No | - | - | Foreign key reference to address |
| `deliveryPartnerId` | `String` | Yes | - | - | Foreign key reference to deliveryPartner |
| `subtotal` | `Float` | No | - | - | Attribute value |
| `deliveryFee` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `discount` | `Float` | No | - | - | Attribute value |
| `totalAmount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `status` | `OrderStatus` | No | `CREATED` | - | State machine status flag |
| `paymentMethod` | `PaymentMethod` | No | - | - | Attribute value |
| `paymentStatus` | `PaymentStatus` | No | `PENDING` | - | State machine status flag |
| `estimatedArrivalMins` | `Int` | No | `10` | - | Attribute value |
| `deliveryNotes` | `String` | Yes | - | - | Attribute value |
| `cancellationReason` | `String` | Yes | - | - | Attribute value |
| `cancelledAt` | `DateTime` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId, status])`, `@@index([storeId, status])`, `@@index([createdAt])`, `@@index([status])`

**Relational Links:** `store (Store)`, `user (User)`, `address (Address)`, `deliveryPartner (User?)`, `items (OrderItem[])`, `payments (Payment[])`

---

#### Table: `order_items` (Model: `OrderItem`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `orderId` | `String` | No | - | - | Foreign key reference to order |
| `variantId` | `String` | No | - | - | Foreign key reference to variant |
| `productName` | `String` | No | - | - | Attribute value |
| `unitName` | `String` | No | - | - | Attribute value |
| `price` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `quantity` | `Int` | No | - | - | Inventory count unit |
| `totalPrice` | `Float` | No | - | - | Monetary amount in INR (₹) |

**Indexes & Constraints:**
- Indexes: `@@index([orderId])`, `@@index([variantId])`

**Relational Links:** `order (Order)`, `variant (ProductVariant)`

---

#### Table: `order_invoices` (Model: `OrderInvoice`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `orderId` | `String` | No | - | **UNIQUE** | Foreign key reference to order |
| `invoiceNumber` | `String` | No | - | **UNIQUE** | Attribute value |
| `pdfUrl` | `String` | No | - | - | Attribute value |
| `taxAmount` | `Float` | No | `0.0` | - | Monetary amount in INR (₹) |
| `totalAmount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `issuedAt` | `DateTime` | No | `now(` | - | Attribute value |

---

### 4. Payments, Wallet & Promotions

#### Table: `payments` (Model: `Payment`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `orderId` | `String` | No | - | - | Foreign key reference to order |
| `razorpayOrderId` | `String` | Yes | - | - | Foreign key reference to razorpayOrder |
| `transactionRef` | `String` | Yes | - | - | Attribute value |
| `amount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `method` | `PaymentMethod` | No | - | - | Attribute value |
| `status` | `PaymentStatus` | No | `PENDING` | - | State machine status flag |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([orderId])`, `@@index([status])`

**Relational Links:** `order (Order)`

---

#### Table: `wallets` (Model: `Wallet`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `balance` | `Float` | No | `0` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`, `transactions (WalletTransaction[])`

---

#### Table: `wallet_transactions` (Model: `WalletTransaction`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `walletId` | `String` | No | - | - | Foreign key reference to wallet |
| `amount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `type` | `String` | No | - | - | Attribute value |
| `description` | `String` | No | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Relational Links:** `wallet (Wallet)`

---

#### Table: `coupons` (Model: `Coupon`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `code` | `String` | No | - | **UNIQUE** | Unique business identifier code |
| `title` | `String` | No | `"Promotional Offer"` | - | Attribute value |
| `description` | `String` | No | `"Special discount coupon"` | - | Attribute value |
| `discountType` | `String` | No | - | - | Attribute value |
| `discountValue` | `Float` | No | - | - | Attribute value |
| `minOrderAmount` | `Float` | No | `0` | - | Monetary amount in INR (₹) |
| `maxDiscount` | `Float` | Yes | - | - | Attribute value |
| `category` | `String` | Yes | - | - | Attribute value |
| `startDate` | `DateTime` | No | `now(` | - | Attribute value |
| `expiresAt` | `DateTime` | No | - | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `usageLimitPerUser` | `Int` | No | `1` | - | Attribute value |
| `totalUsageLimit` | `Int` | No | `10000` | - | Attribute value |
| `usedCount` | `Int` | No | `0` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `now(` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([code])`, `@@index([isActive])`

**Relational Links:** `redemptions (CouponRedemption[])`

---

#### Table: `coupon_redemptions` (Model: `CouponRedemption`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `couponId` | `String` | No | - | - | Foreign key reference to coupon |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `orderId` | `String` | Yes | - | - | Foreign key reference to order |
| `savedAmount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `redeemedAt` | `DateTime` | No | `now(` | - | Attribute value |

**Indexes & Constraints:**
- Indexes: `@@index([couponId])`, `@@index([userId])`

**Relational Links:** `coupon (Coupon)`, `user (User)`

---

### 5. Customer Engagement, CRM & Social

#### Table: `reviews` (Model: `Review`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `rating` | `Int` | No | - | - | Attribute value |
| `comment` | `String` | Yes | - | - | Attribute value |
| `isVerifiedPurchase` | `Boolean` | No | `false` | - | Attribute value |
| `status` | `String` | No | `"APPROVED"` | - | State machine status flag |
| `helpfulCount` | `Int` | No | `0` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `now(` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([productId, status, rating])`, `@@index([userId])`

**Relational Links:** `product (Product)`, `user (User)`

---

#### Table: `favorites` (Model: `Favorite`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Composite Uniques: `@@unique([userId, productId])`
- Indexes: `@@index([userId])`, `@@index([productId])`

**Relational Links:** `user (User)`, `product (Product)`

---

#### Table: `wishlists` (Model: `Wishlist`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Composite Uniques: `@@unique([userId, productId])`

**Relational Links:** `user (User)`, `product (Product)`

---

#### Table: `recently_viewed` (Model: `RecentlyViewed`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `viewedAt` | `DateTime` | No | `now(` | - | Attribute value |

**Indexes & Constraints:**
- Composite Uniques: `@@unique([userId, productId])`

**Relational Links:** `user (User)`, `product (Product)`

---

#### Table: `grocery_lists` (Model: `GroceryList`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `name` | `String` | No | - | - | Attribute value |
| `type` | `String` | No | `"CUSTOM"` | - | Attribute value |
| `items` | `Json` | No | - | - | Attribute value |
| `isRecurring` | `Boolean` | No | `false` | - | Attribute value |
| `reminderFrequency` | `String` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`

**Relational Links:** `user (User)`

---

#### Table: `user_impacts` (Model: `UserImpact`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `impactPoints` | `Int` | No | `0` | - | Attribute value |
| `plasticSavedKg` | `Float` | No | `0` | - | Attribute value |
| `co2ReducedKg` | `Float` | No | `0` | - | Attribute value |
| `paperBagsSaved` | `Int` | No | `0` | - | Attribute value |
| `ecoDeliveries` | `Int` | No | `0` | - | Unique business identifier code |
| `greenOrders` | `Int` | No | `0` | - | Attribute value |
| `monthlyProgress` | `Float` | No | `0` | - | Attribute value |
| `yearlyProgress` | `Float` | No | `0` | - | Attribute value |
| `treesEquivalent` | `Float` | No | `0` | - | Attribute value |
| `level` | `String` | No | `"Earth Champion"` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`

---

#### Table: `user_badges` (Model: `UserBadge`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `title` | `String` | No | - | - | Attribute value |
| `tier` | `String` | No | - | - | Attribute value |
| `iconName` | `String` | No | - | - | Attribute value |
| `earnedAt` | `DateTime` | No | `now(` | - | Attribute value |

**Relational Links:** `user (User)`

---

#### Table: `in_app_notifications` (Model: `InAppNotification`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `title` | `String` | No | - | - | Attribute value |
| `message` | `String` | No | - | - | Attribute value |
| `type` | `String` | No | `"ORDER"` | - | Attribute value |
| `orderId` | `String` | Yes | - | - | Foreign key reference to order |
| `isRead` | `Boolean` | No | `false` | - | Attribute value |
| `data` | `Json` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId, isRead])`, `@@index([createdAt])`

**Relational Links:** `user (User)`

---

#### Table: `customer_management_notes` (Model: `CustomerManagementNote`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `adminId` | `String` | No | - | - | Foreign key reference to admin |
| `note` | `String` | No | - | - | Attribute value |
| `tags` | `String[]` | No | `["LOYAL"]` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`

---

### 6. Customer Support & Communication

#### Table: `support_tickets` (Model: `SupportTicket`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `subject` | `String` | No | - | - | Attribute value |
| `status` | `String` | No | `"OPEN"` | - | State machine status flag |
| `rating` | `Int` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId, status])`, `@@index([createdAt])`

**Relational Links:** `user (User)`, `messages (ChatMessage[])`

---

#### Table: `chat_messages` (Model: `ChatMessage`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `ticketId` | `String` | No | - | - | Foreign key reference to ticket |
| `senderId` | `String` | No | - | - | Foreign key reference to sender |
| `senderName` | `String` | No | - | - | Attribute value |
| `text` | `String` | No | - | - | Attribute value |
| `isAgent` | `Boolean` | No | `false` | - | Attribute value |
| `attachmentUrl` | `String` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Relational Links:** `ticket (SupportTicket)`

---

#### Table: `stock_alerts` (Model: `StockAlert`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `variantId` | `String` | No | - | - | Foreign key reference to variant |
| `isEnabled` | `Boolean` | No | `true` | - | Attribute value |
| `status` | `String` | No | `"OUT_OF_STOCK"` | - | State machine status flag |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Composite Uniques: `@@unique([userId, variantId])`

**Relational Links:** `user (User)`, `variant (ProductVariant)`

---

### 7. Multimodal AI & Discovery Subsystem

#### Table: `ai_conversation_sessions` (Model: `AiConversationSession`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `currentRoute` | `String` | Yes | - | - | Attribute value |
| `contextData` | `Json` | Yes | - | - | Attribute value |
| `status` | `String` | No | `"ACTIVE"` | - | State machine status flag |
| `activeProvider` | `String` | No | `"GEMINI"` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`, `messages (AiChatMessage[])`, `auditLogs (AiAuditLog[])`

---

#### Table: `ai_chat_messages` (Model: `AiChatMessage`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `sessionId` | `String` | No | - | - | Foreign key reference to session |
| `senderRole` | `String` | No | - | - | Attribute value |
| `content` | `String` | No | - | - | Attribute value |
| `toolCalls` | `Json` | Yes | - | - | Attribute value |
| `cardType` | `String` | Yes | - | - | Attribute value |
| `cardData` | `Json` | Yes | - | - | Attribute value |
| `tokensUsed` | `Int` | Yes | - | - | Cryptographic / security hash token |
| `latencyMs` | `Int` | Yes | - | - | Attribute value |
| `providerUsed` | `String` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Relational Links:** `session (AiConversationSession)`

---

#### Table: `ai_audit_logs` (Model: `AiAuditLog`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `sessionId` | `String` | Yes | - | - | Foreign key reference to session |
| `action` | `String` | No | - | - | Attribute value |
| `toolName` | `String` | No | - | - | Attribute value |
| `parameters` | `Json` | Yes | - | - | Attribute value |
| `ipAddress` | `String` | Yes | - | - | Attribute value |
| `status` | `String` | No | `"SUCCESS"` | - | State machine status flag |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Relational Links:** `session (AiConversationSession?)`

---

#### Table: `ai_analytics_metrics` (Model: `AiAnalyticsMetric`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `provider` | `String` | No | - | - | Attribute value |
| `model` | `String` | No | - | - | Attribute value |
| `promptTokens` | `Int` | No | `0` | - | Cryptographic / security hash token |
| `completionTokens` | `Int` | No | `0` | - | Cryptographic / security hash token |
| `costUsd` | `Float` | No | `0.0` | - | Attribute value |
| `latencyMs` | `Int` | No | `0` | - | Attribute value |
| `success` | `Boolean` | No | `true` | - | Attribute value |
| `feedbackRating` | `Int` | Yes | - | - | Monetary amount in INR (₹) |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

#### Table: `prompt_templates` (Model: `PromptTemplate`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `key` | `String` | No | - | **UNIQUE** | Attribute value |
| `name` | `String` | No | - | - | Attribute value |
| `template` | `String` | No | - | - | Attribute value |
| `description` | `String` | Yes | - | - | Attribute value |
| `version` | `Int` | No | `1` | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

#### Table: `search_analytics` (Model: `SearchAnalytics`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `query` | `String` | No | - | - | Attribute value |
| `intent` | `String` | Yes | - | - | Attribute value |
| `resultsCount` | `Int` | No | `0` | - | Attribute value |
| `userId` | `String` | Yes | - | - | Foreign key reference to user |
| `clickedProductId` | `String` | Yes | - | - | Foreign key reference to clickedProduct |
| `latencyMs` | `Int` | No | `0` | - | Attribute value |
| `isSuccess` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([query])`, `@@index([createdAt])`

---

#### Table: `trending_searches` (Model: `TrendingSearch`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `keyword` | `String` | No | - | **UNIQUE** | Attribute value |
| `category` | `String` | Yes | - | - | Attribute value |
| `searchCount` | `Int` | No | `1` | - | Attribute value |
| `isFeatured` | `Boolean` | No | `false` | - | Attribute value |
| `sortOrder` | `Int` | No | `0` | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

#### Table: `blocked_queries` (Model: `BlockedQuery`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `pattern` | `String` | No | - | **UNIQUE** | Attribute value |
| `reason` | `String` | Yes | - | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

#### Table: `product_ai_insights` (Model: `ProductAiInsight`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `productId` | `String` | No | - | **UNIQUE** | Foreign key reference to product |
| `benefits` | `String[]` | No | `[]` | - | Attribute value |
| `usage` | `String` | Yes | - | - | Attribute value |
| `storage` | `String` | Yes | - | - | Attribute value |
| `healthyChoice` | `Boolean` | No | `false` | - | Attribute value |
| `healthScore` | `Float` | No | `8.5` | - | Attribute value |
| `bestFor` | `String[]` | No | `[]` | - | Attribute value |
| `recipeSuggestions` | `Json` | Yes | - | - | Attribute value |
| `servingSuggestions` | `String` | Yes | - | - | Attribute value |
| `suitableAge` | `String` | Yes | - | - | Attribute value |
| `nutritionalSummary` | `Json` | Yes | - | - | Attribute value |
| `comparisonPoints` | `Json` | Yes | - | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `product (Product)`

---

#### Table: `user_preference_profiles` (Model: `UserPreferenceProfile`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `favoriteCategories` | `String[]` | No | `[]` | - | Attribute value |
| `favoriteBrands` | `String[]` | No | `[]` | - | Attribute value |
| `dietaryPreferences` | `String[]` | No | `[]` | - | Attribute value |
| `budgetTier` | `String` | No | `"BALANCED"` | - | Attribute value |
| `shoppingFrequency` | `String` | No | `"WEEKLY"` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`

---

#### Table: `image_search_logs` (Model: `ImageSearchLog`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `imageUrl` | `String` | No | - | - | Attribute value |
| `imageHash` | `String` | Yes | - | - | Attribute value |
| `detectedProducts` | `Json` | Yes | - | - | Attribute value |
| `ocrText` | `String` | Yes | - | - | Attribute value |
| `recipeName` | `String` | Yes | - | - | Attribute value |
| `confidenceScore` | `Float` | No | `95.0` | - | Attribute value |
| `latencyMs` | `Int` | No | `0` | - | Attribute value |
| `isSuccess` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`, `@@index([createdAt])`

**Relational Links:** `user (User)`

---

#### Table: `product_reference_images` (Model: `ProductReferenceImage`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `imageUrl` | `String` | No | - | - | Attribute value |
| `angle` | `String` | No | `"FRONT"` | - | Attribute value |
| `isPrimary` | `Boolean` | No | `false` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([productId])`

**Relational Links:** `product (Product)`

---

#### Table: `visual_ai_analytics_metrics` (Model: `VisualAiAnalyticsMetric`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `totalSearches` | `Int` | No | `0` | - | Attribute value |
| `successfulMatches` | `Int` | No | `0` | - | Attribute value |
| `failedMatches` | `Int` | No | `0` | - | Attribute value |
| `avgLatencyMs` | `Int` | No | `0` | - | Attribute value |
| `ocrSuccessRate` | `Float` | No | `98.5` | - | Attribute value |
| `recipeDetectionRate` | `Float` | No | `94.2` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([createdAt])`

---

#### Table: `predictive_reorder_items` (Model: `PredictiveReorderItem`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `productId` | `String` | No | - | - | Foreign key reference to product |
| `averageDaysInterval` | `Int` | No | `7` | - | Attribute value |
| `lastPurchasedAt` | `DateTime` | No | `now(` | - | Attribute value |
| `nextPredictedPurchaseAt` | `DateTime` | No | - | - | Attribute value |
| `runOutLikelihood` | `Float` | No | `0.85` | - | Attribute value |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`

**Relational Links:** `user (User)`

---

#### Table: `personalized_offers` (Model: `PersonalizedOffer`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `code` | `String` | No | - | **UNIQUE** | Unique business identifier code |
| `title` | `String` | No | - | - | Attribute value |
| `discountPercent` | `Float` | No | `15.0` | - | Attribute value |
| `maxDiscount` | `Float` | No | `150.0` | - | Attribute value |
| `targetReason` | `String` | No | - | - | Attribute value |
| `expiresAt` | `DateTime` | No | - | - | Attribute value |
| `isRedeemed` | `Boolean` | No | `false` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`

**Relational Links:** `user (User)`

---

#### Table: `personalization_rules` (Model: `PersonalizationRule`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `targetSegment` | `String` | No | `"ALL"` | - | Attribute value |
| `weightScore` | `Float` | No | `1.0` | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

#### Table: `ai_copilot_query_logs` (Model: `AiCopilotQueryLog`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `query` | `String` | No | - | - | Attribute value |
| `resolvedIntent` | `String` | Yes | - | - | Attribute value |
| `responseSummary` | `String` | No | - | - | Attribute value |
| `latencyMs` | `Int` | No | `0` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`, `@@index([createdAt])`

---

### 8. Voice Shopping Subsystem

#### Table: `voice_sessions` (Model: `VoiceSession`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `locale` | `String` | No | `"en_IN"` | - | Attribute value |
| `currentRoute` | `String` | No | `"/home"` | - | Attribute value |
| `status` | `String` | No | `"ACTIVE"` | - | State machine status flag |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`, `logs (VoiceCommandLog[])`

---

#### Table: `voice_command_logs` (Model: `VoiceCommandLog`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `sessionId` | `String` | No | - | - | Foreign key reference to session |
| `userId` | `String` | No | - | - | Foreign key reference to user |
| `transcription` | `String` | No | - | - | Attribute value |
| `detectedLanguage` | `String` | No | `"en_IN"` | - | Attribute value |
| `intent` | `String` | Yes | - | - | Attribute value |
| `actionTaken` | `String` | Yes | - | - | Attribute value |
| `audioUrl` | `String` | Yes | - | - | Attribute value |
| `latencyMs` | `Int` | No | `0` | - | Attribute value |
| `isSuccess` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([userId])`, `@@index([createdAt])`

**Relational Links:** `session (VoiceSession)`, `user (User)`

---

#### Table: `voice_settings` (Model: `VoiceSettings`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `voiceEnabled` | `Boolean` | No | `true` | - | Attribute value |
| `preferredLanguage` | `String` | No | `"en_IN"` | - | Attribute value |
| `preferredVoiceGender` | `String` | No | `"FEMALE"` | - | Attribute value |
| `speechSpeed` | `Float` | No | `1.0` | - | Attribute value |
| `autoSpeak` | `Boolean` | No | `true` | - | Attribute value |
| `privacyMode` | `Boolean` | No | `false` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `user (User)`

---

#### Table: `voice_analytics_metrics` (Model: `VoiceAnalyticsMetric`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `language` | `String` | No | `"en_IN"` | - | Attribute value |
| `intent` | `String` | Yes | - | - | Attribute value |
| `sttLatencyMs` | `Int` | No | `0` | - | Attribute value |
| `aiLatencyMs` | `Int` | No | `0` | - | Attribute value |
| `ttsLatencyMs` | `Int` | No | `0` | - | Attribute value |
| `isSuccess` | `Boolean` | No | `true` | - | Attribute value |
| `failureReason` | `String` | Yes | - | - | Attribute value |
| `rating` | `Int` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([language])`, `@@index([createdAt])`

---

### 9. Supply Chain, Procurement & PO

#### Table: `batch_managements` (Model: `BatchManagement`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `variantId` | `String` | No | - | - | Foreign key reference to variant |
| `batchNumber` | `String` | No | - | - | Attribute value |
| `shelfLocation` | `String` | No | `"A1-S2"` | - | Attribute value |
| `manufacturedAt` | `DateTime` | Yes | - | - | Attribute value |
| `expiresAt` | `DateTime` | No | - | - | Attribute value |
| `quantity` | `Int` | No | `100` | - | Inventory count unit |
| `damagedQuantity` | `Int` | No | `0` | - | Inventory count unit |
| `reorderLevel` | `Int` | No | `20` | - | Attribute value |
| `costPrice` | `Float` | No | `40.0` | - | Monetary amount in INR (₹) |
| `sellingPrice` | `Float` | No | `56.0` | - | Monetary amount in INR (₹) |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([storeId])`, `@@index([variantId])`, `@@index([expiresAt])`

---

#### Table: `inventory_audits` (Model: `InventoryAudit`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `auditedBy` | `String` | No | - | - | Attribute value |
| `auditDate` | `DateTime` | No | `now(` | - | Attribute value |
| `findings` | `Json` | No | - | - | Attribute value |
| `status` | `String` | No | `"COMPLETED"` | - | State machine status flag |
| `notes` | `String` | Yes | - | - | Attribute value |

**Indexes & Constraints:**
- Indexes: `@@index([storeId])`

---

#### Table: `suppliers` (Model: `Supplier`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `code` | `String` | No | - | **UNIQUE** | Unique business identifier code |
| `contactPerson` | `String` | No | - | - | Attribute value |
| `phone` | `String` | No | - | - | E.164 normalized phone number |
| `email` | `String` | Yes | - | - | User RFC-5322 email address |
| `address` | `String` | No | - | - | Attribute value |
| `gstin` | `String` | Yes | - | - | Attribute value |
| `paymentTerms` | `String` | No | `"NET_30"` | - | Attribute value |
| `rating` | `Float` | No | `4.8` | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `purchaseOrders (PurchaseOrder[])`

---

#### Table: `purchase_orders` (Model: `PurchaseOrder`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `poNumber` | `String` | No | - | **UNIQUE** | Attribute value |
| `supplierId` | `String` | No | - | - | Foreign key reference to supplier |
| `status` | `String` | No | `"APPROVED"` | - | State machine status flag |
| `totalAmount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `items` | `Json` | No | - | - | Attribute value |
| `expectedDeliveryAt` | `DateTime` | No | - | - | Attribute value |
| `receivedAt` | `DateTime` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([supplierId])`

**Relational Links:** `supplier (Supplier)`, `goodsReceiptNotes (GoodsReceiptNote[])`

---

#### Table: `goods_receipt_notes` (Model: `GoodsReceiptNote`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `grnNumber` | `String` | No | - | **UNIQUE** | Attribute value |
| `purchaseOrderId` | `String` | No | - | - | Foreign key reference to purchaseOrder |
| `receivedBy` | `String` | No | - | - | Attribute value |
| `items` | `Json` | No | - | - | Attribute value |
| `invoiceNumber` | `String` | Yes | - | - | Attribute value |
| `invoiceUrl` | `String` | Yes | - | - | Attribute value |
| `receivedAt` | `DateTime` | No | `now(` | - | Attribute value |

**Relational Links:** `purchaseOrder (PurchaseOrder)`

---

#### Table: `vendor_payments` (Model: `VendorPayment`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `supplierId` | `String` | No | - | - | Foreign key reference to supplier |
| `amount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `paymentMethod` | `String` | No | `"BANK_TRANSFER"` | - | Attribute value |
| `referenceNumber` | `String` | No | - | **UNIQUE** | Attribute value |
| `paidAt` | `DateTime` | No | `now(` | - | Attribute value |
| `status` | `String` | No | `"PAID"` | - | State machine status flag |

**Indexes & Constraints:**
- Indexes: `@@index([supplierId])`

---

### 10. Financial Accounting & Settlement

#### Table: `financial_ledgers` (Model: `FinancialLedger`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `type` | `String` | No | - | - | Attribute value |
| `amount` | `Float` | No | - | - | Monetary amount in INR (₹) |
| `category` | `String` | No | - | - | Attribute value |
| `referenceId` | `String` | Yes | - | - | Foreign key reference to reference |
| `notes` | `String` | Yes | - | - | Attribute value |
| `entryDate` | `DateTime` | No | `now(` | - | Attribute value |

**Indexes & Constraints:**
- Indexes: `@@index([storeId])`, `@@index([type])`

---

#### Table: `daily_closings` (Model: `DailyClosing`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `storeId` | `String` | No | - | - | Foreign key reference to store |
| `closingDate` | `DateTime` | No | `now(` | - | Attribute value |
| `totalSales` | `Float` | No | - | - | Attribute value |
| `cashCollected` | `Float` | No | - | - | Attribute value |
| `onlineSales` | `Float` | No | - | - | Attribute value |
| `expenses` | `Float` | No | - | - | Attribute value |
| `netProfit` | `Float` | No | - | - | Attribute value |
| `closedBy` | `String` | No | - | - | Attribute value |

**Indexes & Constraints:**
- Indexes: `@@index([storeId])`

---

### 11. Logistics, Delivery Fleet & Warehouses

#### Table: `delivery_partner_profiles` (Model: `DeliveryPartnerProfile`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `userId` | `String` | No | - | **UNIQUE** | Foreign key reference to user |
| `isOnline` | `Boolean` | No | `true` | - | Attribute value |
| `zone` | `String` | No | `"CENTRAL_ZONE"` | - | Attribute value |
| `totalDeliveries` | `Int` | No | `142` | - | Attribute value |
| `rating` | `Float` | No | `4.9` | - | Attribute value |
| `weeklyEarnings` | `Float` | No | `4850.0` | - | Attribute value |
| `onLeave` | `Boolean` | No | `false` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

#### Table: `delivery_zones` (Model: `DeliveryZone`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `city` | `String` | No | - | - | Attribute value |
| `pincodes` | `String[]` | No | - | - | Unique business identifier code |
| `minOrderValue` | `Float` | No | `149.0` | - | Attribute value |
| `baseDeliveryFee` | `Float` | No | `25.0` | - | Monetary amount in INR (₹) |
| `distanceRules` | `Json` | No | - | - | Attribute value |
| `zoneManagerId` | `String` | Yes | - | - | Foreign key reference to zoneManager |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([city])`

---

#### Table: `fleet_vehicles` (Model: `FleetVehicle`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `driverId` | `String` | Yes | - | - | Foreign key reference to driver |
| `vehicleType` | `String` | No | `"EV_SCOOTER"` | - | Attribute value |
| `registrationNo` | `String` | No | - | **UNIQUE** | Attribute value |
| `fuelType` | `String` | No | `"ELECTRIC"` | - | Attribute value |
| `batteryPercent` | `Int` | No | `92` | - | Attribute value |
| `status` | `String` | No | `"ACTIVE"` | - | State machine status flag |
| `currentLat` | `Float` | Yes | - | - | Attribute value |
| `currentLng` | `Float` | Yes | - | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

#### Table: `warehouses` (Model: `Warehouse`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `code` | `String` | No | - | **UNIQUE** | Unique business identifier code |
| `city` | `String` | No | - | - | Attribute value |
| `address` | `String` | No | - | - | Attribute value |
| `latitude` | `Float` | No | - | - | Attribute value |
| `longitude` | `Float` | No | - | - | Attribute value |
| `capacitySqFt` | `Int` | No | `25000` | - | Attribute value |
| `storageZones` | `Json` | No | - | - | Attribute value |
| `shelfMap` | `Json` | No | - | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Relational Links:** `inventories (WarehouseInventory[])`

---

#### Table: `warehouse_inventories` (Model: `WarehouseInventory`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `warehouseId` | `String` | No | - | - | Foreign key reference to warehouse |
| `variantId` | `String` | No | - | - | Foreign key reference to variant |
| `quantity` | `Int` | No | `1000` | - | Inventory count unit |
| `reservedQuantity` | `Int` | No | `0` | - | Inventory count unit |
| `batchNumber` | `String` | No | `"BATCH-2026-001"` | - | Attribute value |
| `shelfLocation` | `String` | No | `"ZONE-A-RACK-04"` | - | Attribute value |
| `expiresAt` | `DateTime` | Yes | - | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Composite Uniques: `@@unique([warehouseId, variantId, batchNumber])`

**Relational Links:** `warehouse (Warehouse)`

---

#### Table: `inter_location_transfers` (Model: `InterLocationTransfer`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `transferNumber` | `String` | No | - | **UNIQUE** | Attribute value |
| `fromType` | `String` | No | - | - | Attribute value |
| `fromId` | `String` | No | - | - | Foreign key reference to from |
| `toType` | `String` | No | - | - | Attribute value |
| `toId` | `String` | No | - | - | Foreign key reference to to |
| `items` | `Json` | No | - | - | Attribute value |
| `status` | `String` | No | `"APPROVED"` | - | State machine status flag |
| `driverId` | `String` | Yes | - | - | Foreign key reference to driver |
| `trackingNumber` | `String` | Yes | - | - | Attribute value |
| `requestedBy` | `String` | No | `"CENTRAL_DISPATCH"` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([fromId])`, `@@index([toId])`

---

#### Table: `franchises` (Model: `Franchise`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `companyName` | `String` | No | - | - | Attribute value |
| `gstin` | `String` | No | - | **UNIQUE** | Attribute value |
| `franchiseOwnerId` | `String` | No | - | - | Foreign key reference to franchiseOwner |
| `city` | `String` | No | - | - | Attribute value |
| `commissionPercent` | `Float` | No | `8.5` | - | Attribute value |
| `revenueShareTerms` | `Json` | No | - | - | Attribute value |
| `status` | `String` | No | `"ACTIVE"` | - | State machine status flag |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

### 12. Enterprise Governance, Rules & Backups

#### Table: `business_documents` (Model: `BusinessDocument`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `title` | `String` | No | - | - | Attribute value |
| `type` | `String` | No | - | - | Attribute value |
| `fileUrl` | `String` | No | - | - | Attribute value |
| `fileSize` | `String` | No | `"250 KB"` | - | Attribute value |
| `uploadedBy` | `String` | No | `"STORE_OWNER"` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

#### Table: `business_insight_logs` (Model: `BusinessInsightLog`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `type` | `String` | No | - | - | Attribute value |
| `content` | `Json` | No | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

#### Table: `system_observability_metrics` (Model: `SystemObservabilityMetric`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `serviceName` | `String` | No | `"API_GATEWAY"` | - | Attribute value |
| `apiLatencyMs` | `Int` | No | `24` | - | Attribute value |
| `redisLatencyMs` | `Int` | No | `2` | - | Attribute value |
| `activeQueueJobs` | `Int` | No | `0` | - | Attribute value |
| `dbConnections` | `Int` | No | `12` | - | Attribute value |
| `cpuUsagePercent` | `Float` | No | `14.5` | - | Attribute value |
| `memoryUsageMb` | `Float` | No | `256.0` | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

**Indexes & Constraints:**
- Indexes: `@@index([createdAt])`

---

#### Table: `master_data_configs` (Model: `MasterDataConfig`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `key` | `String` | No | - | **UNIQUE** | Attribute value |
| `category` | `String` | No | `"SYSTEM"` | - | Attribute value |
| `value` | `Json` | No | - | - | Attribute value |
| `description` | `String` | Yes | - | - | Attribute value |
| `updatedBy` | `String` | No | `"ADMIN"` | - | Attribute value |
| `updatedAt` | `DateTime` | No | `updatedAt()` | - | Record last modified timestamp |

---

#### Table: `workflow_rules` (Model: `WorkflowRule`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `name` | `String` | No | - | - | Attribute value |
| `triggerEvent` | `String` | No | - | - | Attribute value |
| `conditionJson` | `Json` | No | - | - | Attribute value |
| `actionType` | `String` | No | - | - | Attribute value |
| `actionConfig` | `Json` | No | - | - | Attribute value |
| `isActive` | `Boolean` | No | `true` | - | Attribute value |
| `timesTriggered` | `Int` | No | `0` | - | Attribute value |
| `lastTriggeredAt` | `DateTime` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

#### Table: `integration_connections` (Model: `IntegrationConnection`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `providerName` | `String` | No | - | **UNIQUE** | Attribute value |
| `category` | `String` | No | `"PAYMENT"` | - | Attribute value |
| `status` | `String` | No | `"CONNECTED"` | - | State machine status flag |
| `apiEndpoint` | `String` | Yes | - | - | Attribute value |
| `apiKeyHash` | `String` | Yes | - | - | Attribute value |
| `lastSyncAt` | `DateTime` | No | `now(` | - | Attribute value |

---

#### Table: `disaster_recovery_backups` (Model: `DisasterRecoveryBackup`)

| Column | Type | Nullable | Default | Constraints | Description |
| :--- | :--- | :---: | :--- | :--- | :--- |
| `id` | `String` | No | `uuid(` | **PK** | Surrogate primary key UUID |
| `backupName` | `String` | No | - | **UNIQUE** | Attribute value |
| `backupType` | `String` | No | `"FULL_SNAPSHOT"` | - | Attribute value |
| `fileSize` | `String` | No | `"45.2 MB"` | - | Attribute value |
| `status` | `String` | No | `"COMPLETED"` | - | State machine status flag |
| `checksum` | `String` | Yes | - | - | Attribute value |
| `createdAt` | `DateTime` | No | `now(` | - | Record creation timestamp |

---

## 4. Indexing Strategy & Performance SLA

To ensure sub-250ms p95 latency targets under high-concurrency peak quick-commerce operations:

1. **High-Cardinality B-Tree Indexes**:
   - `users(phoneNumber)` and `users(email)`: Provides $O(1)$ lookups for authentication, OTP verification, and JWT session refresh.
   - `orders(userId, status)`: Enables sub-millisecond retrieval of active and historical orders on the customer mobile app.
   - `orders(storeId, status)`: Powers dark-store fulfillment pick-pack queues, filtering strictly by operational statuses (`CONFIRMED`, `PACKING`).
   - `inventories(storeId, variantId)`: Guarantees atomic stock lookups with a composite `@@unique` constraint, backing atomic checkouts.

2. **Temporal & Analytics Indexes**:
   - `orders(createdAt)`, `security_audit_logs(createdAt)`, `financial_ledgers(createdAt)`: Supports time-window aggregations and automated daily audit rollups.

3. **Spatial & Search Optimization**:
   - `stores(latitude, longitude)` and `delivery_zones(city)`: Enables geospatial dark-store dispatch and polygon containment calculations.
   - `products(brand)` and `products(storeId, categoryId)`: Maximizes cache hits during catalog grid navigation.
