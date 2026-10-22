# 💅 Shared Design System & Theme Reference — Daily Basket

> **Source of Truth**: See [`design.md`](file:///c:/Users/kalin/.gemini/antigravity-ide/scratch/daily-basket/design.md) in the project root for the authoritative specifications, tokens, and component guidelines.

---

## 1. Overview & Brand Identity

**Daily Basket** is a high-speed, premium quick-commerce grocery delivery platform operating as an ultrafast local Kirana / fresh grocery service.

- **Brand Tone**: Fresh, Reliable, Ultrafast, Premium, Friendly, Trustworthy.
- **Form Factor**: Mobile First (Flutter target: 390px base viewport, 8px grid), extensible to Desktop Admin & Web (React/Next.js).
- **Core Corner Radius**: `8px` (`ROUND_EIGHT` / `rounded-lg` / `rounded-xl` for interactive elements and bento cards).

---

## 2. Color Palette & Token System

### Primary & Brand Colors

| Token Name | Hex Code | Role & Usage |
| :--- | :--- | :--- |
| `primary` | `#2d9d43` | Main brand color, primary CTA buttons, active tab indicators, high-contrast badges |
| `primary-container` | `#078730` | High-emphasis accent container, elevated button states |
| `on-primary` | `#ffffff` | Text / icons on top of primary buttons |
| `on-primary-container` | `#f7fff2` | Text / icons inside deep primary containers |
| `primary-fixed` | `#8cfa93` | High-visibility badges, light tint backgrounds |
| `primary-fixed-dim` | `#70dd7a` | Dark mode primary accent, glowing borders |

### Surface & Background Tokens

| Token Name | Hex Code | Role & Usage |
| :--- | :--- | :--- |
| `surface` | `#f9f9fc` | Base app background canvas |
| `surface-dim` | `#dadadc` | Low-emphasis backdrop, separator lines |
| `surface-bright` | `#f9f9fc` | Elevated canvas highlights |
| `surface-container-lowest` | `#ffffff` | Card surfaces, modal sheets, product cards, input backgrounds |
| `surface-container-low` | `#f3f3f6` | Grouped list backgrounds, pill chips, secondary tiles |
| `surface-container` | `#eceef0` | Subtle contrast grouping, skeleton loaders |
| `surface-container-high` | `#e6e8ea` | Hover states, interactive item backgrounds |
| `surface-container-highest` | `#e0e3e5` | Inactive toggle states, dividers |

### Text & On-Surface Colors

| Token Name | Hex Code | Role & Usage |
| :--- | :--- | :--- |
| `on-surface` | `#191c1e` | High-emphasis body copy, headings, title text |
| `on-surface-variant` | `#3f4a3d` | Medium-emphasis labels, secondary details, timestamps |
| `on-surface-subtle` | `#64748b` | Muted captions, helper text, units (e.g. "500g", "1L") |
| `outline` | `#6e7a6c` | Focused input borders, structural card boundaries |
| `outline-variant` | `#becab9` | Hairline dividers, subtle card borders (`border-outline-variant/30`) |

### Semantic & Feedback Colors

| Token Name | Hex Code | Role & Usage |
| :--- | :--- | :--- |
| `status-success` | `#15803d` | In-stock badges, delivered status, savings (+14.2%) |
| `status-warning` | `#b45309` | Low stock notices, expedited delivery alerts |
| `status-error` / `error` | `#ba1a1a` | Out-of-stock badges, form errors, cancellation |
| `error-container` | `#ffdad6` | Error alert banners, warning container backgrounds |
| `status-info` | `#0369a1` | Informational callouts, delivery partner assignment |

---

## 3. Typography Hierarchy

**Font Family**: `Outfit` (Primary & Display), falling back to clean sans-serif.

| Style Role | Font | Size / Line Height | Weight | Letter Spacing |
| :--- | :--- | :--- | :--- | :--- |
| **Headline Large** | Outfit | `28px / 36px` | 700 (Bold) | `-0.02em` |
| **Headline Medium** | Outfit | `22px / 28px` | 600 (SemiBold) | `normal` |
| **Headline Small** | Outfit | `18px / 24px` | 600 (SemiBold) | `normal` |
| **Title Medium** | Outfit | `16px / 24px` | 600 (SemiBold) | `normal` |
| **Body Large** | Outfit | `16px / 24px` | 400 (Regular) | `normal` |
| **Body Medium** | Outfit | `14px / 20px` | 400 (Regular) | `normal` |
| **Body Small** | Outfit | `12px / 16px` | 400 (Regular) | `normal` |
| **Label Large** | Outfit | `14px / 20px` | 600 (SemiBold) | `0.1px` |
| **Label Medium** | Outfit | `12px / 16px` | 600 (SemiBold) | `0.5px` |

---

## 4. Spacing, Elevation & Shapes

- **Base Grid**: `4px` baseline
- **Margin Mobile**: `16px` (`px-4` / `px-container-padding`)
- **Gutter Horizontal**: `12px`, Vertical: `16px`
- **Touch Target Minimum**: `48px`
- **Corner Radii**: `8px` (Inputs & small cards), `16px` (Product tiles & bento cards), `24px` (Bottom navigation & modal sheets), `9999px` (Badges & pills).
- **Elevation**: Flat surface + subtle `border border-outline-variant/30`, Header blur `backdrop-blur-xl`, Floating pill `shadow-[0px_8px_20px_rgba(45,157,67,0.25)]`.

---

## 5. Shared Monorepo Packages

- `@daily-basket/theme`: Standard branding constants, primary hex tokens, dark-mode CSS variables.
- `@daily-basket/design-system`: Tailwind configuration presets and reusable token utilities.
- `@daily-basket/shared-ui`: Shared UI components (`Button`, `Card`, `Badge`, `Modal`, `Input`).
