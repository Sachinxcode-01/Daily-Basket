# 📥 Step-by-Step Installation & Setup — Daily Basket

Follow this step-by-step guide to install dependencies, configure environment variables, start local databases, and launch all Daily Basket applications.

---

## 1. Environment Requirements

- **Node.js**: `>= 18.18.0`
- **pnpm**: `>= 8.15.0`
- **Flutter SDK**: `>= 3.19.0`
- **Docker & Docker Compose**

---

## 2. Step-by-Step Setup

```bash
# 1. Clone the repository
git clone https://github.com/Sachinxcode-01/Daily-Basket.git
cd Daily-Basket

# 2. Install workspace dependencies
pnpm install

# 3. Create API environment file
cp .env.production.example services/api/.env

# 4. Start PostgreSQL 16 & Redis 7 via Docker
docker compose -f infrastructure/docker-compose.yml up -d

# 5. Push Prisma schema & generate client
cd services/api
npx prisma db push
npx prisma generate
cd ../..

# 6. Start all applications concurrently
pnpm dev
```
