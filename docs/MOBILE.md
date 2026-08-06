# 📱 Flutter Mobile App Technical Specification (`apps/mobile`)

The **Daily Basket Flutter App** is a cross-platform mobile application targeting Android and iOS devices, engineered with Clean Architecture and Flutter 3.19.

---

## 1. Clean Architecture Layer Structure

```
apps/mobile/lib/
├── core/                           # Cross-cutting infrastructure & shared providers
│   ├── network/api_client.dart     # HTTP REST client with JWT refresh token interceptor
│   ├── permissions/                # Device permission service (GPS location, Camera, Mic)
│   ├── storage/                    # Encrypted local storage (SecureStorageService)
│   └── theme/app_theme.dart        # Material Design 3 theme matching Google Stitch specs
├── features/                       # Domain feature modules (Presentation & Providers)
│   ├── auth/                       # OTP verification, Login, Google OAuth, Biometrics
│   ├── cart/                       # Cart drawer state & free delivery progress bar
│   ├── home/                       # Sticky ETA header, dynamic categories, flash deals
│   ├── orders/                     # Order history, item receipts, re-order trigger
│   ├── search/                     # Full-text catalog search & voice input
│   ├── tracking/                   # Live GPS WebSocket map telemetry
│   └── wallet/                     # Digital wallet balance & transaction ledger
```

---

## 2. Global Provider Architecture

Mobile state is managed using the `Provider` pattern with scoped ChangeNotifier classes:

- **`UserProvider`**: Manages authentication tokens, profile data, role, and MFA state.
- **`CartProvider`**: Maintains local cart items, calculates subtotals, applies coupon codes, and checks free delivery eligibility (`₹299`).
- **`TrackingProvider`**: Connects to backend Socket.IO WebSockets to stream live order progress and rider GPS coordinates.
- **`AiChatProvider`**: Interfaces with `AiAgentService` for natural language grocery assistance and recipe suggestions.
