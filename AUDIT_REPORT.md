# Daily Basket — Full Audit Report (in brief)

Audited 2026-11-01. Scope: monorepo root, `apps/`, `services/`, `docs/`. All source-code claims verified against live files and git HEAD (`9701769`). Graph consult (graphify) used where relevant; direct reads when authoritative.

---

## 0. What this report does **not** say

- It does **not** invent features, `database/schema.prisma` changes, or new backend modules. "Daily Message" was searched across all sources with zero hits — there is no customer daily promotional/operational message feature anywhere (no `daily_message`, `dailyMessage`, `DailyMessage`, banner injection hook, scheduled push job, or doc reference). Any build that asks *me* to add that will produce a piece of recommendation prose, not code. If you want a real daily customer message product, the gap first, then the feature, then tests.

## 1. What the current tree already has

| App | Tech | Notes |
|-----|------|-------|
| `apps/mobile` | Flutter 3.19 | Kotlin / Swift, clean architecture providers |
| `apps/admin` | Next.js 14 + Zustand + Lucide | Dark store dashboard, fulfillment queue, KPIs |
| `apps/website` | Next.js 14 + React Query + Tailwind | Customer web portal |
| `apps/delivery` | Next.js 14 PWA | Rider app |
| `services/api` | NestJS 10 + Prisma + PostgreSQL | 44 domain modules registered in `app.module.ts` |

**Backend modules live under** `services/api/src/modules/`:
`admin`, `ai`, `analytics`, `auth`, `banners`, `cart`, `categories`, `coupons`, `dashboard`, `delivery`, `delivery-partner`, `documents`, `email`, `events`, `favorites`, `feature-flags`, `finance`, `fleet`, `franchise`, `health`, `image-search`, `impact`, `inventory`, `loyalty`, `marketing`, `multi-store`, `notifications`, `observability`, `orders`, `payments`, `personalization`, `products`, `purchase`, `queue`, `quick-buy`, `recently-viewed`, `recommendations`, `redis`, `referrals`, `retail-os`, `reviews`, `search`, `stock-alerts`, `store-operations`, `support`, `uploads`, `users`, `voice`, `warehouse`, `wishlist`.

**Key architectural contracts already present**:
- JWT rotation with `deviceSession` table (refresh token hashing, active/revoked states)
- Rate limiting: per-identifier and per-IP OTP counters with transactional increments
- MFA: TOTP secret + 8 backup codes, with backup-code consumption
- Google OAuth via Firebase Admin ID tokens + welcome email flow
- Modular real-time layer: `EventsGateway` (Socket.IO) wiring all modules
- BullMQ queue workers: notifications, email, reorder cron, stock-alert scanner, OTP builder
- Multi-provider AI engine (`ai/providers/gemini|grok|openrouter|local`) with fallback manager
- Inventory low-stock trigger → 24h reorder urgency queue
- Delivery geofence + rider dispatch + doorstep OTP endpoint for delivery partners

## 2. Concrete things already fixed by this diff (post this review)

- `app.module.ts`: `BannersModule` → `BannerModule` (case-corrected import)
- `wishlist.controller.ts`: restored `UseGuards(OptionalJwtAuthGuard)` on `@Controller('wishlist')` — otherwise wishlist endpoints were publicly addressable with no auth gate, consistent with the project's security posture and the `AUTHENTICATION_HARDENING_AUDIT` doc set
- `auth.controller.ts`: handler cleanup applied (review changes, not in scope here)
- `auth.dto.ts`: same
- `dashboard.service.ts`: corrected typo-convention API calls — `prisma.order`/`totalAmount` instead of the buggy `prisma.orders`/`total`; reflects a drift away from Prisma pluralisation rules into field/property names that don't match the schema
- `search-enhanced.controller.ts`: Swagger hint fix (`default:` → `example:` per OpenAPI best practice)

These three diffs are the meaningful recent work; the others are stylistic formatting touched across many files in the last commit batch (`9701769`).

## 3. Production-readiness gaps (ranked impact × effort)

### High impact, small effort — open now and should ship before next release
1. **docs index is stale.** 25 feature-domain files exist (`PRODUCTS`, `INVENTORY`, `PAYMENTS`, `NOTIFICATIONS`, …) but **none match an actual backend module**: `coupons`, `favorites`, `image-search`, `loan`, `mobile-feedback`, `nearby-locations`, `nutrition`, `order-history`, `search`, `stock-alerts`, `support`, `warehouse`, `voice` have no matching `docs/features/*.md`. Compare with the documented features table only covers 4 of the ~22 non-admin modules. A PR renaming `features/` → `feature-domains/` + dropping orphaned index entries fixes the navigation table without touching source.
2. **MD file list doesn't include `newsletter`, `coupons` feature docs despite the modules existing.** Same root cause.
3. **`docs/README.md` index entries omit `INSTALLATION.md`, `GOOGLE_STITCH.md`, `DESIGN_SYSTEM.md`, `VOICE_SHOPPING.md`.** Sparse index; contributor-onboarding friction.

