# Project Rules — Daily Basket

## Mandatory Instruction — `design.md` & Google Stitch Design Source of Truth

The **`design.md` file (in project root) is the single source of truth for all UI/UX tokens, typography, colors, and layout rules**.

### Priority Order for Conflicts

1. Latest User Instruction
2. `design.md` (Project Root) & Approved Google Stitch Design
3. Product Requirement Document (PRD)
4. Technical Requirement Document (TRD)
5. Architecture Specifications
6. Coding Standards

### Mandatory UI/UX Implementation Rules

- **Always read and inspect `design.md` before implementing or updating any screen or component.**
- Maintain complete visual consistency across:
  - Flutter Mobile App (`apps/mobile`)
  - Next.js Customer Website (`apps/website`)
  - Next.js Admin Dashboard (`apps/admin`)
  - Delivery Partner Application (`apps/delivery`)
- Do NOT redesign, replace, simplify, or modernize any screen or component without explicit user approval.
- Maintain exact layouts, spacing, typography hierarchy (`Outfit`), colors (`primary: #2d9d43`), corner radii (8px/16px/24px/9999px), animations, flows, and states defined by `design.md`.
- Reuse components from `@daily-basket/shared-ui` and `@daily-basket/design-system` to maintain zero duplicate code across platforms.
