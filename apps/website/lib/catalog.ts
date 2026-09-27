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

const CANONICAL_CATEGORIES = [
  'bread-pav',
  'fresh-vegetables',
  'curd-yogurt',
  'flakes-kids-cereals',
  'milk',
  'poha-daliya-grains',
  'vermicelli',
];

export const ALL_WEBSITE_PRODUCTS: WebsiteProduct[] = CANONICAL_CATEGORIES.flatMap((catKey) => {
  const items = (masterCatalogJson as Record<string, any[]>)[catKey] || [];
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
  const norm = (s: string) =>
    (s || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/['"’-]/g, ' ')
      .replace(/(\d+)(kg|g|l|ml|pc|pcs)/g, '$1 $2');

  const qClean = norm(query);
  const tokens = qClean.split(/\s+/).filter(Boolean);

  return ALL_WEBSITE_PRODUCTS.filter((p) => {
    const matchesCategory =
      !categoryFilter ||
      categoryFilter === 'All' ||
      p.category.toLowerCase() === categoryFilter.toLowerCase() ||
      p.categorySlug.toLowerCase() === categoryFilter.toLowerCase();

    if (!matchesCategory) return false;
    if (tokens.length === 0) return true;

    const name = norm(p.name);
    const brand = norm(p.brand);
    const unit = norm(p.unitName);
    const cat = norm(p.category);
    const slug = norm(p.categorySlug);
    const tag = norm(p.tag || '');

    let synonyms = '';
    if (slug.includes('vegetables') || cat.includes('veg')) {
      synonyms += ' vegetable vegetables veggie veggies sabzi greens ';
    }
    if (slug.includes('bread') || cat.includes('bakery') || name.includes('bread') || name.includes('pav')) {
      synonyms += ' bread bakery pav bun toast rusk ';
    }
    if (slug.includes('milk') || cat.includes('milk')) {
      synonyms += ' milk dairy doodh ';
    }
    if (slug.includes('curd') || cat.includes('curd') || name.includes('dahi') || name.includes('yogurt')) {
      synonyms += ' curd yogurt dahi yoghurt probiotics ';
    }
    if (slug.includes('flakes') || cat.includes('cereal') || name.includes('corn') || name.includes('chocos')) {
      synonyms += ' flakes cereal cereals breakfast cornflakes chocos muesli granola ';
    }
    if (slug.includes('poha') || cat.includes('grain') || name.includes('dalia') || name.includes('poha')) {
      synonyms += ' poha daliya dalia grains staples atta dal pulses rice ';
    }
    if (slug.includes('vermicelli') || name.includes('seviyan') || name.includes('upma') || cat.includes('vermicelli')) {
      synonyms += ' vermicelli seviyan sevai semiya upma noodles pasta ';
    }

    const fullText = `${name} ${brand} ${unit} ${cat} ${slug} ${tag} ${synonyms}`;
    return tokens.every((token) => fullText.includes(token));
  });
}

