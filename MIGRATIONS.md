# 🔄 Daily Basket — Database Migrations & Change Management

> **Authoritative Specification**: Standard operating procedures, migration history, rollback protocols, and zero-downtime guidelines for applying database changes across **Daily Basket** PostgreSQL 16 environments.
>
> **Related Documentation**:
> - 📊 [Data Model & Entity Relationships](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/DATA-MODEL.md)
> - 🧱 [Database Schema & Data Dictionary](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/SCHEMA.md)
> - 🔐 [Row-Level Security & Access Policies](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/RLS-POLICIES.md)
> - 🗄️ [Prisma Schema Definition](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/prisma/schema.prisma)

---

## 1. Migration Architecture & Toolchain

Daily Basket uses **Prisma Migrate** as its primary schema change management engine on **PostgreSQL 16**.

- **Migration Root**: [`services/api/prisma/migrations/`](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/prisma/migrations)
- **Lockfile**: [`services/api/prisma/migrations/migration_lock.toml`](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/services/api/prisma/migrations/migration_lock.toml) (`provider = "postgresql"`)
- **Prisma Client Output**: `node_modules/.prisma/client`
- **Execution Target**: Node.js microservice (`services/api`) and automated CI/CD runners.

```
services/api/prisma/migrations/
├── migration_lock.toml
├── 20261010000000_init_baseline/
│   └── migration.sql (1,645 lines - Baseline 79-table schema, enums, FKs, indexes)
└── 20261011_add_imageUrl_to_cart_items/
    └── migration.sql (Targeted non-blocking column addition to cart_items)
```

---

## 2. Chronological Migration History Log

| Migration Directory | Applied Date | Author / Context | Scope & Description |
| :--- | :---: | :--- | :--- |
| **`20261010000000_init_baseline`** | 2026-10-10 | Architecture Core | **Initial System Baseline**. Creates native PostgreSQL enums (`Role`, `OrderStatus`, `PaymentMethod`, `PaymentStatus`), 79 relational tables, UUID primary keys, default constraints, and foreign key relations across all 12 bounded contexts. |
| **`20261011_add_imageUrl_to_cart_items`** | 2026-10-11 | Mobile UI/UX Team | **Cart Visual Persistence**. Adds `imageUrl TEXT` column to `cart_items` to cache product thumbnails directly in the cart state, eliminating redundant catalog lookups on high-traffic cart screens. |

### Migration 1: Baseline Architecture (`20261010000000_init_baseline`)
- Creates 4 Enums: `Role`, `OrderStatus`, `PaymentMethod`, `PaymentStatus`.
- Creates 79 tables starting with core entities (`stores`, `users`, `addresses`, `categories`, `products`, `orders`) through AI, voice shopping, procurement, warehouse, and fleet systems.
- Configures cascading deletion rules (`ON DELETE CASCADE` vs `ON DELETE RESTRICT`).
- Sets up primary composite unique constraints (e.g. `inventories(storeId, variantId)`, `cart_items(cartId, variantId)`).

### Migration 2: Cart Image Optimization (`20261011_add_imageUrl_to_cart_items`)
```sql
-- Migration: add_imageUrl_to_cart_items
-- Added optional imageUrl column to cart_items table so product images
-- are persisted with each cart item and correctly displayed in the mobile app.

ALTER TABLE "cart_items" ADD COLUMN IF NOT EXISTS "imageUrl" TEXT;
```

---

## 3. Step-by-Step Migration Developer Workflow

### 3.1. Local Development Lifecycle

Always run migration commands from the `services/api` directory or pass the schema argument:

```bash
# 1. Modify the schema in services/api/prisma/schema.prisma
# 2. Generate and apply a new migration locally:
cd services/api
npx prisma migrate dev --name <descriptive_snake_case_name>

# Example:
npx prisma migrate dev --name add_loyalty_tier_to_users
```

Prisma will:
1. Compare your `schema.prisma` with existing migration history.
2. Generate a new timestamped folder under `services/api/prisma/migrations/`.
3. Apply the generated SQL to your local development database.
4. Regenerate `@prisma/client`.

### 3.2. Manual SQL Tweaking (`--create-only`)

For complex changes requiring custom SQL (e.g., creating custom PostgreSQL triggers, partial indexes, or data backfills before enforcing `NOT NULL`):

```bash
cd services/api
# Generate migration SQL without applying it immediately
npx prisma migrate dev --create-only --name create_custom_index

# Edit the generated migration.sql manually
# Then apply it to local database
npx prisma migrate dev
```

### 3.3. Checking Migration Status & Drift

To inspect whether your database is in sync with migrations:

```bash
cd services/api
npx prisma migrate status
```

Status output indicates:
- **Database schema is up to date**: All migrations applied.
- **Unapplied migrations**: Migrations committed in repo but not yet executed on the connected database.
- **Schema drift detected**: Database modified outside of Prisma Migrate.

