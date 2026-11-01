# 🍎 Products & Catalog Specification — Daily Basket (`docs/features/PRODUCTS.md`)

This document describes product catalog management, category taxonomy, search index matching, brand aliases, and product variants.

---

## 1. Catalog Data Structure

- **Category Taxonomy**: Categories support nested sub-categories (`Category.parentId`). Features icon names, banner images, and featured status (`Category.isFeatured`).
- **Products**: Products (`Product`) belong to a store and category. Include search keywords (`searchKeywords`), brand aliases (`brandAliases`), organic flags (`isOrganic`), and tag lists.
- **Product Variants**: Each product contains one or more variants (`ProductVariant`), tracking unit name (`500g`, `1 kg`), MRP, selling price, SKU, and availability.
