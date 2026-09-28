# 📱 Daily Basket — Customer Mobile Application (`apps/mobile`)

![Flutter](https://img.shields.io/badge/Flutter-3.19.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Maps](https://img.shields.io/badge/Google%20Maps-Live%20Telemetry-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20FCM-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Design System](https://img.shields.io/badge/Design%20System-Google%20Stitch-006823?style=for-the-badge)

---

## 📌 Overview

The **Daily Basket Mobile App** is a production-grade, cross-platform Flutter application built with Clean Architecture, Material Design 3, and the Provider pattern. Designed to deliver groceries in 10 minutes, it provides a fast, smooth, and intuitive user experience anchored to the **Google Stitch Design Source of Truth**.

---

## 🏗️ Architecture & State Management

The application follows strict **Clean Architecture** principles:

```
apps/mobile/lib/
├── core/                           # Core utilities, theme, network & providers
│   ├── navigation/                 # Navigation drawer & route handlers
│   ├── network/                    # API HTTP client (`api_client.dart`)
│   ├── permissions/                # Device permissions service (Location, Camera, Mic)
│   ├── providers/                  # Global app state providers (User, Cart, Theme, AI, Search, Wishlist)
│   ├── services/                   # Native services (AI agent, Voice chat, Image scanner)
│   ├── storage/                    # Secure key-value storage (`secure_storage_service.dart`)
│   └── theme/                      # AppTheme tokens, colors, & typography
├── features/                       # Feature modules (Domain-driven presentation)
│   ├── auth/                       # OTP, Login, Register, Google OAuth, Biometrics
│   ├── cart/                       # Cart drawer, items list, subtotal meter
│   ├── catalog/                    # Product catalog, grid viewer, detail pages
│   ├── categories/                 # Category taxonomy browser
│   ├── freshness/                  # Fresh produce origin & quality inspector
│   ├── home/                       # Home feed, ETA badge, address selector, deal banners
│   ├── membership/                 # Daily Basket Plus VIP perks page
│   ├── notifications/              # Push & in-app notification center
│   ├── onboarding/                 # Animated intro flow & permission screens
│   ├── orders/                     # Order receipts & order history
│   ├── profile/                    # Profile management, address book (`address_provider.dart`)
│   ├── referral/                   # Coupon codes & referral sharing (`coupon_provider.dart`)
│   ├── search/                     # Smart debounced search with trending tags & voice
│   ├── settings/                   # App preferences, security, permissions
│   ├── support/                    # Searchable FAQ accordion & live chat
│   ├── tracking/                   # Live GPS tracking map (`tracking_provider.dart`)
│   └── wallet/                     # Wallet balance & ledger (`wallet_provider.dart`)
├── shared/                         # Shared UI widgets (FavoriteButton, SkeletonLoader, AnimatedCard)
└── main.dart                       # App bootstrap & provider injection
```

---

## ✨ Implemented Screen Features (35+ Screens)

1. **🔐 Authentication Suite**:
   - `welcome_screen.dart`: Animated entry sequence with staggered typewriter motion and Google OAuth button.
   - `login_screen.dart`: Email/Password & Google SSO login with lockout protection.
   - `register_screen.dart`: Customer registration with single-tap Google SSO account linking.
   - `otp_screen.dart`: Phone OTP request with 6-digit PIN input and 60s cooldown timer.
   - `mfa_selection_screen.dart`: TOTP vs Email MFA selector.
   - `enable_biometrics_screen.dart`: Fingerprint / FaceID setup.
   - `account_locked_screen.dart`: Automated lockout timer after 5 consecutive failed attempts.

2. **🛍️ Shopping & Feed**:
   - `home_screen.dart`: Sticky 10-minute ETA header badge, address bar, flash deals grid.
   - `cart_screen.dart`: Interactive cart drawer with free delivery progress meter.
   - `checkout_screen.dart`: Address selection, slot booking, Razorpay payment intent (UPI/Card/COD).

3. **🗺️ Tracking & Delivery**:
   - `live_tracking_screen.dart`: Animated step-by-step timeline, Socket.IO WebSocket GPS telemetry, driver card.

4. **🤖 AI Capabilities**:
   - Multi-provider AI assistant with voice input and visual grocery scanner.

---

## ⚡ Running Locally

```bash
cd apps/mobile
flutter pub get
flutter run
```
