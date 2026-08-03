# Contributing to Daily Basket

First off, thank you for considering contributing to **Daily Basket**! It's people like you that make Daily Basket such an enterprise-grade quick-commerce platform.

---

## 🚀 Development Setup

### 1. Prerequisites
- **Node.js**: `v18.0.0+`
- **pnpm**: `v8.0.0+`
- **Flutter SDK**: `v3.19.0+`
- **Docker Desktop**: Running locally

### 2. Fork & Clone
```bash
git clone https://github.com/Sachinxcode-01/Daily-Basket.git
cd Daily-Basket
```

---

## 📐 Git Commit Guidelines

We enforce **Conventional Commits** format for all commit messages:

- `feat(mobile)`: Add new feature to Flutter mobile app
- `feat(api)`: Add new NestJS controller or service endpoint
- `fix(web)`: Fix UI bug in Next.js web portal
- `docs`: Update documentation or README
- `style`: Code formatting or linting updates
- `refactor`: Refactor internal logic without API changes

---

## 🧪 Testing Checklist Before Submitting PR

1. **Flutter Mobile**:
   ```bash
   cd apps/mobile
   flutter analyze
   ```
   *Must return zero errors and zero warnings.*

2. **NestJS API Backend**:
   ```bash
   cd services/api
   npx nest build
   ```
   *Must build cleanly with exit code 0.*

3. **Google Stitch UI Verification**:
   - Ensure all new mobile UI elements strictly match the approved **Google Stitch** design tokens (Material Design 3 dark theme, emerald `#059669` primary).
