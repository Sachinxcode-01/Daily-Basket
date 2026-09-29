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

// ─── Feature 2: Frequently Bought Together & Smart Bundles ──────────────

export interface ProductBundleItem {
  productId: string;
  variantId: string;
  productName: string;
  unitName: string;
  price: number;
  mrp: number;
  imageUrl: string;
}

export interface ProductBundle {
  id: string;
  title: string;
  description: string;
  badge: string;
  items: ProductBundleItem[];
  originalPrice: number;
  bundlePrice: number;
  savings: number;
  savingsPercent: number;
}

export function getProductBundle(productId: string): ProductBundle | null {
  const current = getProductById(productId);
  if (!current) return null;

  let companionCandidates: WebsiteProduct[] = [];
  let bundleTitle = 'Frequently Bought Together';
  let bundleDesc = 'Add the full set to your cart and save extra.';

  const slug = current.categorySlug.toLowerCase();
  const name = current.name.toLowerCase();

  if (slug.includes('milk')) {
    bundleTitle = 'Morning Breakfast Combo';
    bundleDesc = 'Fresh milk paired with wholesome breakfast staples.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && (p.categorySlug === 'bread-pav' || p.categorySlug === 'flakes-kids-cereals'),
    );
  } else if (slug.includes('bread')) {
    bundleTitle = 'Tea & Toast Pair';
    bundleDesc = 'Bakery-fresh loaf with farm milk for your daily morning routine.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && (p.categorySlug === 'milk' || p.categorySlug === 'curd-yogurt'),
    );
  } else if (slug.includes('vegetables')) {
    bundleTitle = 'Kitchen Daily Essentials Kit';
    bundleDesc = 'Complementary fresh kitchen staples harvested today.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && p.categorySlug === 'fresh-vegetables',
    );
  } else if (slug.includes('flakes') || slug.includes('cereal')) {
    bundleTitle = 'Healthy Cereal Morning Bowl';
    bundleDesc = 'Crunchy cereal with chilled pasteurized farm fresh milk.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && p.categorySlug === 'milk',
    );
  } else if (slug.includes('curd')) {
    bundleTitle = 'Probiotic Daily Bowl';
    bundleDesc = 'Creamy fresh curd with grains and healthy breakfast companions.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && (p.categorySlug === 'poha-daliya-grains' || p.categorySlug === 'vermicelli'),
    );
  } else {
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter((p) => p.id !== current.id);
  }

  // Pick 1 or 2 distinct companion items
  const companions = companionCandidates.slice(0, 2);
  if (companions.length === 0) return null;

  const bundleItems: ProductBundleItem[] = [
    {
      productId: current.id,
      variantId: current.variantId,
      productName: current.name,
      unitName: current.unitName,
      price: current.price,
      mrp: current.mrp,
      imageUrl: current.image,
    },
    ...companions.map((c) => ({
      productId: c.id,
      variantId: c.variantId,
      productName: c.name,
      unitName: c.unitName,
      price: c.price,
      mrp: c.mrp,
      imageUrl: c.image,
    })),
  ];

  const originalPrice = bundleItems.reduce((acc, it) => acc + it.price, 0);
  const savingsPercent = 12; // 12% combo bundle discount
  const bundlePrice = Math.round(originalPrice * (1 - savingsPercent / 100));
  const savings = originalPrice - bundlePrice;

  return {
    id: `bundle_${current.id}`,
    title: bundleTitle,
    description: bundleDesc,
    badge: `SAVE ${savingsPercent}% COMBO`,
    items: bundleItems,
    originalPrice,
    bundlePrice,
    savings,
    savingsPercent,
  };
}

// ─── Feature 4: Out-of-Stock Smart Substitutes ─────────────────────────

export interface ProductSubstitute {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  unitName: string;
  price: number;
  mrp: number;
  imageUrl: string;
  rating: number;
  inStock: boolean;
  matchScore: number;
  similarityReason: string;
}

