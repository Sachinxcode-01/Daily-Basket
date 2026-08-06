# 📊 Entity Relationship Diagram (ERD) — Daily Basket

This document provides visual Entity-Relationship Diagrams (ERD) illustrating the relational model of PostgreSQL 16 managed via Prisma ORM 5.

---

## 1. Core Domain ERD

```mermaid
erDiagram
    USER ||--o{ ADDRESS : "has"
    USER ||--o{ ORDER : "places (customer)"
    USER ||--o{ ORDER : "delivers (rider)"
    USER ||--o| WALLET : "owns"
    USER ||--o{ REVIEW : "writes"
    USER ||--o{ DEVICE_SESSION : "authorizes"

    STORE ||--o{ PRODUCT : "catalogs"
    STORE ||--o{ ORDER : "fulfills"
    STORE ||--o{ INVENTORY : "stores"

    CATEGORY ||--o{ PRODUCT : "contains"
    CATEGORY ||--o{ CATEGORY : "sub_category_of"

    PRODUCT ||--|{ PRODUCT_VARIANT : "has_variants"
    PRODUCT_VARIANT ||--o{ INVENTORY : "tracked_in"
    PRODUCT_VARIANT ||--o{ ORDER_ITEM : "ordered_in"

    ORDER ||--|{ ORDER_ITEM : "contains"
    ORDER ||--o| PAYMENT : "paid_via"
    ORDER ||--o| ADDRESS : "delivered_to"
```

---

## 2. Security & Session Subsystem ERD

```mermaid
erDiagram
    USER ||--o{ OTP_VERIFICATION : "verifies"
    USER ||--o{ SECURITY_AUDIT_LOG : "triggers"
    USER ||--o{ PASSWORD_HISTORY : "tracks"
    USER ||--o{ DEVICE_SESSION : "maintains"
    USER ||--o{ AI_CONVERSATION_SESSION : "engages"
```
