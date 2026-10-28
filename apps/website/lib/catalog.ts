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
  subCategory?: string;
  categorySlug: string;
  tag?: string;
  image: string;
  images: string[];
  isOrganic: boolean;
  isVeg: boolean;
  description: string;
  ingredients?: string;
  storage?: string;
  shelfLife?: string;
  nutrition?: Record<string, string>;
  keyBenefits?: string[];
  chefTip?: string;
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

export const ALL_WEBSITE_PRODUCTS: WebsiteProduct[] = (() => {
  const seenIds = new Set<string>();
  const allList: WebsiteProduct[] = [];

  // Helper to map raw catalog product
  const mapRawProduct = (p: any, defaultCatKey = 'grocery'): WebsiteProduct => {
    const catKey = p.categorySlug || p.folder || defaultCatKey;
    const meta = CATEGORY_DISPLAY_MAP[catKey] || {
      name: p.category || catKey.replace(/-/g, ' ').replace(/\b\w/g, (c: string) => c.toUpperCase()),
      slug: catKey,
    };
    const webImage = normalizeImagePath(p.image);
    const price = Number(p.price) || 0;
    const mrp = Number(p.mrp) || price;
    const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
    const isOrganic = Boolean(
      p.isOrganic ?? (
        p.badge?.toLowerCase().includes('organic') ||
        p.category?.toLowerCase().includes('organic') ||
        p.name?.toLowerCase().includes('organic')
      )
    );
    const isVeg = p.isVeg ?? (!p.name?.toLowerCase().includes('egg') && !p.name?.toLowerCase().includes('chicken') && !p.name?.toLowerCase().includes('sausage'));

    const description = p.description ||
      `${p.name} (${p.unit || p.subtitle || 'Standard Pack'}). Fresh farm-to-table quality guaranteed by Daily Basket. Delivered in 10 minutes.`;

    return {
      id: p.id,
      variantId: `var_${p.id}`,
      name: p.name,
      brand: p.brand || 'Daily Basket Select',
      unitName: p.unit || p.subtitle || '1 unit',
      price,
      mrp,
      discount,
      rating: Number(p.rating) || 4.7,
      reviews: parseInt(p.reviews, 10) || 320,
      category: meta.name,
      subCategory: p.sub || meta.name,
      categorySlug: meta.slug,
      tag: p.badge || (discount > 0 ? `${discount}% OFF` : undefined),
      image: webImage,
      images: [webImage],
      isOrganic,
      isVeg,
      description,
      ingredients: p.ingredients,
      storage: p.storage || 'Store in a cool and dry place away from direct sunlight.',
      shelfLife: p.shelfLife || 'Fresh Harvest / Packed Fresh Daily',
      nutrition: p.nutrition,
      keyBenefits: Array.isArray(p.keyBenefits) ? p.keyBenefits : undefined,
      chefTip: p.chefTip,
      inStock: p.inStock ?? true,
    };
  };

  // 1. Process canonical categories
  for (const catKey of CANONICAL_CATEGORIES) {
    const items = (masterCatalogJson as Record<string, any[]>)[catKey] || [];
    for (const p of items) {
      if (p?.id && !seenIds.has(p.id)) {
        seenIds.add(p.id);
        allList.push(mapRawProduct(p, catKey));
      }
    }
  }

  // 2. Also process 'all' or any remaining keys to guarantee all 607 products are present
  const masterAll = (masterCatalogJson as Record<string, any[]>).all || [];
  for (const p of masterAll) {
    if (p?.id && !seenIds.has(p.id)) {
      seenIds.add(p.id);
      allList.push(mapRawProduct(p, p.categorySlug || 'grocery'));
    }
  }

  return allList;
})();

