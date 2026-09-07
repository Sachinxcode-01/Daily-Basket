/**
 * Daily Basket — single-store catalog seed.
 *
 * Populates one local kirana store (store_main_01) with categories, products,
 * variants and inventory so the storefront has real data to render against.
 * Idempotent: safe to run multiple times (upserts by unique slug/sku/code).
 */
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const STORE_ID = 'store_main_01';

interface SeedVariant {
  unitName: string;
  price: number;
  mrp: number;
  sku: string;
  stock: number;
}

interface SeedProduct {
  name: string;
  slug: string;
  description: string;
  brand: string;
  image: string;
  isOrganic?: boolean;
  tags: string[];
  variants: SeedVariant[];
}

interface SeedCategory {
  id: string;
  name: string;
  slug: string;
  description: string;
  iconName: string;
  imageUrl: string;
  isFeatured: boolean;
  sortOrder: number;
  products: SeedProduct[];
}

const img = (id: string) => `https://images.unsplash.com/${id}?w=500&q=80`;

const catalog: SeedCategory[] = [
  {
    id: 'cat_vegetables',
    name: 'Fresh Vegetables & Fruits',
    slug: 'fresh-vegetables-fruits',
    description: 'Farm-fresh vegetables and seasonal fruits',
    iconName: 'apple',
    imageUrl: img('photo-1610832958506-aa56368176cf'),
    isFeatured: true,
    sortOrder: 1,
    products: [
      { name: 'Farm Fresh Tomatoes', slug: 'farm-fresh-tomatoes', description: 'Juicy red tomatoes, hand-picked from local farms.', brand: 'Local Farm', image: img('photo-1592924357228-91a4daadcfea'), isOrganic: true, tags: ['vegetable', 'tomato'], variants: [{ unitName: '500 g', price: 24, mrp: 40, sku: 'VEG-TOM-500', stock: 200 }, { unitName: '1 kg', price: 46, mrp: 78, sku: 'VEG-TOM-1000', stock: 150 }] },
      { name: 'Onions', slug: 'fresh-onions', description: 'Everyday cooking onions, fresh stock.', brand: 'Local Farm', image: img('photo-1518977956812-cd3dbadaaf31'), tags: ['vegetable', 'onion'], variants: [{ unitName: '1 kg', price: 38, mrp: 50, sku: 'VEG-ONI-1000', stock: 300 }] },
      { name: 'Potatoes', slug: 'fresh-potatoes', description: 'Premium quality potatoes for all your recipes.', brand: 'Local Farm', image: img('photo-1518977676601-b53f82aba655'), tags: ['vegetable', 'potato'], variants: [{ unitName: '1 kg', price: 32, mrp: 45, sku: 'VEG-POT-1000', stock: 280 }] },
      { name: 'Bananas (Robusta)', slug: 'robusta-bananas', description: 'Naturally ripened robusta bananas.', brand: 'Local Farm', image: img('photo-1571771894821-ce9b6c11b08e'), tags: ['fruit', 'banana'], variants: [{ unitName: '6 pcs', price: 40, mrp: 54, sku: 'FRU-BAN-6', stock: 120 }] },
      { name: 'Alphonso Mangoes', slug: 'alphonso-mangoes', description: 'Sweet Ratnagiri Alphonso mangoes, in season.', brand: 'Local Farm', image: img('photo-1553279768-865429fa0078'), tags: ['fruit', 'mango'], variants: [{ unitName: '1 kg Box', price: 299, mrp: 450, sku: 'FRU-MAN-1000', stock: 60 }] },
      { name: 'Baby Spinach', slug: 'baby-spinach', description: 'Tender organic baby spinach leaves.', brand: 'Local Farm', image: img('photo-1576045057995-568f588f82fb'), isOrganic: true, tags: ['vegetable', 'spinach', 'greens'], variants: [{ unitName: '250 g', price: 29, mrp: 40, sku: 'VEG-SPI-250', stock: 90 }] },
    ],
  },
  {
    id: 'cat_dairy',
    name: 'Dairy, Bread & Eggs',
    slug: 'dairy-bread-eggs',
    description: 'Fresh milk, eggs, curd, butter and bakery bread',
    iconName: 'milk',
    imageUrl: img('photo-1550583724-b2692b85b150'),
    isFeatured: true,
    sortOrder: 2,
    products: [
      { name: 'Amul Taaza Toned Milk', slug: 'amul-taaza-toned-milk-1l', description: 'Homogenised toned milk, pasteurised for freshness.', brand: 'Amul', image: img('photo-1563636619-e9143da7973b'), tags: ['dairy', 'milk'], variants: [{ unitName: '500 ml', price: 27, mrp: 28, sku: 'DAI-MILK-500', stock: 400 }, { unitName: '1 L', price: 54, mrp: 56, sku: 'DAI-MILK-1000', stock: 350 }] },
      { name: 'Amul Set Curd', slug: 'amul-set-curd', description: 'Thick and creamy set curd.', brand: 'Amul', image: img('photo-1571512599285-9b05c2b06e99'), tags: ['dairy', 'curd'], variants: [{ unitName: '400 g Cup', price: 42, mrp: 45, sku: 'DAI-CURD-400', stock: 180 }] },
      { name: 'Farm Eggs (White)', slug: 'farm-eggs-white', description: 'Protein-rich fresh white eggs.', brand: 'Daily Basket', image: img('photo-1582722872445-44dc5f7e3c8f'), tags: ['eggs'], variants: [{ unitName: '6 pcs', price: 48, mrp: 60, sku: 'EGG-WHT-6', stock: 220 }, { unitName: '12 pcs', price: 92, mrp: 115, sku: 'EGG-WHT-12', stock: 160 }] },
      { name: 'Whole Wheat Bread', slug: 'whole-wheat-bread', description: '100% whole wheat sandwich bread.', brand: 'Britannia', image: img('photo-1509440159596-0249088772ff'), tags: ['bread', 'bakery'], variants: [{ unitName: '400 g', price: 45, mrp: 50, sku: 'BRD-WW-400', stock: 140 }] },
      { name: 'Amul Butter', slug: 'amul-butter', description: 'The utterly butterly delicious table butter.', brand: 'Amul', image: img('photo-1589985270826-4b7bb135bc9d'), tags: ['dairy', 'butter'], variants: [{ unitName: '100 g', price: 58, mrp: 62, sku: 'DAI-BUT-100', stock: 200 }] },
    ],
  },
  {
    id: 'cat_beverages',
    name: 'Cold Drinks & Juices',
    slug: 'cold-drinks-juices',
    description: 'Soft drinks, juices and instant beverages',
    iconName: 'cup-soda',
    imageUrl: img('photo-1625772299848-391b6a87d7b3'),
    isFeatured: false,
    sortOrder: 3,
    products: [
      { name: 'Coca-Cola', slug: 'coca-cola-750ml', description: 'Chilled classic Coca-Cola.', brand: 'Coca-Cola', image: img('photo-1554866585-cd94860890b7'), tags: ['beverage', 'soft-drink'], variants: [{ unitName: '750 ml', price: 40, mrp: 45, sku: 'BEV-COKE-750', stock: 260 }] },
      { name: 'Real Mixed Fruit Juice', slug: 'real-mixed-fruit-juice', description: 'Made from concentrate, no added preservatives.', brand: 'Real', image: img('photo-1600271886742-f049cd451bba'), tags: ['beverage', 'juice'], variants: [{ unitName: '1 L', price: 110, mrp: 130, sku: 'BEV-REAL-1000', stock: 120 }] },
      { name: 'Bru Instant Coffee', slug: 'bru-instant-coffee', description: 'Rich and aromatic instant coffee.', brand: 'Bru', image: img('photo-1509042239860-f550ce710b93'), tags: ['beverage', 'coffee'], variants: [{ unitName: '100 g Jar', price: 165, mrp: 190, sku: 'BEV-BRU-100', stock: 95 }] },
      { name: 'Red Label Tea', slug: 'red-label-tea', description: 'Strong and refreshing everyday tea.', brand: 'Brooke Bond', image: img('photo-1597318181409-cf64d0b5d8a2'), tags: ['beverage', 'tea'], variants: [{ unitName: '500 g', price: 198, mrp: 210, sku: 'BEV-TEA-500', stock: 130 }] },
    ],
  },
  {
    id: 'cat_snacks',
    name: 'Munchies & Snacks',
    slug: 'munchies-snacks',
    description: 'Chips, biscuits, namkeen and chocolates',
    iconName: 'cookie',
    imageUrl: img('photo-1566478989037-eec170784d0b'),
    isFeatured: false,
    sortOrder: 4,
    products: [
      { name: "Lay's Classic Salted Chips", slug: 'lays-classic-salted', description: 'Crispy potato chips, classic salted.', brand: "Lay's", image: img('photo-1566478989037-eec170784d0b'), tags: ['snack', 'chips'], variants: [{ unitName: '52 g', price: 20, mrp: 20, sku: 'SNK-LAYS-52', stock: 300 }] },
      { name: 'Parle-G Biscuits', slug: 'parle-g-biscuits', description: 'The original glucose biscuits.', brand: 'Parle', image: img('photo-1558961363-fa8fdf82db35'), tags: ['snack', 'biscuit'], variants: [{ unitName: '250 g', price: 25, mrp: 28, sku: 'SNK-PARLE-250', stock: 400 }] },
      { name: 'Dairy Milk Silk', slug: 'dairy-milk-silk', description: 'Smooth and creamy milk chocolate bar.', brand: 'Cadbury', image: img('photo-1549007994-cb92caebd54b'), tags: ['snack', 'chocolate'], variants: [{ unitName: '150 g', price: 155, mrp: 170, sku: 'SNK-SILK-150', stock: 110 }] },
      { name: 'Haldiram Aloo Bhujia', slug: 'haldiram-aloo-bhujia', description: 'Crunchy spiced potato namkeen.', brand: 'Haldiram', image: img('photo-1626074353765-517a681e40be'), tags: ['snack', 'namkeen'], variants: [{ unitName: '200 g', price: 52, mrp: 60, sku: 'SNK-BHUJIA-200', stock: 170 }] },
    ],
  },
  {
    id: 'cat_staples',
    name: 'Atta, Rice & Dals',
    slug: 'atta-rice-dals',
    description: 'Flour, rice, pulses and cooking staples',
    iconName: 'wheat',
    imageUrl: img('photo-1586201375761-83865001e31c'),
    isFeatured: true,
    sortOrder: 5,
    products: [
      { name: 'Aashirvaad Whole Wheat Atta', slug: 'aashirvaad-atta', description: 'Chakki-fresh whole wheat flour.', brand: 'Aashirvaad', image: img('photo-1574323347407-f5e1ad6d020b'), tags: ['staple', 'atta', 'flour'], variants: [{ unitName: '5 kg', price: 242, mrp: 265, sku: 'STP-ATTA-5000', stock: 90 }] },
      { name: 'India Gate Basmati Rice', slug: 'india-gate-basmati', description: 'Aged premium long-grain basmati rice.', brand: 'India Gate', image: img('photo-1586201375761-83865001e31c'), tags: ['staple', 'rice'], variants: [{ unitName: '1 kg', price: 135, mrp: 160, sku: 'STP-RICE-1000', stock: 140 }, { unitName: '5 kg', price: 640, mrp: 750, sku: 'STP-RICE-5000', stock: 50 }] },
      { name: 'Tata Sampann Toor Dal', slug: 'tata-toor-dal', description: 'Unpolished protein-rich toor dal.', brand: 'Tata Sampann', image: img('photo-1546548970-71785318a17b'), tags: ['staple', 'dal', 'pulses'], variants: [{ unitName: '1 kg', price: 145, mrp: 160, sku: 'STP-TOOR-1000', stock: 120 }] },
      { name: 'Fortune Sunflower Oil', slug: 'fortune-sunflower-oil', description: 'Light and healthy refined sunflower oil.', brand: 'Fortune', image: img('photo-1474979266404-7eaacbcd87c5'), tags: ['staple', 'oil'], variants: [{ unitName: '1 L Pouch', price: 135, mrp: 155, sku: 'STP-OIL-1000', stock: 160 }] },
    ],
  },
  {
    id: 'cat_household',
    name: 'Cleaning & Household',
    slug: 'cleaning-household',
    description: 'Detergents, cleaners and home essentials',
    iconName: 'spray-can',
    imageUrl: img('photo-1585421514738-01798e348b17'),
    isFeatured: false,
    sortOrder: 6,
    products: [
      { name: 'Surf Excel Easy Wash Detergent', slug: 'surf-excel-easy-wash', description: 'Tough stain removal detergent powder.', brand: 'Surf Excel', image: img('photo-1585421514738-01798e348b17'), tags: ['household', 'detergent'], variants: [{ unitName: '1 kg', price: 155, mrp: 172, sku: 'HHD-SURF-1000', stock: 130 }] },
      { name: 'Vim Dishwash Gel', slug: 'vim-dishwash-gel', description: 'Lemon dishwash gel, tough on grease.', brand: 'Vim', image: img('photo-1610557892470-55d9e80c0bce'), tags: ['household', 'dishwash'], variants: [{ unitName: '750 ml', price: 115, mrp: 135, sku: 'HHD-VIM-750', stock: 150 }] },
      { name: 'Harpic Toilet Cleaner', slug: 'harpic-toilet-cleaner', description: 'Powerful 10x cleaning toilet liquid.', brand: 'Harpic', image: img('photo-1583947215259-38e31be8751f'), tags: ['household', 'cleaner'], variants: [{ unitName: '1 L', price: 99, mrp: 120, sku: 'HHD-HARPIC-1000', stock: 110 }] },
    ],
  },
];