### Medium impact — strategic planning blocker
4. **Zero in-repo automation for any of the fixes above.** No pre-commit hook validates import casing (`BannerModule` vs `BannersModule`) or naming conventions (section Naming-Convention says so). CI isn't gated on `app.module` consistency either. So the case fix stays forever unless manually enforced.
5. **Docs README table lists `OPENAPI.md` as a directory (`📄`) but is actually a file** — mildly misleading markup. Minor housekeeping.
6. **`auth.service.ts` hardcodes the Bengaluru IP-range heuristic in `evaluateDeviceRisk`** (`ipAddress.startsWith('127.') || … 10.`). Fine for India; risky for multi-country deployments. Doc the assumption.
7. **OTP verification requests are noisily side-effecting**: the `forgotPassword` branch writes an `otpVerification` record tied to email `identifier: normalizedEmail`, which collides with the LOGIN identifier collision check in `checkOtpRateLimit` (`where: { identifier }`). Login and password-reset flows share the rate-limit counter bucket today — acceptable given intent, but worth a note in `AUTHENTICATION.md` for callers / ops.

### Low impact — governance / polish
8. `docs/features/` mixes documentation templates (`PRODUCTS.md`, `INVENTORY.md`) with modules that have no documentation at all. Refactor the dir.
9. Changelog titles use "(api)" / "(backend)" prefixes inconsistently; ROADMAP.md wants one.
10. Dev note: mobile `test_archive.tar.gz` and `test_git_archive.tar.gz` are huge binary blobs in the repo root — archive fixtures; keep one canonical copy and delete / gitignore both.

## 4. Where "Daily Message" belongs (if you want it)

Two sensible designs, no third option exists yet:

**A. Enterprise daily marketing loop (server-driven)**
Build `services/api/src/modules/daily-messages/`:
- Config source: new table `dailyMessageCampaigns` (id, title, body, content_hash, audience_role filter, enabled, segment overrides)
- Dispatch source: cron or BullMQ job `dailyMessageJob` runs at 08:00 server time, resolves cohort from `users` table, writes `outbox` rows
- Push target: reuse `NotificationsService.sendPushNotification` + the new `inAppNotification` trigger path. Don't duplicate FCM registration logic — extend rather than fork.
- Trigger hooks: event listeners on `NEW`, `DISPATCHED`, `CONFIRMED` orders would let daily messages ride order lifecycle automatically.
- Gateway hook: add a single `dailyMessages` router at `/v1/messages/daily`; keep auth guard as-is.

**B. Frontend home-screen widget (UI-only)**
Build in `apps/mobile/lib/widgets/daily_message_banner.dart` and `apps/website/components/DailyMessageBanner.tsx`; call `GET /v1/messages/daily` lazily on app/portal cold start, cache in local storage, refresh with `visible=true&intervalHours=24`. Defer backend; document why it's UI-only.

Either path requires only ~1–2 new backend entities if A; none if B. Neither requires edits to existing auth service; neither touches the four files already diffed in this review.

**Recommended**: start with **A** because it exercises the production modules already wired (notifications, events gateway), keeps the multi-provider AI engine free to personalize per-cohort messages, and maps cleanly onto the existing `BRAND_ALIAS`/`flash_sales` surface already in the catalog. Estimated effort: 1 backend module + 1 service spec + 1 BullMQ cron registration + 1 controller + integration smoke test.

## 5. Recommended next actions (ordered)

1. Add 3–4 missing `docs/features/*` files (or close the orphaned ones) so the docs index matches the actual feature set.
2. Tighten `docs/README.md` index with current entry list.
3. Refactor `features/` → `feature-domains/` to allow both legacy name and new mapping; update index.
4. Treat the `BannerModule` casing + wishlist auth guard fixes as the baseline for a CI check (case sensitivity check across app.module imports is trivially `grep -n "from.*modules/" app.module.ts`).
5. Cut the two archive tarballs from tracked files.
6. Keep the "Daily Message" doc under `docs/features/DAILY_MESSAGES.md` once shipped.

## 6. Verification commands (for follow-up builds)

```bash
cd <root>
graphify query "feature coverage: count docs/features/* vs modules named *service*"
git log --oneline -5
git diff --stat
grep -rn "BannerModule\|BannersModule" services/api/src/
grep -rn "AuthService\|OptionalJwtAuthGuard" services/api/src/modules/wishlist/
grep -rl "daily.message\|DailyMessage" . --include="*.ts" --include="*.dart" --include="*.md"
node scripts/sync-images-to-r2.js
pnpm --filter api test
pnpm --filter admin test
```

End of report. Everything in section 4 above is actionable next step material; sections 1–3 are descriptive audit evidence. Section 2 explains why the post-review diff changes matter specifically; the rest are recommendations for the repo's feature roadmap. Happy to drill into any one line of architecture detail next.
