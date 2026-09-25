import masterCatalogJson from '@daily-basket/shared-types/src/products_catalog.json';

export interface WebsiteProduct {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  unitName: string;
  price: number;
  mrp: number;
  discount: number;
  rating?: number;
  reviews?: number;
  category: string;
  categorySlug: string;
  tag?: string;
  image: string;
  images: string[];
  isOrganic: boolean;
  description: string;
  inStock: boolean;
}

export function normalizeImagePath(raw?: string): string {
  if (!raw) return '/images/daily_basket_logo.png';
  if (raw.startsWith('assets/')) {
    return `/${raw.replace(/^assets\//, '')}`;
  }
  return raw;
}

export const CATEGORY_DISPLAY_MAP: Record<string, { name: string; slug: string }> = {
  'fresh-vegetables': { name: 'Fresh Vegetables', slug: 'fresh-vegetables' },
  'dairy-bread-eggs': { name: 'Dairy, Bread & Eggs', slug: 'dairy-bread-eggs' },
  'bread-pav': { name: 'Bread & Pav', slug: 'bread-pav' },
  'milk': { name: 'Fresh Milk', slug: 'milk' },
  'curd-yogurt': { name: 'Curd & Yogurt', slug: 'curd-yogurt' },
  'flakes-kids-cereals': { name: 'Flakes & Cereals', slug: 'flakes-kids-cereals' },
  'poha-daliya-grains': { name: 'Poha, Daliya & Grains', slug: 'poha-daliya-grains' },
  'vermicelli': { name: 'Vermicelli', slug: 'vermicelli' },
  'grocery': { name: 'Grocery & Staples', slug: 'grocery' },
};

export const ALL_WEBSITE_PRODUCTS: WebsiteProduct[] = Object.entries(
  masterCatalogJson as Record<string, any[]>,
).flatMap(([catKey, items]) => {
  const meta = CATEGORY_DISPLAY_MAP[catKey] || {
    name: catKey.replace(/-/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase()),
    slug: catKey,
  };

  return items.map((p) => {
    const webImage = normalizeImagePath(p.image);
    const price = Number(p.price) || 0;
    const mrp = Number(p.mrp) || price;
    const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
    const isOrganic = Boolean(
      p.badge?.toLowerCase().includes('organic') ||
        p.category?.toLowerCase() === 'organic' ||
        p.name.toLowerCase().includes('organic'),
    );

    return {
      id: p.id,
      variantId: `var_${p.id}`,
      name: p.name,
      brand: p.brand || 'Daily Basket Select',
      unitName: p.unit || p.subtitle || '1 unit',
      price,
      mrp,
      discount,
      rating: p.rating || 4.5,
      reviews: parseInt(p.reviews, 10) || 128,
      category: meta.name,
      categorySlug: meta.slug,
      tag: p.badge || (discount > 0 ? `${discount}% OFF` : undefined),
      image: webImage,
      images: [webImage],
      isOrganic,
      description: `${p.name} (${p.subtitle || p.unit}). Fresh quality guaranteed by Daily Basket. Delivered in 10 minutes.`,
      inStock: p.inStock ?? true,
    };
  });
});

export function getProductById(id: string): WebsiteProduct | undefined {
  return ALL_WEBSITE_PRODUCTS.find(
    (p) => p.id === id || p.id === `prod_${id}` || p.id.replace('prod_', '') === id,
  );
}

export function searchProducts(query: string, categoryFilter?: string): WebsiteProduct[] {
  const q = query.trim().toLowerCase();
  return ALL_WEBSITE_PRODUCTS.filter((p) => {
    const matchesCategory =
      !categoryFilter ||
      categoryFilter === 'All' ||
      p.category.toLowerCase() === categoryFilter.toLowerCase() ||
      p.categorySlug.toLowerCase() === categoryFilter.toLowerCase();

    if (!matchesCategory) return false;
    if (!q) return true;

    return (
      p.name.toLowerCase().includes(q) ||
      p.brand.toLowerCase().includes(q) ||
      p.unitName.toLowerCase().includes(q) ||
      p.category.toLowerCase().includes(q)
    );
  });
}