export function getProductSubstitutes(productId: string): ProductSubstitute[] {
  const current = getProductById(productId);
  if (!current) return [];

  const candidates = ALL_WEBSITE_PRODUCTS.filter(
    (p) => p.id !== current.id && p.inStock,
  );

  // Score candidate relevance
  const scored = candidates.map((p) => {
    let score = 50;
    let reason = 'Popular pantry item in this price range';

    if (p.categorySlug === current.categorySlug) {
      score += 35;
      reason = 'Same category & closest taste profile';
    }

    if (p.brand === current.brand) {
      score += 10;
      reason = `Same brand (${current.brand})`;
    }

    const priceDiff = Math.abs(p.price - current.price);
    if (priceDiff <= 20) {
      score += 8;
      reason = 'Closest match in price & pack size';
    }

    if (p.isOrganic === current.isOrganic) {
      score += 5;
    }

    const finalScore = Math.min(99, Math.max(75, score));

    return {
      id: p.id,
      variantId: p.variantId,
      name: p.name,
      brand: p.brand,
      unitName: p.unitName,
      price: p.price,
      mrp: p.mrp,
      imageUrl: p.image,
      rating: p.rating || 4.5,
      inStock: p.inStock,
      matchScore: finalScore,
      similarityReason: reason,
    };
  });

  scored.sort((a, b) => b.matchScore - a.matchScore);
  return scored.slice(0, 3);
}

// ─── Feature 3: Advanced Product Filters & Sorting ──────────────────────

export interface AdvancedFilterState {
  dietary: 'all' | 'organic' | 'vegan' | 'gluten_free' | 'sugar_free' | 'high_protein';
  priceBracket: 'all' | 'under_50' | '50_150' | '150_300' | 'above_300';
  sortBy: 'featured' | 'price_asc' | 'price_desc' | 'rating' | 'discount';
  inStockOnly: boolean;
  brand?: string;
}

export const INITIAL_FILTER_STATE: AdvancedFilterState = {
  dietary: 'all',
  priceBracket: 'all',
  sortBy: 'featured',
  inStockOnly: false,
  brand: undefined,
};

export function filterAndSortWebsiteProducts(
  products: WebsiteProduct[],
  filters: AdvancedFilterState,
): WebsiteProduct[] {
  let list = [...products];

  // In-stock
  if (filters.inStockOnly) {
    list = list.filter((p) => p.inStock);
  }

  // Dietary
  if (filters.dietary !== 'all') {
    list = list.filter((p) => {
      const nameLow = p.name.toLowerCase();
      const slugLow = p.categorySlug.toLowerCase();
      switch (filters.dietary) {
        case 'organic':
          return p.isOrganic;
        case 'vegan':
          return !slugLow.includes('milk') && !slugLow.includes('curd') && !nameLow.includes('ghee') && !nameLow.includes('butter');
        case 'gluten_free':
          return !slugLow.includes('bread') && !slugLow.includes('vermicelli') && !nameLow.includes('wheat');
        case 'sugar_free':
          return slugLow.includes('vegetables') || slugLow.includes('grain') || nameLow.includes('unsweetened');
        case 'high_protein':
          return slugLow.includes('curd') || slugLow.includes('milk') || nameLow.includes('oats') || nameLow.includes('soya');
        default:
          return true;
      }
    });
  }

  // Price Bracket
  if (filters.priceBracket !== 'all') {
    list = list.filter((p) => {
      switch (filters.priceBracket) {
        case 'under_50':
          return p.price < 50;
        case '50_150':
          return p.price >= 50 && p.price <= 150;
        case '150_300':
          return p.price > 150 && p.price <= 300;
        case 'above_300':
          return p.price > 300;
        default:
          return true;
      }
    });
  }

  // Brand
  if (filters.brand && filters.brand !== 'All') {
    list = list.filter((p) => p.brand.toLowerCase() === filters.brand?.toLowerCase());
  }

  // Sorting
  switch (filters.sortBy) {
    case 'price_asc':
      list.sort((a, b) => a.price - b.price);
      break;
    case 'price_desc':
      list.sort((a, b) => b.price - a.price);
      break;
    case 'rating':
      list.sort((a, b) => (b.rating || 0) - (a.rating || 0));
      break;
    case 'discount':
      list.sort((a, b) => b.discount - a.discount);
      break;
    case 'featured':
    default:
      // Preserve catalog natural ordering
      break;
  }

  return list;
}


