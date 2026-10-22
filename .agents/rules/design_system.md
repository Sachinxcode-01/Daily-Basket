# Design System & UI/UX Workflow Rule

## Mandatory Instruction — `design.md` Single Source of Truth

Every time while designing, building, or modifying any UI/UX screen, component, style, or theme across any platform (`apps/website`, `apps/mobile`, `apps/admin`, `apps/delivery`, `apps/daily_basket_admin`, `@daily-basket/shared-ui`):

1. **Always read `design.md` first**:
   - Inspect `design.md` located in the project root before making any UI decisions or code edits.
2. **Strict Adherence**:
   - Follow the exact color tokens (e.g. `primary: #2d9d43`, `primary-container: #078730`, `surface: #f9f9fc`, `on-surface: #191c1e`, `status-success: #15803d`, etc.).
   - Follow the exact typography hierarchy using `Outfit` as Primary & Display font family.
   - Follow the exact corner radii: `8px` (`rounded-lg` / `ROUND_EIGHT`) for interactive elements/inputs/small cards, `16px` (`rounded-2xl`) for product tiles/bento cards, `24px` for bottom sheets, and `9999px` for pill badges.
   - Follow the exact elevation shadows and glassmorphic blur styles.
3. **No Drift / No Ad-hoc Styling**:
   - Never introduce unapproved colors, custom fonts, or arbitrary corner radii.
   - Any design tokens must be centralized in `@daily-basket/theme` and `@daily-basket/design-system`.
