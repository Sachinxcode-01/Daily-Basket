/**
 * Daily Basket — Production Catalog Database Seed
 *
 * Seeds all 607 real product catalog items across 7 departments and categories:
 * - Fresh Vegetables (154 products)
 * - Bread, Pav & Bakery (248 products)
 * - Curd & Yogurt (78 products)
 * - Fresh & Fortified Milk (41 products)
 * - Breakfast Cereals & Kids Flakes (53 products)
 * - Poha, Daliya & Grains (17 products)
 * - Roasted & Plain Vermicelli (16 products)
 *
 * Populates categories, products, variants, and store inventory (store_main_01).
 * Idempotent: safe to run repeatedly (upserts by unique slug/sku).
 */
import { PrismaClient } from '@prisma/client';
import * as fs from 'fs';
import * as path from 'path';

const prisma = new PrismaClient();
const STORE_ID = 'store_main_01';

interface RawCatalogProduct {
  id: string;
  name: string;
  subtitle: string;
  brand: string;
  unit: string;
  price: number;
  mrp: number;
  badge: string;
  badgeColor?: string;
  badgeTextColor?: string;
  inStock: boolean;
  category: string;
  sub: string;
  rating: number;
  reviews: string;
  image: string;
}

const CATEGORY_METADATA: Record<string, { name: string; description: string; iconName: string; sortOrder: number; isFeatured: boolean }> = {
  'fresh-vegetables': {
    name: 'Fresh Vegetables',
    description: 'Farm-fresh organic vegetables, leafy greens and exotic produce direct from local farmers',
    iconName: 'eco',
    sortOrder: 1,
    isFeatured: true,
  },
  'dairy-bread-eggs': {
    name: 'Dairy, Bread & Eggs',
    description: 'Fresh milk pouches, curd tubs, artisan breads, pav and farm eggs delivered in 10 minutes',
    iconName: 'egg_alt',
    sortOrder: 2,
    isFeatured: true,
  },
  'bread-pav': {
    name: 'Bread, Pav & Bakery',
    description: 'Fresh white and brown sandwich bread, oven fresh ladi pav, sourdough and breakfast baked goods',
    iconName: 'bakery_dining',
    sortOrder: 3,
    isFeatured: true,
  },
  'milk': {
    name: 'Milk & Dairy Drinks',
    description: 'Cow milk, A2 buffalo milk, toned, full cream and probiotic dairy beverages',
    iconName: 'local_drink',
    sortOrder: 4,
    isFeatured: true,
  },
  'curd-yogurt': {
    name: 'Curd & Greek Yogurt',
    description: 'Thick set dahi cups, artisanal matka curd and fruit Greek yogurts',
    iconName: 'icecream',
    sortOrder: 5,
    isFeatured: true,
  },
  'flakes-kids-cereals': {
    name: 'Flakes & Kids Cereals',
    description: 'Crunchy corn flakes, choco fills, fruit rings and whole grain breakfast bowls',
    iconName: 'fastfood',
    sortOrder: 6,
    isFeatured: true,
  },
  'poha-daliya-grains': {
    name: 'Poha, Daliya & Grains',
    description: 'Thick poha, nutritious dalia, sabudana and pantry breakfast staples',
    iconName: 'grain',
    sortOrder: 7,
    isFeatured: true,
  },
  'vermicelli': {
    name: 'Vermicelli & Sevai',
    description: 'Roasted wheat vermicelli, instant seviyan upma and traditional rice sevai',
    iconName: 'ramen_dining',
    sortOrder: 8,
    isFeatured: true,
  },
  'grocery': {
    name: 'Grocery & Staples',
    description: 'Everyday pulses, grains, flour, sugar, salt and cooking essentials',
    iconName: 'shopping_bag',
    sortOrder: 9,
    isFeatured: false,
  },
};

function generateSlug(text: string, id: string): string {
  const base = text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .trim()
    .replace(/\s+/g, '-');
  return `${base}-${id.replace('prod_', '')}`;
}