async function main() {
  console.log('🌱 Seeding Daily Basket single-store catalog...');

  // Guest shopper used by the persistent cart for unauthenticated sessions (userId 'usr_default').
  // Cart.userId is a required FK to User, so this row must exist for guest carts to work.
  await prisma.user.upsert({
    where: { id: 'usr_default' },
    update: {},
    create: {
      id: 'usr_default',
      phoneNumber: '+910000000000',
      fullName: 'Guest Shopper',
      isVerified: true,
    },
  });

  // Default delivery address for the guest cart so checkout can create real orders.
  await prisma.address.upsert({
    where: { id: 'addr_guest_default' },
    update: {},
    create: {
      id: 'addr_guest_default',
      userId: 'usr_default',
      label: 'HOME',
      houseNo: '#42',
      street: '100 Feet Road, 4th Block, Koramangala',
      landmark: 'Near Sony World Signal',
      city: 'Bengaluru',
      pincode: '560034',
      latitude: 12.9352,
      longitude: 77.6245,
      isDefault: true,
    },
  });

  const store = await prisma.store.upsert({
    where: { code: 'store_main_01' },
    update: { isOpen: true },
    create: {
      id: STORE_ID,
      code: 'store_main_01',
      name: 'Daily Basket — Local Kirana Store',
      address: '100 Feet Road, 4th Block, Koramangala',
      city: 'Bengaluru',
      pincode: '560034',
      latitude: 12.9352,
      longitude: 77.6245,
      isOpen: true,
    },
  });

  let productCount = 0;
  let variantCount = 0;

  for (const cat of catalog) {
    const category = await prisma.category.upsert({
      where: { slug: cat.slug },
      update: {
        name: cat.name,
        description: cat.description,
        iconName: cat.iconName,
        imageUrl: cat.imageUrl,
        isFeatured: cat.isFeatured,
        sortOrder: cat.sortOrder,
        isActive: true,
      },
      create: {
        name: cat.name,
        slug: cat.slug,
        description: cat.description,
        iconName: cat.iconName,
        imageUrl: cat.imageUrl,
        isFeatured: cat.isFeatured,
        sortOrder: cat.sortOrder,
        isActive: true,
      },
    });

    for (const p of cat.products) {
      const product = await prisma.product.upsert({
        where: { slug: p.slug },
        update: {
          name: p.name,
          description: p.description,
          brand: p.brand,
          images: [p.image],
          isOrganic: p.isOrganic ?? false,
          tags: p.tags,
          searchKeywords: [p.name.toLowerCase(), p.brand.toLowerCase(), ...p.tags],
          categoryId: category.id,
          storeId: store.id,
        },
        create: {
          storeId: store.id,
          categoryId: category.id,
          name: p.name,
          slug: p.slug,
          description: p.description,
          brand: p.brand,
          images: [p.image],
          isOrganic: p.isOrganic ?? false,
          tags: p.tags,
          searchKeywords: [p.name.toLowerCase(), p.brand.toLowerCase(), ...p.tags],
        },
      });
      productCount++;

      for (const v of p.variants) {
        const variant = await prisma.productVariant.upsert({
          where: { sku: v.sku },
          update: { unitName: v.unitName, price: v.price, mrp: v.mrp, isAvailable: true, productId: product.id },
          create: {
            productId: product.id,
            unitName: v.unitName,
            price: v.price,
            mrp: v.mrp,
            sku: v.sku,
            isAvailable: true,
          },
        });
        variantCount++;

        await prisma.inventory.upsert({
          where: { storeId_variantId: { storeId: store.id, variantId: variant.id } },
          update: { stockQuantity: v.stock },
          create: { storeId: store.id, variantId: variant.id, stockQuantity: v.stock },
        });
      }
    }
  }

  console.log(`✅ Seed complete: ${catalog.length} categories, ${productCount} products, ${variantCount} variants.`);
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
