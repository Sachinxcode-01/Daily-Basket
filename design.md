# Design System: Daily Basket (Modern Quick-Commerce)

## 1. Overview & Brand Identity

**Daily Basket** is a high-speed, premium quick-commerce grocery delivery platform operating as an ultrafast local Kirana / fresh grocery service. The visual language conveys freshness, reliability, speed, and premium trust through vibrant organic emerald greens, pristine light surfaces, subtle glassmorphic chrome, and crisp Material Design 3 geometry.

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

### Grid & Spacing System

- **Base Grid**: `4px` baseline
- **Margin Mobile**: `16px` (`px-4` / `px-container-padding`)
- **Gutter Horizontal**: `12px`
- **Gutter Vertical**: `16px`
- **Touch Target Minimum**: `48px` (`h-12` / `min-h-[48px]`)

### Corner Radii

- **Input Fields & Small Cards**: `8px` (`rounded-lg` / `rounded-DEFAULT`)
- **Product Tiles & Bento Cards**: `16px` (`rounded-2xl`)
- **Bottom Navigation & Modal Sheets**: `24px` top corners (`rounded-t-3xl`)
- **Badges & Action Pills**: `9999px` (`rounded-full`)

### Elevation & Glassmorphism

- **Flat Surface**: `bg-surface-container-lowest` + subtle `border border-outline-variant/30`
- **Header Blur (Sticky/Fixed)**: `bg-surface/80 backdrop-blur-xl border-b border-outline-variant/20`
- **Bottom Navigation Shadow**: `shadow-[0px_-4px_16px_rgba(0,0,0,0.06)]`
- **Floating Pill / CTA**: `shadow-[0px_8px_20px_rgba(45,157,67,0.25)]`

---

## 5. Core Component Specifications

### 1. Navigation Header (Top App Bar)

- **Structure**: Leading icon (Back or Store Pin) + Center/Left Brand Title ("Daily Basket") + Trailing actions (Search / Basket / Notifications).
- **Style**: Sticky top bar, `h-14` or `h-16`, translucent glass backdrop (`backdrop-blur-xl`), `bg-surface/80`.
- **Text**: `font-headline text-headline-sm font-bold text-primary`.

### 2. Bottom Navigation Bar (Mobile Tab Shell)

- **Destinations (4 items)**:
  1. `Shop` / `Home` (`storefront` or `home`)
  2. `Categories` / `Search` (`grid_view` or `search`)
  3. `Orders` (`receipt_long` or `shopping_bag`)
  4. `Profile` (`person`)
- **Active State**: Pill indicator with `bg-secondary-container text-on-secondary-container` or `bg-primary/10 text-primary` with filled icon (`font-variation-settings: 'FILL' 1`).
- **Inactive State**: `text-on-surface-variant` with outlined icon (`font-variation-settings: 'FILL' 0`).

### 3. Product Catalog Card

- **Layout**: Vertical stack inside `rounded-2xl bg-surface-container-lowest border border-outline-variant/30 p-3`.
- **Image**: Square `aspect-square rounded-xl bg-surface-container-low overflow-hidden`, showing clean farm-fresh product photography.
- **Metadata**: Brand eyebrow (`DAILY BASKET SELECT` in `text-[10px] uppercase font-bold text-on-surface-subtle`), product title, weight variant (`200g`, `500g`, `1L`).
- **Pricing**: Primary price (`₹120` or `$4.50`) alongside crossed-out MRP (`₹140`), with a circular `+` Add button (`w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center active:scale-95`).
- **States**: In-Stock (`+` CTA), Out of Stock (desaturated product image with `Out of Stock` pill badge), Discount Tag (`10% OFF` in `bg-error text-white text-[10px] font-bold rounded px-1.5 py-0.5`).

### 4. Primary CTA Button

- **Height**: `48px` - `52px` minimum touch target.
- **Styling**: `w-full rounded-xl bg-primary hover:bg-primary-container text-white font-label-lg font-semibold shadow-md active:scale-[0.98] transition-all`.
- **Icon Support**: Optional trailing `arrow_forward` or leading `shopping_bag`.

### 5. Input Fields (Forms & Search)

- **Search Bar**: Full width, pill-shaped (`rounded-full bg-surface-container-low border border-outline-variant/40 px-4 py-3 flex items-center gap-3`).
- **Form Inputs**: Outlined style with floating/top labels in `font-label-md uppercase tracking-wider text-on-surface-subtle`, active green focus ring (`focus:border-primary focus:ring-1 focus:ring-primary`).

---

## 6. Iconography & Visual Assets

- **Icon System**: Google Material Symbols Outlined (`font-variation-settings: 'FILL' 0..1, 'wght' 400..600`).
- **Brand Imagery**: Natural lighting, clean minimalist composition, crisp white or light neutral backgrounds, farm-fresh produce emphasis.

---

## 7. Mandatory Design Instruction & Workflow

**CRITICAL**: Every time while designing or modifying UI/UX components, screens, or themes across all platforms (Flutter mobile, React/Next.js website, Admin dashboard, Delivery partner app):

1. **Always read and inspect `design.md`** first before making any UI decisions.
2. Adhere strictly to the exact hex codes, corner radii, typography hierarchy, elevation model, and component specifications documented in `design.md`.
3. Do not introduce ad-hoc colors or custom corner radii outside of this design system.