async function main() {
  console.log('🚀 Starting Daily Basket Enterprise Catalog Seeding...');

  // 1. Ensure primary dark store exists
  const store = await prisma.store.upsert({
    where: { code: 'DARKSTORE_BLR_01' },
    update: {
      name: 'Daily Basket Koramangala Hub (Store 01)',
      address: '14th Main Road, 4th Block, Koramangala',
      city: 'Bengaluru',
      pincode: '560034',
      isOpen: true,
    },
    create: {
      id: STORE_ID,
      name: 'Daily Basket Koramangala Hub (Store 01)',
      code: 'DARKSTORE_BLR_01',
      address: '14th Main Road, 4th Block, Koramangala',
      city: 'Bengaluru',
      pincode: '560034',
      latitude: 12.9352,
      longitude: 77.6245,
      isOpen: true,
    },
  });
  console.log(`📍 Verified Store: ${store.name} (${store.code})`);

  // 2. Load JSON catalog file
  const jsonPath = path.join(__dirname, 'products_catalog.json');
  if (!fs.existsSync(jsonPath)) {
    throw new Error(`Catalog file not found at ${jsonPath}. Run tools/build_product_catalog.py first.`);
  }

  const catalogData: Record<string, RawCatalogProduct[]> = JSON.parse(
    fs.readFileSync(jsonPath, 'utf-8')
  );

  // We only iterate through the canonical distinct category buckets
  const canonicalCategories = [
    'fresh-vegetables',
    'bread-pav',
    'curd-yogurt',
    'milk',
    'flakes-kids-cereals',
    'poha-daliya-grains',
    'vermicelli',
  ];

  let totalProducts = 0;
  let totalVariants = 0;

  for (const catKey of canonicalCategories) {
    const products = catalogData[catKey] || [];
    if (products.length === 0) continue;

    const meta = CATEGORY_METADATA[catKey] || {
      name: catKey.replace(/-/g, ' ').toUpperCase(),
      description: `Premium ${catKey.replace(/-/g, ' ')}`,
      iconName: 'shopping_basket',
      sortOrder: 10,
      isFeatured: false,
    };

    const firstProductImg = products[0]?.image ? `/${products[0].image}` : null;

    // Upsert Category
    const category = await prisma.category.upsert({
      where: { slug: catKey },
      update: {
        name: meta.name,
        description: meta.description,
        iconName: meta.iconName,
        imageUrl: firstProductImg,
        isFeatured: meta.isFeatured,
        sortOrder: meta.sortOrder,
        isActive: true,
      },
      create: {
        name: meta.name,
        slug: catKey,
        description: meta.description,
        iconName: meta.iconName,
        imageUrl: firstProductImg,
        isFeatured: meta.isFeatured,
        sortOrder: meta.sortOrder,
        isActive: true,
      },
    });

    console.log(`📁 Processing Category: ${category.name} (${products.length} products)...`);

    for (const p of products) {
      const slug = generateSlug(p.name, p.id);
      const webImagePath = p.image.startsWith('assets/') ? `/${p.image.replace('assets/', '')}` : p.image;
      const sku = `SKU-${catKey.substring(0, 3).toUpperCase()}-${p.id.replace('prod_', '').toUpperCase()}`;

      // Upsert Product
      const product = await prisma.product.upsert({
        where: { slug },
        update: {
          name: p.name,
          description: `${p.name} - ${p.subtitle}. Fresh quality guaranteed. Delivered in 10 minutes.`,
          brand: p.brand || 'Daily Basket Select',
          images: [webImagePath, p.image],
          isOrganic: p.badge?.toLowerCase().includes('organic') || p.category?.toLowerCase() === 'organic',
          tags: [catKey, p.sub.toLowerCase(), p.brand.toLowerCase()],
          searchKeywords: [
            p.name.toLowerCase(),
            p.brand.toLowerCase(),
            p.sub.toLowerCase(),
            catKey,
          ],
          categoryId: category.id,
          storeId: store.id,
        },
        create: {
          storeId: store.id,
          categoryId: category.id,
          name: p.name,
          slug,
          description: `${p.name} - ${p.subtitle}. Fresh quality guaranteed. Delivered in 10 minutes.`,
          brand: p.brand || 'Daily Basket Select',
          images: [webImagePath, p.image],
          isOrganic: p.badge?.toLowerCase().includes('organic') || p.category?.toLowerCase() === 'organic',
          tags: [catKey, p.sub.toLowerCase(), p.brand.toLowerCase()],
          searchKeywords: [
            p.name.toLowerCase(),
            p.brand.toLowerCase(),
            p.sub.toLowerCase(),
            catKey,
          ],
        },
      });
      totalProducts++;

      // Upsert Variant
      const variant = await prisma.productVariant.upsert({
        where: { sku },
        update: {
          unitName: p.unit || '1 pc',
          price: p.price,
          mrp: p.mrp || p.price,
          isAvailable: p.inStock ?? true,
          productId: product.id,
        },
        create: {
          productId: product.id,
          unitName: p.unit || '1 pc',
          price: p.price,
          mrp: p.mrp || p.price,
          sku,
          isAvailable: p.inStock ?? true,
        },
      });
      totalVariants++;

      // Upsert Store Inventory
      await prisma.inventory.upsert({
        where: { storeId_variantId: { storeId: store.id, variantId: variant.id } },
        update: { stockQuantity: 250 },
        create: { storeId: store.id, variantId: variant.id, stockQuantity: 250 },
      });
    }
  }

  console.log(`\n============================================================`);
  console.log(`✅ Production Database Seed Finished!`);
  console.log(`📦 Categories Seeded: ${canonicalCategories.length}`);
  console.log(`🛍️ Total Products Seeded: ${totalProducts} / 607`);
  console.log(`🏷️ Total Variants Seeded: ${totalVariants}`);
  console.log(`🏬 All Store Inventories Initialized for ${store.name}`);
  console.log(`============================================================\n`);
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
