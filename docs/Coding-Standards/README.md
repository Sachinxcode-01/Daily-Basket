# Coding Standards & Design Source Hierarchy - Daily Basket

## 1. Single Source of Truth for UI/UX
The **Google Stitch project** is the single source of truth for all user interface, design tokens, component hierarchy, animations, and user experience across all four applications (Mobile, Website, Admin, Delivery).

### Priority Order for Implementation Decisions:
1. **User Directives**: Latest instruction from the user.
2. **Google Stitch Design**: Authoritative UI/UX, layouts, colors, spacing, typography, states.
3. **PRD**: Product scope and business feature matrix.
4. **TRD**: Technical requirements and non-functional goals.
5. **Architecture Documents**: Monorepo and clean architecture specifications.
6. **Coding Standards**: SOLID, DRY, KISS, and type safety guidelines.

## 2. Core Engineering Principles
- **SOLID**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
- **DRY**: Don't Repeat Yourself (Extract shared types, utils, and UI components into `@daily-basket/packages`).
- **KISS**: Keep It Simple, Stupid.
- **Type Safety**: No usage of `any` in TypeScript. All API contracts must strictly declare explicit interfaces and DTOs.
