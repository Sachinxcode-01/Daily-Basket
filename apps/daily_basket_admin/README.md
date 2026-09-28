# 🏢 Daily Basket — Flutter Admin Mobile Application (`apps/daily_basket_admin`)

![Flutter](https://img.shields.io/badge/Flutter-3.19.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/UI-Material%20Design%203-7B1FA2?style=for-the-badge)
![Google Stitch](https://img.shields.io/badge/Design-Google%20Stitch-006823?style=for-the-badge)

---

## 📌 Overview

The **Daily Basket Flutter Admin App** is a companion mobile management application for dark store operations managers, inventory controllers, and logistics leads. It enables on-the-go physical stock audits, real-time fulfillment monitoring, and driver dispatch management directly from an Android or iOS device.

---

## 🏗️ Technical Architecture & Modules

```
apps/daily_basket_admin/lib/
├── core/                           # Theme tokens, network client, and navigation
├── features/
│   ├── orders/                     # Real-time fulfillment queue & picker interface
│   ├── inventory/                  # Barcode scanning, SKU search, and stock level editor
│   ├── fleet/                      # Live rider GPS telemetry & route assignments
│   └── settings/                   # Dark store hub parameters & Go-Live readiness checklist
└── main.dart                       # Flutter bootstrap & provider tree
```

### ⚡ Key Capabilities:

1. **📦 Mobile Fulfillment Flow**: Pick, pack, and hand off grocery bags to delivery riders with barcode confirmation.
2. **📊 On-Floor Inventory Audits**: Scan physical shelves and reconcile system counts against dark store storage.
3. **🚀 Pre-Launch Readiness Checklist**: Inspect production database links, live payment gateways, and Firebase Service Account configuration.

---

## ⚡ Running Locally

```bash
cd apps/daily_basket_admin
flutter pub get
flutter run
```
