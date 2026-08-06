# 🔧 Troubleshooting & Self-Healing Guide — Daily Basket

This guide provides diagnostic steps for resolving common local development and production issues.

---

## 1. Common Issues & Resolution Playbook

### Issue 1: Database Connection Refused (`P1001`)
- **Symptom**: `PrismaClientInitializationError: Can't reach database server at localhost:5432`.
- **Fix**: Verify Docker container is running:
  ```bash
  docker compose -f infrastructure/docker-compose.yml ps
  docker compose -f infrastructure/docker-compose.yml up -d
  ```

### Issue 2: Redis Connection Error (`ECONNREFUSED 127.0.0.1:6379`)
- **Fix**: Restart Redis container:
  ```bash
  docker restart daily_basket_redis
  ```

### Issue 3: Flutter Analyzer Warnings
- **Fix**: Run `flutter clean && flutter pub get && flutter analyze`.
