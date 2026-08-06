# 🚀 DevOps & CI/CD Engineering — Daily Basket

This document describes the GitHub Actions continuous integration and continuous deployment (CI/CD) pipelines configured in `.github/workflows/`.

---

## 1. Automated Pipeline Workflow

```mermaid
graph LR
    PushCommit["Push to main / PR"] --> LintJob["1. Lint & Typecheck\n(ESLint + tsc)"]
    LintJob --> TestJob["2. Automated Tests\n(Jest + Flutter test)"]
    TestJob --> BuildJob["3. Multi-Stage Docker Build\n(API, Web, Admin, Delivery)"]
    BuildJob --> DeployJob["4. Production Deployment\n(Rolling Container Update)"]
```
