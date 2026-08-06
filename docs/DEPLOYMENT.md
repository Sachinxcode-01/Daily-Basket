# 🐳 Production Deployment Specifications — Daily Basket

This document describes production deployment procedures using Docker, Docker Compose, NGINX Reverse Proxy, and Kubernetes manifests.

---

## 1. Container Infrastructure Layout

```
infrastructure/
├── docker/
│   ├── Dockerfile.api              # Multi-stage production build for NestJS API
│   ├── Dockerfile.website          # Multi-stage build for Next.js Customer Web
│   ├── Dockerfile.admin            # Multi-stage build for Next.js Dark Store Admin
│   └── Dockerfile.delivery         # Multi-stage build for Next.js Delivery PWA
├── k8s/
│   └── deployment.yaml             # Kubernetes Deployment & Service manifests
├── nginx/
│   └── nginx.conf                  # Production NGINX SSL & reverse proxy setup
├── docker-compose.yml              # Local development compose setup
└── docker-compose.prod.yml         # Production multi-container compose setup
```

---

## 2. Production Docker Compose Execution

```bash
# Pull latest images and launch stack in detached mode
docker compose -f infrastructure/docker-compose.prod.yml up -d --build
```
