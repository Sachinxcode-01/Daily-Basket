# ❓ Frequently Asked Questions (FAQ) — Daily Basket

---

## 1. Architecture & Design

### Q: Why is Google Stitch designated as the single source of truth?
**A**: Google Stitch defines authoritative UI designs, typography, component layouts, and animations across all four applications (Mobile, Web, Admin, Delivery). This prevents visual drift across platforms.

### Q: How does the AI Engine handle provider outages?
**A**: `ProviderManager` detects provider timeouts or 5xx errors from Google Gemini 1.5 Flash and automatically routes requests through `FallbackManager` to xAI Grok, OpenRouter, or local models without throwing exceptions to the client.

### Q: How is payment security enforced?
**A**: All Razorpay webhooks require valid HMAC SHA-256 signatures generated using `RAZORPAY_KEY_SECRET`. Signatures are validated before updating payment records in PostgreSQL.
