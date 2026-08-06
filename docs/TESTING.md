# 🧪 Testing Strategy & Execution — Daily Basket

This document describes automated testing practices across Flutter mobile apps, Next.js web applications, and NestJS microservices.

---

## 1. Automated Test Execution Commands

```bash
# 1. Flutter Mobile App Static Analysis (0 Errors, 0 Warnings enforced)
cd apps/mobile
flutter analyze

# 2. Flutter Unit & Widget Test Suites
flutter test

# 3. NestJS API Microservices Unit Tests (Jest)
cd ../../services/api
pnpm test

# 4. Next.js Web Typecheck & Linting
pnpm --filter website typecheck
pnpm --filter website lint
```
