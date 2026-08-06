# 🎨 Google Stitch Design Source of Truth — Daily Basket

## MANDATORY INSTRUCTION

The **Google Stitch project is the single source of truth for all UI/UX** across the Daily Basket monorepo.

---

## 1. Conflict Priority Order

1. **Latest User Directives**: Explicit instructions provided by the user.
2. **Google Stitch Design Project**: Authoritative UI/UX, layouts, spacing, color palettes, typography hierarchy, component sizes, micro-animations, and visual states.
3. **Product Requirement Document (PRD)**: Scope and features matrix.
4. **Technical Requirement Document (TRD)**: Technical SLAs.
5. **Architecture Specs**: System boundaries and monorepo structure.

---

## 2. Platform Consistency Guidelines

All four applications must maintain complete visual parity with Google Stitch design specifications:
- **Flutter Customer Mobile App** (`apps/mobile`)
- **Next.js Customer Website** (`apps/website`)
- **Next.js Store Admin Dashboard** (`apps/admin`)
- **Next.js Delivery Partner PWA** (`apps/delivery`)

Re-use design tokens and components from `@daily-basket/design-system`, `@daily-basket/theme`, and `@daily-basket/shared-ui` to guarantee zero visual drift or duplicate code.
