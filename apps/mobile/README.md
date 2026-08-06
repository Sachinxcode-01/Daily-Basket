# 📱 Daily Basket — Customer Mobile Application (`apps/mobile`)

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

1. **Authentication Suite**:
   - `phone_login_screen.dart`: Phone OTP request with 6-digit PIN input.
   - `verify_otp_screen.dart`: OTP verification countdown & auto-submit.
   - `google_auth_button.dart`: Single-tap Google OAuth integration.
   - `mfa_selection_screen.dart`: TOTP vs Email MFA selector.
   - `enable_biometrics_screen.dart`: Fingerprint / FaceID setup.
   - `account_locked_screen.dart`: Lockout timer after failed attempts.
2. **Shopping & Feed**:
   - `home_screen.dart`: Sticky 10-minute ETA header badge, address bar, flash deals grid.
   - `cart_screen.dart`: Interactive cart drawer with free delivery progress meter.
   - `checkout_screen.dart`: Address selection, slot booking, Razorpay payment intent (UPI/Card/COD).
3. **Tracking & Delivery**:
   - `live_tracking_screen.dart`: Animated step-by-step timeline, Socket.IO WebSocket GPS telemetry, driver card.
4. **AI Capabilities**:
   - `ai_chat_assistant_screen.dart`: Natural language grocery assistant & recipe builder.
   - `visual_freshness_scanner_screen.dart`: Camera photo upload for produce quality inspection.
   - `voice_search_overlay.dart`: Speech recognition voice input for instant search.

---

## 🧪 Testing & Code Quality

The mobile codebase adheres to strict quality guidelines:

```bash
# Run static analysis (0 Errors, 0 Warnings required)
flutter analyze

# Execute unit and widget test suites
flutter test
```

---

## ⚡ Running Locally

```bash
cd apps/mobile

# Fetch Flutter dependencies
flutter pub get

# Launch on connected simulator or device
flutter run
```