export function getProductById(id: string): WebsiteProduct | undefined {
  if (!id) return undefined;
  const cleanId = decodeURIComponent(id).trim().toLowerCase();

  // 1. Direct ID match
  let found = ALL_WEBSITE_PRODUCTS.find((p) => p.id.toLowerCase() === cleanId);
  if (found) return found;

  // 2. Match with or without prod_ prefix
  found = ALL_WEBSITE_PRODUCTS.find(
    (p) =>
      `prod_${p.id.toLowerCase()}` === cleanId ||
      p.id.toLowerCase().replace(/^prod_/, '') === cleanId ||
      cleanId.replace(/^prod_/, '') === p.id.toLowerCase().replace(/^prod_/, ''),
  );
  if (found) return found;

  // 3. Substring match (e.g. slug ending with prod_veg_001)
  found = ALL_WEBSITE_PRODUCTS.find(
    (p) =>
      cleanId.includes(p.id.toLowerCase()) ||
      p.id.toLowerCase().includes(cleanId) ||
      (p.variantId && cleanId.includes(p.variantId.toLowerCase())),
  );
  if (found) return found;

  // 4. Slugified name match
  found = ALL_WEBSITE_PRODUCTS.find((p) => {
    const slugName = p.name.toLowerCase().replace(/[^a-z0-9]+/g, '-');
    return cleanId.includes(slugName) || slugName.includes(cleanId);
  });
  if (found) return found;

  // 5. Name contains or equals
  found = ALL_WEBSITE_PRODUCTS.find(
    (p) => p.name.toLowerCase() === cleanId || p.name.toLowerCase().includes(cleanId),
  );
  if (found) return found;

  return undefined;
}

export interface WebsiteCategory {
  id: string;
  name: string;
  slug: string;
  imageUrl?: string;
  bannerImage?: string;
  itemCount?: number;
}

export const STATIC_CATEGORIES: WebsiteCategory[] = CANONICAL_CATEGORIES.map((slug) => {
  const meta = CATEGORY_DISPLAY_MAP[slug] || {
    name: slug.replace(/-/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase()),
    slug,
  };
  const firstProd = ALL_WEBSITE_PRODUCTS.find((p) => p.categorySlug === slug);
  const count = ALL_WEBSITE_PRODUCTS.filter((p) => p.categorySlug === slug).length;
  return {
    id: slug,
    name: meta.name,
    slug: meta.slug,
    imageUrl: firstProd?.image || '/images/daily_basket_logo.png',
    bannerImage: firstProd?.image,
    itemCount: count,
  };
});

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
    const sub = norm(p.subCategory || '');
    const slug = norm(p.categorySlug);
    const tag = norm(p.tag || '');

    let synonyms = '';
    if (slug.includes('vegetables') || cat.includes('veg')) {
      synonyms += ' vegetable vegetables veggie veggies sabzi greens ';
    }
    if (slug.includes('bread') || cat.includes('bakery') || name.includes('bread') || name.includes('pav')) {
      synonyms += ' bread bakery pav bun toast rusk loaf sourdough ';
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

    const fullText = `${name} ${brand} ${unit} ${cat} ${sub} ${slug} ${tag} ${synonyms}`;
    return tokens.every((token) => fullText.includes(token));
  });
}

// ─── Recommendation Engine: Similar & Related Products ──────────────────

export function getSimilarProducts(productId: string, limit = 6): WebsiteProduct[] {
  const current = getProductById(productId);
  if (!current) return ALL_WEBSITE_PRODUCTS.slice(0, limit);

  // 1. Same subcategory, excluding current
  const sameSub = ALL_WEBSITE_PRODUCTS.filter(
    (p) => p.id !== current.id && p.subCategory && p.subCategory === current.subCategory,
  );

  // 2. Same category
  const sameCategory = ALL_WEBSITE_PRODUCTS.filter(
    (p) => p.id !== current.id && p.categorySlug === current.categorySlug && (!p.subCategory || p.subCategory !== current.subCategory),
  );

  // Sort by rating & discount
  const sorted = [...sameSub, ...sameCategory].sort((a, b) => {
    return (b.rating || 0) - (a.rating || 0);
  });

  return sorted.slice(0, limit);
}

// ─── Recommendation Engine: Customers Also Viewed ──────────────────────