---

## 4. Production CI/CD Deployment Protocol

> [!CAUTION]
> Never run `prisma migrate dev` or `prisma db push` in production or staging environments. Doing so can cause accidental resets or silent data drift.

### 4.1. Automated Deployment Pipeline

In automated deployment workflows (such as [`.github/workflows/production-cd.yml`](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/.github/workflows/production-cd.yml)), migrations are executed using:

```bash
cd services/api
npx prisma migrate deploy
```

Behavior of `prisma migrate deploy`:
- Only executes pending migrations from `prisma/migrations/`.
- Does **not** detect drift or create new migrations.
- Fails immediately if the database state is corrupt or has missing migration history.
- Operates safely within rolling container deployment pods.

### 4.2. Handling Failed Migrations (`prisma migrate resolve`)

If a migration fails midway in staging or production (e.g., due to a temporary lock timeout or network interruption):

1. **Inspect error logs** in database logs or CI console.
2. **Determine state**: Check if the migration partially executed or failed before changing any tables.
3. **If manually corrected in the database**:
   ```bash
   npx prisma migrate resolve --applied "20261011_add_imageUrl_to_cart_items"
   ```
4. **If rolled back in the database**:
   ```bash
   npx prisma migrate resolve --rolled-back "20261011_add_imageUrl_to_cart_items"
   ```

---

## 5. Zero-Downtime Migration Practices

Daily Basket targets **99.99% availability** with zero planned downtime during deployments.

```
                    EXPAND AND CONTRACT PATTERN
Phase 1: EXPAND            Phase 2: DUAL WRITE        Phase 3: CONTRACT
+-------------------+      +-------------------+      +-------------------+
| Add new column as | ---> | App writes to     | ---> | Drop old column   |
| optional / default|      | old and new       |      | in subsequent     |
| (non-breaking)    |      | (data backfilled) |      | release           |
+-------------------+      +-------------------+      +-------------------+
```

### 5.1. Safe vs. Unsafe Operations Matrix

| Operation Type | Safety Level | Production Rule |
| :--- | :---: | :--- |
| **Add Optional Column** (`NULL`) | 🟢 Safe | Apply directly. No locks or app interruption. |
| **Add Column with Default** | 🟢 Safe | Safe in PostgreSQL 11+ (stored in catalog metadata, $O(1)$). |
| **Add New Table** | 🟢 Safe | Apply directly. No impact on existing tables. |
| **Create Index Concurrently** | 🟢 Safe | Use raw SQL `CREATE INDEX CONCURRENTLY` to avoid table write locks. |
| **Add NOT NULL Column** | 🟡 Conditional | Must specify a default value or add as nullable, backfill data, then `ALTER COLUMN SET NOT NULL`. |
| **Rename Column** | 🔴 Unsafe | **Do NOT rename directly**. Use Expand/Contract dual-write approach. |
| **Drop Column** | 🔴 Unsafe | Remove all application references first, deploy app, then drop column in next release. |
| **Change Column Type** | 🔴 Unsafe | Create new column with target type, dual-write, backfill, switch app code, drop old column. |

### 5.2. Non-Blocking Index Creation

Prisma creates standard indexes by default, which can briefly lock heavy tables like `orders` or `inventories`. For high-traffic tables in production, use custom SQL migrations:

```sql
-- Safe concurrent index creation:
CREATE INDEX CONCURRENTLY IF NOT EXISTS "orders_user_status_idx"
ON "orders" ("userId", "status");
```

---

## 6. Seeding, Catalog Hydration & Test Data

### 6.1. Baseline Database Seeding
To populate initial administrative roles, dark stores, and master categories:

```bash
# Run top-level database seed script:
npm run seed:dev
# or directly:
npx ts-node scripts/seed-dev-database.ts
```

### 6.2. Catalog & Product Ingestion
To populate the 79-table schema with real-world grocery catalogs (fruits, vegetables, organic staples, dairy):

```bash
cd services/api
npx ts-node prisma/seed-catalog.ts
```

### 6.3. Environment Configuration Pre-flight Validation
Before running migrations or seeding, validate environment variable availability:

```bash
npx ts-node scripts/validate-env.ts
```

---

## 7. Backup, Disaster Recovery & Verification Protocols

Database migrations must always be preceded by verified automated snapshots.

### 7.1. Pre-Migration Hot Backup
```bash
# Automated bash script taking a consistent PostgreSQL dump:
bash scripts/backups/backup-postgres.sh
```

### 7.2. Point-in-Time Recovery (PITR)
```bash
# Restore PostgreSQL database from specified snapshot:
bash scripts/backups/restore-postgres.sh <backup_file.sql.gz>
```

### 7.3. Automated Backup Verification
Daily Basket runs continuous restore verification in an isolated sandbox to validate data integrity:

```bash
bash scripts/restore-verification.sh
```
