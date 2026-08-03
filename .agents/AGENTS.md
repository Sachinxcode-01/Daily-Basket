# Project Rules — Daily Basket

## Mandatory Instruction — Google Stitch Design Source of Truth

The **Google Stitch project is the single source of truth for all UI/UX**.

### Priority Order for Conflicts:
1. Latest User Instruction
2. Google Stitch Design Project
3. Product Requirement Document (PRD)
4. Technical Requirement Document (TRD)
5. Architecture Specifications
6. Coding Standards

### Mandatory UI/UX Implementation Rules:
- Always reference the approved Google Stitch design before implementing any screen or component.
- Maintain complete visual consistency across:
  - Flutter Mobile App (`apps/mobile`)
  - Next.js Customer Website (`apps/website`)
  - Next.js Admin Dashboard (`apps/admin`)
  - Delivery Partner Application (`apps/delivery`)
- Do NOT redesign, replace, simplify, or modernize any screen or component without explicit user approval.
- Maintain exact layouts, spacing, typography hierarchy, colors, icons, illustrations, cards, component sizes, animations, flows, and states (loading, empty, success, error) defined by the approved Stitch design.
- Reuse components from `@daily-basket/shared-ui` and `@daily-basket/design-system` to maintain zero duplicate code across platforms.