export function getCustomersAlsoViewed(productId: string, limit = 6): WebsiteProduct[] {
  const current = getProductById(productId);
  if (!current) return ALL_WEBSITE_PRODUCTS.slice(0, limit);

  const slug = current.categorySlug;
  let targetAffinitySlugs: string[] = [];

  if (slug === 'bread-pav') {
    targetAffinitySlugs = ['milk', 'curd-yogurt', 'fresh-vegetables'];
  } else if (slug === 'fresh-vegetables') {
    targetAffinitySlugs = ['curd-yogurt', 'bread-pav', 'poha-daliya-grains'];
  } else if (slug === 'milk') {
    targetAffinitySlugs = ['bread-pav', 'flakes-kids-cereals', 'vermicelli'];
  } else if (slug === 'curd-yogurt') {
    targetAffinitySlugs = ['poha-daliya-grains', 'vermicelli', 'fresh-vegetables'];
  } else if (slug === 'flakes-kids-cereals') {
    targetAffinitySlugs = ['milk', 'curd-yogurt'];
  } else if (slug === 'vermicelli' || slug === 'poha-daliya-grains') {
    targetAffinitySlugs = ['milk', 'fresh-vegetables', 'curd-yogurt'];
  } else {
    targetAffinitySlugs = CANONICAL_CATEGORIES.filter((c) => c !== slug);
  }

  const affinityMatches = ALL_WEBSITE_PRODUCTS.filter(
    (p) => p.id !== current.id && targetAffinitySlugs.includes(p.categorySlug),
  ).sort((a, b) => (b.reviews || 0) - (a.reviews || 0));

  return affinityMatches.slice(0, limit);
}

// ─── Recommendation Engine: Trending & Bestsellers ─────────────────────

export function getTrendingProducts(categorySlug?: string, limit = 8): WebsiteProduct[] {
  let pool = ALL_WEBSITE_PRODUCTS;
  if (categorySlug && categorySlug !== 'All') {
    pool = pool.filter((p) => p.categorySlug === categorySlug || p.category.toLowerCase() === categorySlug.toLowerCase());
  }

  return [...pool]
    .sort((a, b) => {
      const scoreA = (a.rating || 4.5) * 1000 + (a.reviews || 100);
      const scoreB = (b.rating || 4.5) * 1000 + (b.reviews || 100);
      return scoreB - scoreA;
    })
    .slice(0, limit);
}

// ─── Recommendation Engine: Personalized Recommendations ────────────────

export function getPersonalizedRecommendations(historyIds: string[] = [], limit = 8): WebsiteProduct[] {
  if (!historyIds || historyIds.length === 0) {
    return getTrendingProducts(undefined, limit);
  }

  const viewedProducts = historyIds
    .map((id) => getProductById(id))
    .filter((p): p is WebsiteProduct => Boolean(p));

  if (viewedProducts.length === 0) {
    return getTrendingProducts(undefined, limit);
  }

  // Count category and brand preferences
  const categoryScores: Record<string, number> = {};
  const brandScores: Record<string, number> = {};
  const viewedIdSet = new Set(historyIds.map((id) => id.toLowerCase()));

  viewedProducts.forEach((p, idx) => {
    const recencyWeight = (historyIds.length - idx) / historyIds.length + 1; // More recent views get higher weight
    categoryScores[p.categorySlug] = (categoryScores[p.categorySlug] || 0) + 3 * recencyWeight;
    if (p.brand) {
      brandScores[p.brand] = (brandScores[p.brand] || 0) + 2 * recencyWeight;
    }
  });

  // Score candidate catalog products
  const scored = ALL_WEBSITE_PRODUCTS.filter((p) => !viewedIdSet.has(p.id.toLowerCase())).map((p) => {
    let score = (p.rating || 4.5) * 2;
    if (categoryScores[p.categorySlug]) {
      score += categoryScores[p.categorySlug] * 4;
    }
    if (p.brand && brandScores[p.brand]) {
      score += brandScores[p.brand] * 3;
    }
    if (p.isOrganic) score += 1.5;
    if (p.inStock) score += 5;

    return { product: p, score };
  });

  scored.sort((a, b) => b.score - a.score);
  return scored.slice(0, limit).map((s) => s.product);
}

