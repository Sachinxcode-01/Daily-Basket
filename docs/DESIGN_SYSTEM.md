# 💅 Shared Design System & Theme Reference — Daily Basket

This document describes the design tokens, color palettes, typography scale, and component usage guidelines distributed via `@daily-basket/design-system` and `@daily-basket/theme`.

---

## 1. Color Palette Tokens

| Token Name | Hex Code | Purpose |
| :--- | :--- | :--- |
| `--color-primary` | `#22c55e` | Daily Basket Emerald Green (Primary Action Buttons, ETAs) |
| `--color-primary-dark` | `#16a34a` | Hover / Active State Green |
| `--color-background` | `#0f172a` | Slate Dark Mode Core Background |
| `--color-surface` | `#1e293b` | Glassmorphic Cards & Surface Panels |
| `--color-accent` | `#eab308` | Flash Sale Gold & VIP Badges |
| `--color-danger` | `#ef4444` | Out of Stock & Cancelled Order Warnings |

---

## 2. Typography Scale

- **Headings**: Google Fonts `Inter` / `Outfit` (Bold / SemiBold)
- **Body & Microcopy**: Google Fonts `Inter` (Regular / Medium)
- **Scale**:
  - `Display`: 32px / 40px line-height
  - `H1`: 24px / 32px line-height
  - `H2`: 20px / 28px line-height
  - `Body`: 14px / 20px line-height
  - `Caption`: 12px / 16px line-height

---

## 3. Shared Packages

- `@daily-basket/theme`: Standard branding constants, primary hex tokens, dark-mode CSS variables.
- `@daily-basket/design-system`: Tailwind configuration presets and reusable token utilities.
- `@daily-basket/shared-ui`: Shared React components (`Button`, `Card`, `Badge`, `Modal`, `Input`).
