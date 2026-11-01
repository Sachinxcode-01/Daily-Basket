# 📘 Daily Basket — Enterprise Documentation Hub Index

Welcome to the **Daily Basket Enterprise Documentation Hub**. This matrix provides a complete directory to all architectural, technical, operational, and product documentation files across the monorepo.

---

## 🗺️ Documentation Navigation Matrix

### 1. Platform & System Architecture
- 🏗️ [`docs/ARCHITECTURE.md`](ARCHITECTURE.md) — End-to-End Monorepo Architecture & Microservice Topology
- 🧩 [`docs/SYSTEM_DESIGN.md`](SYSTEM_DESIGN.md) — Component Design, Data Flow Pipelines & State Synchronization
- 🎨 [`docs/GOOGLE_STITCH.md`](GOOGLE_STITCH.md) — Google Stitch UI/UX Single Source of Truth Specification
- 💅 [`docs/DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md) — Shared UI Components, Tokens & Branding Guidelines

### 2. Product & Technical Requirements
- 📋 [`docs/PRD.md`](PRD.md) — Product Requirements Document (Personas, Features, & User Stories)
- 📐 [`docs/TRD.md`](TRD.md) — Technical Requirements Document (SLAs, Latency Targets, & Quality Benchmarks)

### 3. API, Database & Security
- 🔌 [`docs/API.md`](API.md) — Complete NestJS REST Endpoint Directory with DTOs & Validation Schemas
- 📄 [`docs/OPENAPI.md`](OPENAPI.md) — Swagger UI Setup & OpenAPI 3.0 Contract Specification
- 📊 [`DATA-MODEL.md`](../DATA-MODEL.md) — Enterprise Data Entities, Relationships & Relational Topologies
- 🧱 [`SCHEMA.md`](../SCHEMA.md) — PostgreSQL 16 Tables, Columns, Data Types, Constraints & Indexes Reference
- 🔄 [`MIGRATIONS.md`](../MIGRATIONS.md) — Prisma Migration Logs, Rollback Protocols & Zero-Downtime Workflows
- 🔐 [`RLS-POLICIES.md`](../RLS-POLICIES.md) — PostgreSQL Row-Level Security Rules, Multi-Tenant Boundaries & Auditing
- 🗄️ [`docs/DATABASE.md`](DATABASE.md) — PostgreSQL Database Schema & Prisma Models Reference
- 📊 [`docs/ERD.md`](ERD.md) — Entity Relationship Diagrams & Database Constraints
- 🔐 [`docs/AUTHENTICATION.md`](AUTHENTICATION.md) — Phone OTP, JWT Rotation, Google OAuth, TOTP MFA, & Biometrics
- 🛡️ [`docs/SECURITY_ARCHITECTURE.md`](SECURITY_ARCHITECTURE.md) — RBAC, Throttling, Helmet, Security Audit Logs, & AES-256
- 🔍 [`docs/AUTHENTICATION_HARDENING_AUDIT.md`](AUTHENTICATION_HARDENING_AUDIT.md) — Auth Security Hardening Audit & Vulnerability Remediation

### 4. Intelligence & Real-time Subsystems
- 🤖 [`docs/AI.md`](AI.md) — Multi-Provider AI Engine (Gemini, Grok, OpenRouter, Local AI, Fallbacks, & Tools)
- 🎙️ [`docs/VOICE_SHOPPING.md`](VOICE_SHOPPING.md) — Voice-Assisted Grocery Shopping & Audio Transcription Architecture
- ⚡ [`docs/REALTIME.md`](REALTIME.md) — Real-time Socket.IO WebSockets & Telemetry Gateways
- 💬 [`docs/SOCKETS.md`](SOCKETS.md) — WebSocket Event Payload Dictionary & Connection Protocols
- 📦 [`docs/REDIS.md`](REDIS.md) — Redis 7 Caching Strategy, Key Namespaces, Pub/Sub, & Session Store
- 📩 [`docs/BULLMQ.md`](BULLMQ.md) — BullMQ Queue Architecture, Job Workers, & Notification Processors

### 5. Application-Specific Guides
- ⚙️ [`docs/BACKEND.md`](BACKEND.md) — NestJS Clean Architecture, Modules, & ORM Layer
- 🌐 [`docs/FRONTEND.md`](FRONTEND.md) — Next.js Web Portal Architecture & Shared Monorepo Packages
- 📱 [`docs/MOBILE.md`](MOBILE.md) — Flutter Customer App Architecture & Clean Architecture Providers
- 🛒 [`docs/WEBSITE.md`](WEBSITE.md) — Next.js Customer Web Application Breakdown
- 🏢 [`docs/ADMIN_APP.md`](ADMIN_APP.md) — Dark Store Admin Dashboard Fulfillment Queue & Analytics
- 🛵 [`docs/DELIVERY_APP.md`](DELIVERY_APP.md) — Delivery Partner PWA, GPS Telemetry, & Doorstep OTP

### 6. Business Domain Feature Guides
- 🍎 [`docs/feature-domains/PRODUCTS.md`](feature-domains/PRODUCTS.md) — Catalog Taxonomy, Categories, Keywords, & Brand Aliases
- 📦 [`docs/feature-domains/INVENTORY.md`](feature-domains/INVENTORY.md) — Dark Store Inventory Stock Allocation & Low-Stock Alerts
- 💳 [`docs/feature-domains/PAYMENTS.md`](feature-domains/PAYMENTS.md) — Razorpay Payment Gateway, HMAC Webhooks, & Wallet Ledger
- 🔔 [`docs/feature-domains/NOTIFICATIONS.md`](feature-domains/NOTIFICATIONS.md) — Push Notifications, SMS OTP, Email, & Alert Feeds
- 📢 [`docs/feature-domains/DAILY_MESSAGES.md`](feature-domains/DAILY_MESSAGES.md) — Automated 08:00 Daily Marketing Loop, Campaigns & Cohort Push Dispatch

### 7. DevOps, Setup & Testing
- 🐳 [`docs/DEPLOYMENT.md`](DEPLOYMENT.md) — Production Deployment Specs (Docker, Compose, NGINX, K8s)
- 🚀 [`docs/DEVOPS.md`](DEVOPS.md) — DevOps Pipelines, GitHub Actions Workflows, & Release Engineering
- 📥 [`docs/INSTALLATION.md`](INSTALLATION.md) — Step-by-Step Installation, Database Push, & Seed Automation
- 🛠️ [`docs/SETUP.md`](SETUP.md) — Development Environment Setup & IDE Configurations
- 🚀 [`docs/GETTING_STARTED.md`](GETTING_STARTED.md) — Developer Onboarding & Quickstart Guide
- ⚙️ [`docs/ENVIRONMENT.md`](ENVIRONMENT.md) — Complete Environment Variable Specification Matrix
- 🧪 [`docs/TESTING.md`](TESTING.md) — Testing Strategy (Flutter Analyze, Flutter Test, NestJS Jest, QA)
- ⚡ [`docs/PERFORMANCE.md`](PERFORMANCE.md) — Performance SLAs, Database Tuning, & Load Testing Benchmarks

### 8. Operations, Reliability & Support
- 📕 [`docs/GO_LIVE_RUNBOOK.md`](GO_LIVE_RUNBOOK.md) — Production Deployment Runbook & Rolling Updates
- 🚑 [`docs/DISASTER_RECOVERY.md`](DISASTER_RECOVERY.md) — Disaster Recovery Strategy, RTO/RPO SLAs, & Failover
- 💾 [`docs/BACKUP_STRATEGY.md`](BACKUP_STRATEGY.md) — Automated Database Backups & Media Retention Playbooks
- 📞 [`docs/OPERATIONS.md`](OPERATIONS.md) — Incident Response Procedures & Operational Escalations
- 📊 [`docs/MONITORING.md`](MONITORING.md) — Health Probes, Terminus Checks, & Alert Thresholds
- 👁️ [`docs/OBSERVABILITY.md`](OBSERVABILITY.md) — Structured Logging, Metrics & Telemetry Strategy
- 🔧 [`docs/TROUBLESHOOTING.md`](TROUBLESHOOTING.md) — Common Troubleshooting Steps & Diagnostic Commands
- ❓ [`docs/FAQ.md`](FAQ.md) — Frequently Asked Technical & Product Questions
- 📰 [`docs/RELEASE_NOTES.md`](RELEASE_NOTES.md) — Monorepo Version Release Notes & Upgrade Guides