// ─── Recommendation Engine: Cart-Based Addons ──────────────────────────

export function getCartRecommendations(cartVariantOrProductIds: string[] = [], limit = 6): WebsiteProduct[] {
  const cartIdsClean = new Set(
    cartVariantOrProductIds.map((id) => id.replace(/^var_/, '').toLowerCase()),
  );

  // Essential impulse items common in quick commerce (milk, curd, bread, lemons, coriander)
  const impulseKeywords = ['milk', 'bread', 'curd', 'lemon', 'coriander', 'butter', 'tomatoes'];

  const candidates = ALL_WEBSITE_PRODUCTS.filter((p) => {
    if (cartIdsClean.has(p.id.toLowerCase())) return false;
    const nameLow = p.name.toLowerCase();
    return impulseKeywords.some((kw) => nameLow.includes(kw));
  });

  // Sort by reviews and affordability (under ₹100 preferred for impulse cross-sell)
  candidates.sort((a, b) => {
    const priceWeightA = a.price <= 80 ? 20 : 0;
    const priceWeightB = b.price <= 80 ? 20 : 0;
    return (b.rating || 0) * 10 + priceWeightB - ((a.rating || 0) * 10 + priceWeightA);
  });

  return candidates.slice(0, limit);
}

// ─── Recommendation Engine: Wishlist-Based Discovery ───────────────────

export function getWishlistRecommendations(wishlistProductIds: string[] = [], limit = 6): WebsiteProduct[] {
  if (!wishlistProductIds || wishlistProductIds.length === 0) {
    return getTrendingProducts('fresh-vegetables', limit);
  }

  const wishlistProducts = wishlistProductIds
    .map((id) => getProductById(id))
    .filter((p): p is WebsiteProduct => Boolean(p));

  const favoredCategories = Array.from(new Set(wishlistProducts.map((p) => p.categorySlug)));
  const savedIdSet = new Set(wishlistProductIds.map((id) => id.toLowerCase()));

  const matches = ALL_WEBSITE_PRODUCTS.filter(
    (p) => !savedIdSet.has(p.id.toLowerCase()) && favoredCategories.includes(p.categorySlug),
  ).sort((a, b) => (b.discount || 0) - (a.discount || 0) || (b.rating || 0) - (a.rating || 0));

  return matches.slice(0, limit);
}

// ─── Recommendation Engine: Product Comparison ─────────────────────────

export interface ProductComparisonItem {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  unitName: string;
  price: number;
  mrp: number;
  discount: number;
  rating: number;
  reviews: number;
  imageUrl: string;
  inStock: boolean;
  isOrganic: boolean;
  isVeg: boolean;
  calories: string;
  protein: string;
  shelfLife: string;
  deliveryTime: string;
  isCurrent: boolean;
  badge?: string;
}

export interface ProductComparisonData {
  currentProduct: ProductComparisonItem;
  competitors: ProductComparisonItem[];
  categoryName: string;
}

export function getProductComparison(productId: string): ProductComparisonData | null {
  const current = getProductById(productId);
  if (!current) return null;

  // Find 2 closest competing alternatives in the same category/subcategory
  const alternatives = ALL_WEBSITE_PRODUCTS.filter(
    (p) => p.id !== current.id && p.categorySlug === current.categorySlug,
  ).sort((a, b) => Math.abs(a.price - current.price) - Math.abs(b.price - current.price));

  const competitorsList = alternatives.slice(0, 2);

  const mapToComparisonItem = (p: WebsiteProduct, isCurrent: boolean): ProductComparisonItem => {
    return {
      id: p.id,
      variantId: p.variantId,
      name: p.name,
      brand: p.brand,
      unitName: p.unitName,
      price: p.price,
      mrp: p.mrp,
      discount: p.discount,
      rating: p.rating || 4.6,
      reviews: p.reviews || 240,
      imageUrl: p.image,
      inStock: p.inStock,
      isOrganic: p.isOrganic,
      isVeg: p.isVeg,
      calories: p.nutrition?.Calories || '140 kcal',
      protein: p.nutrition?.Protein || '4.0g',
      shelfLife: p.shelfLife || 'Fresh Daily',
      deliveryTime: '10 Mins',
      isCurrent,
      badge: isCurrent ? 'Viewing Now' : (p.price < current.price ? 'Best Value' : 'Top Alternative'),
    };
  };

  return {
    currentProduct: mapToComparisonItem(current, true),
    competitors: competitorsList.map((c) => mapToComparisonItem(c, false)),
    categoryName: current.category,
  };
}

