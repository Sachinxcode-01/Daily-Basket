import catalogJson from '@daily-basket/shared-types/src/products_catalog.json';

// In-memory catalog overlay for standalone Next.js admin server mode
let memoryProducts: any[] = [];
const deletedProductIds = new Set<string>();
const productOverrides = new Map<string, any>();

export function initCatalog() {
  if (memoryProducts.length === 0) {
    const raw: any[] = Object.values(catalogJson as Record<string, any[]>).flat();
    memoryProducts = raw.map((p, idx) => {
      const price = Number(p.price) || 0;
      const mrp = Number(p.mrp) || price;
      const webImg = p.image?.startsWith('assets/') ? `/${p.image.replace(/^assets\//, '')}` : p.image;
      return {
        id: p.id,
        name: p.name,
        slug: p.id,
        brand: (p.brand || 'Daily Basket').toUpperCase(),
        sku: `SKU-${p.id.replace('prod_', '').toUpperCase()}`,
        category: {
          id: p.categorySlug || 'produce',
          name: p.category || p.sub || 'Produce',
          slug: p.categorySlug || 'produce',
        },
        description: `${p.name}. Quality checked fresh essentials.`,
        images: [webImg || '/images/daily_basket_logo.png'],
        variants: [
          {
            id: `var_${p.id}`,
            unitName: p.unit || p.subtitle || '1 unit',
            price,
            mrp,
            sku: `SKU-${p.id.replace('prod_', '').toUpperCase()}`,
            isAvailable: p.inStock ?? true,
            stockQuantity: 250 - (idx % 15) * 5,
          },
        ],
      };
    });
  }
}

export function getFilteredProducts(categoryId?: string | null, query?: string | null) {
  initCatalog();
  let list = memoryProducts
    .filter((p) => !deletedProductIds.has(p.id))
    .map((p) => {
      const override = productOverrides.get(p.id);
      if (!override) return p;
      return {
        ...p,
        ...override,
        variants: p.variants.map((v: any) => ({
          ...v,
          ...(override.price !== undefined && { price: override.price }),
          ...(override.mrp !== undefined && { mrp: override.mrp }),
          ...(override.unitName !== undefined && { unitName: override.unitName }),
          ...(override.stockQuantity !== undefined && {
            stockQuantity: override.stockQuantity,
            isAvailable: override.stockQuantity > 0,
          }),
        })),
      };
    });

  if (categoryId && categoryId !== 'All') {
    const cleanCat = categoryId.toLowerCase();
    list = list.filter(
      (p) =>
        p.category?.name?.toLowerCase().includes(cleanCat) ||
        p.category?.slug?.toLowerCase() === cleanCat
    );
  }

  if (query) {
    const q = query.toLowerCase();
    list = list.filter(
      (p) =>
        p.name.toLowerCase().includes(q) ||
        p.brand.toLowerCase().includes(q) ||
        p.sku.toLowerCase().includes(q)
    );
  }

  return list;
}

export function addProductMemory(product: any) {
  initCatalog();
  memoryProducts.unshift(product);
}

export function deleteProductMemory(id: string) {
  deletedProductIds.add(id);
}

export function updateProductMemory(id: string, updates: any) {
  const current = productOverrides.get(id) || {};
  productOverrides.set(id, { ...current, ...updates });
}
