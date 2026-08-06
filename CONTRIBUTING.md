# Contributing to Daily Basket

Thank you for your interest in contributing to **Daily Basket**! We welcome contributions from developers, designers, QA engineers, and security researchers.

---

## 📜 Principles & Standards

Before submitting a pull request, please review our core engineering principles:

1. **Google Stitch Design Source of Truth**: The Google Stitch project is the single source of truth for all UI/UX across Mobile, Web, Admin, and Delivery applications. Do NOT redesign or alter components without explicit approval.
2. **Type Safety**: All TypeScript code must be strictly typed (`noImplicitAny: true`). Use `@daily-basket/shared-types` for API DTOs and contracts.
3. **Clean Architecture**: Follow SOLID, DRY, and KISS principles. Maintain clean separation between controllers, services, and repositories in NestJS, and provider state vs presentation in Flutter.
4. **Zero Analyzer Warnings**: Flutter code must pass `flutter analyze` with zero errors and zero warnings. TypeScript apps must compile cleanly (`pnpm build`).

---

## 🛠️ Local Development Workflow

### 1. Prerequisites
- Node.js >= 18.18.0
- pnpm >= 8.15.0
- Flutter SDK >= 3.19.0
- Docker & Docker Compose

### 2. Fork & Setup Monorepo
```bash
git clone https://github.com/YOUR-USERNAME/Daily-Basket.git
cd Daily-Basket
pnpm install
```

### 3. Start Local Environment
```bash
# Start PostgreSQL & Redis via Docker
docker compose -f infrastructure/docker-compose.yml up -d

# Push database schema & seed initial data
cd services/api
npx prisma db push
npx prisma generate
cd ../..

# Start local web applications & API gateway
pnpm dev
```

### 4. Create Feature Branch
Adhere to standard branch naming conventions:
- `feature/description` — New features (e.g. `feature/fcm-notifications`)
- `bugfix/description` — Bug fixes (e.g. `bugfix/razorpay-signature-check`)
- `docs/description` — Documentation improvements (e.g. `docs/api-update`)

---

## 🧪 Quality Assurance & Testing Requirements

Always execute tests locally before committing code:

```bash
# Run NestJS API unit tests
pnpm --filter api test

# Run Flutter mobile static analysis & tests
cd apps/mobile
flutter analyze
flutter test
```

---

## 📦 Commit Message Formatting

We follow the **Conventional Commits** specification:

```
<type>(<scope>): <short summary>

[optional body]
```

### Examples:
- `feat(auth): implement TOTP MFA backup codes verification`
- `fix(payments): validate Razorpay HMAC signature on webhook payload`
- `docs(api): update OpenAPI schemas for order creation DTO`
- `refactor(mobile): extract shared favorite button to design system`

---

## 📬 Submitting Pull Requests

1. Rebase your branch against the latest `main` branch (`git pull --rebase origin main`).
2. Open a Pull Request targeting `main`.
3. Fill out the PR template completely with screenshots/videos for UI changes.
4. Ensure all CI/CD pipeline checks pass.