// ─── Recommendation Engine: Smart Search Suggestions ───────────────────

export interface SearchSuggestionsResult {
  query: string;
  trendingSearches: string[];
  suggestedPhrases: string[];
  matchingCategories: { name: string; slug: string; count: number }[];
  matchedProducts: WebsiteProduct[];
}

export const TRENDING_SEARCH_KEYWORDS = [
  'Amul Gold Milk',
  'English Oven Whole Wheat Bread',
  'Fresh Country Tomatoes',
  'Epigamia Greek Yogurt',
  'MTR Roasted Vermicelli',
  'Organic Baby Spinach',
  'Rajdhani Thick Poha',
  'Double Choco Brownies',
];

export function getSmartSearchSuggestions(query: string): SearchSuggestionsResult {
  const qClean = query.trim().toLowerCase();

  if (!qClean) {
    return {
      query: '',
      trendingSearches: TRENDING_SEARCH_KEYWORDS,
      suggestedPhrases: [],
      matchingCategories: STATIC_CATEGORIES.map((c) => ({
        name: c.name,
        slug: c.slug,
        count: c.itemCount || 0,
      })),
      matchedProducts: ALL_WEBSITE_PRODUCTS.slice(0, 4),
    };
  }

  const matchedProducts = searchProducts(qClean).slice(0, 4);

  // Extract unique suggestions from matching product names and brands
  const phrases = new Set<string>();
  searchProducts(qClean).slice(0, 8).forEach((p) => {
    phrases.add(p.name);
    phrases.add(`${p.brand} ${p.subCategory || ''}`);
  });

  const matchingCategories = STATIC_CATEGORIES.filter(
    (c) => c.name.toLowerCase().includes(qClean) || c.slug.toLowerCase().includes(qClean),
  ).map((c) => ({
    name: c.name,
    slug: c.slug,
    count: c.itemCount || 0,
  }));

  return {
    query: qClean,
    trendingSearches: TRENDING_SEARCH_KEYWORDS,
    suggestedPhrases: Array.from(phrases).slice(0, 5),
    matchingCategories,
    matchedProducts,
  };
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

  if (slug.includes('milk')) {
    bundleTitle = 'Morning Breakfast Combo';
    bundleDesc = 'Fresh milk paired with bakery-fresh bread and breakfast staples.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && (p.categorySlug === 'bread-pav' || p.categorySlug === 'flakes-kids-cereals'),
    );
  } else if (slug.includes('bread')) {
    bundleTitle = 'Tea & Toast Pair';
    bundleDesc = 'Bakery-fresh loaf with pasteurized farm milk for your daily morning routine.';
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
    bundleDesc = 'Creamy fresh curd with wholesome breakfast companions.';
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter(
      (p) => p.id !== current.id && (p.categorySlug === 'poha-daliya-grains' || p.categorySlug === 'vermicelli'),
    );
  } else {
    companionCandidates = ALL_WEBSITE_PRODUCTS.filter((p) => p.id !== current.id);
  }

  // Pick 2 distinct companion items
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
          return p.isVeg && !slugLow.includes('milk') && !slugLow.includes('curd') && !nameLow.includes('ghee') && !nameLow.includes('butter');
        case 'gluten_free':
          return !slugLow.includes('bread') && !slugLow.includes('vermicelli') && !nameLow.includes('wheat');
        case 'sugar_free':
          return slugLow.includes('vegetables') || slugLow.includes('grain') || nameLow.includes('unsweetened') || nameLow.includes('zero sugar');
        case 'high_protein':
          return slugLow.includes('curd') || slugLow.includes('milk') || nameLow.includes('protein') || nameLow.includes('egg');
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
