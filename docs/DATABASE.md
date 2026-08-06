# 🗄️ PostgreSQL Database Schema Reference — Daily Basket

**Database Engine**: PostgreSQL 16  
**ORM**: Prisma ORM 5  
**Schema Path**: `services/api/prisma/schema.prisma`

---

## 1. Key Database Models & Enums

### User Roles (`Role`)
`CUSTOMER`, `ADMIN`, `STORE_MANAGER`, `INVENTORY_MANAGER`, `SUPPORT_EXECUTIVE`, `FINANCE_MANAGER`, `DELIVERY_PARTNER`, `BUSINESS_OWNER`, `SUPER_ADMIN`.

### Order Statuses (`OrderStatus`)
`CREATED`, `CONFIRMED`, `PACKING`, `READY_FOR_PICKUP`, `OUT_FOR_DELIVERY`, `DELIVERED`, `CANCELLED`, `REFUNDED`.

---

## 2. Core Entity Tables

### `users` (`User`)
- `id` (`UUID`, Primary Key)
- `phoneNumber` (`String`, Unique)
- `email` (`String`, Unique, Optional)
- `fullName` (`String`)
- `role` (`Role`, Default `CUSTOMER`)
- `mfaEnabled` (`Boolean`, Default `false`)
- `mfaSecret` (`String`, Optional)
- `failedLoginAttempts` (`Int`, Default `0`)
- `lockoutUntil` (`DateTime`, Optional)

### `stores` (`Store`)
- `id` (`UUID`, Primary Key)
- `name` (`String`)
- `code` (`String`, Unique)
- `latitude` (`Float`), `longitude` (`Float`)
- `isOpen` (`Boolean`, Default `true`)

### `products` (`Product`) & `product_variants` (`ProductVariant`)
- Products track name, slug, category ID, brand, aliases, keywords, and tags.
- ProductVariants track unit name (e.g. `500g`), SKU, price, MRP, and stock status.

### `orders` (`Order`) & `order_items` (`OrderItem`)
- Order headers track `orderNumber`, `storeId`, `userId`, `addressId`, `deliveryPartnerId`, `subtotal`, `deliveryFee`, `discount`, `totalAmount`, `status`, `paymentMethod`, `paymentStatus`.

---

## 3. Database Indexes & Performance Optimization

- `User`: Index on `phoneNumber` and `email` for O(1) authentication lookups.
- `Product`: Index on `slug`, `categoryId`, and composite GIN index on `searchKeywords`.
- `Inventory`: Composite unique index on `[storeId, variantId]`.
- `Order`: Index on `userId`, `storeId`, and `status`.
