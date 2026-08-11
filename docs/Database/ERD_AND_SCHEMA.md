# Daily Basket — Database Schema & Entity-Relationship Diagram (ERD)

## Overview

The Daily Basket database layer is built on PostgreSQL, managed via Prisma ORM (`prisma/schema.prisma`). It enforces strict relational integrity, UUID primary keys, and performance indexing.

---

## Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    STORE ||--o{ PRODUCT : catalog
    STORE ||--o{ ORDER : fulfills
    STORE ||--o{ INVENTORY : maintains
    
    CATEGORY ||--o{ PRODUCT : categorizes
    CATEGORY ||--o{ CATEGORY : subcategory
    
    PRODUCT ||--|{ PRODUCT_VARIANT : has
    PRODUCT ||--o{ REVIEW : receives
    PRODUCT ||--o{ FAVORITE : favorited_by
    PRODUCT ||--o| PRODUCT_AI_INSIGHT : has
    
    USER ||--o{ ADDRESS : has
    USER ||--o{ ORDER : places
    USER ||--o{ REVIEW : writes
    USER ||--o{ DEVICE_SESSION : authenticates
    USER ||--o{ SECURITY_AUDIT_LOG : audits
    
    PRODUCT_VARIANT ||--o{ INVENTORY : tracked_in
    PRODUCT_VARIANT ||--o{ ORDER_ITEM : ordered_as
    
    ORDER ||--|{ ORDER_ITEM : contains
    ORDER ||--o{ PAYMENT : paid_by
    ORDER }|--|| ADDRESS : delivers_to
    
    ORDER {
        string id PK
        string orderNumber UK
        string storeId FK
        string userId FK
        string addressId FK
        float totalAmount
        enum status
        enum paymentStatus
        datetime createdAt
    }

    PRODUCT {
        string id PK
        string storeId FK
        string categoryId FK
        string name
        string slug UK
        string brand
        boolean isOrganic
        datetime createdAt
    }

    PRODUCT_VARIANT {
        string id PK
        string productId FK
        string unitName
        float price
        float mrp
        string sku UK
        boolean isAvailable
    }

    INVENTORY {
        string id PK
        string storeId FK
        string variantId FK
        int stockQuantity
        int reservedQuantity
    }
```

---

## Database Indexing Strategy

To guarantee **<250ms database latency**, key indexes are defined across high-traffic models:

| Table | Index Columns | Purpose |
| :--- | :--- | :--- |
| `orders` | `(userId, status)` | Fast user order history lookup |
| `orders` | `(storeId, status)` | Dark store order fulfillment queue |
| `orders` | `(createdAt)` | Time-series order analytics |
| `products` | `(storeId, categoryId)` | Store category product listing |
| `products` | `(brand)` | Brand filter queries |
| `product_variants` | `(productId, isAvailable)` | Active variant fetching |
| `inventories` | `(storeId, variantId)` | Atomic stock lookup |
| `inventories` | `(stockQuantity)` | Low stock monitoring alerts |
| `reviews` | `(productId, rating)` | Product rating aggregation |
| `security_audit_logs` | `(userId, event, createdAt)` | Security audit timeline |

---

## High-Concurrency Atomic Operations

Stock allocations avoid read-modify-write race conditions by executing atomic SQL updates directly:

```sql
UPDATE inventories
SET "stockQuantity" = "stockQuantity" - $1,
    "reservedQuantity" = "reservedQuantity" + $1,
    "updatedAt" = NOW()
WHERE "storeId" = $2
  AND "variantId" = $3
  AND "stockQuantity" >= $1;
```
