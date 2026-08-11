declare const process: { exit: (code?: number) => void };

import { PrismaClient } from '../services/api/node_modules/.prisma/client';

const prisma = new PrismaClient();

async function seedDatabase() {
  console.log('🌱 [Seed Engine] Populating Daily Basket development database...');

  // 1. Create Default Dark Store
  const store = await prisma.store.upsert({
    where: { code: 'STORE_CENTRAL_01' },
    update: {},
    create: {
      code: 'STORE_CENTRAL_01',
      name: 'Indiranagar Central Dark Store',
      address: '100 Feet Road, Indiranagar',
      city: 'Bengaluru',
      pincode: '560038',
      latitude: 12.9716,
      longitude: 77.5946,
      isOpen: true,
    },
  });
  console.log(`✅ Dark Store ready: ${store.name} (${store.id})`);

  // 2. Create Categories
  const dairyCategory = await prisma.category.upsert({
    where: { slug: 'dairy-bread-eggs' },
    update: {},
    create: {
      name: 'Dairy, Bread & Eggs',
      slug: 'dairy-bread-eggs',
      description: 'Fresh milk, farm eggs, curd, butter and artisanal bread',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500',
      isFeatured: true,
    },
  });

  // 3. Create Sample Product & Variant
  const milkProduct = await prisma.product.upsert({
    where: { slug: 'amul-taaza-homogenised-toned-milk-1l' },
    update: {},
    create: {
      storeId: store.id,
      categoryId: dairyCategory.id,
      name: 'Amul Taaza Homogenised Toned Milk 1L',
      slug: 'amul-taaza-homogenised-toned-milk-1l',
      description: 'Fresh, pasteurized toned milk from Amul. Homogenised for smooth taste.',
      brand: 'Amul',
      images: ['https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500'],
      isOrganic: false,
      tags: ['dairy', 'milk', 'toned-milk', 'amul'],
    },
  });

  const variant = await prisma.productVariant.upsert({
    where: { sku: 'SKU-AMUL-MILK-1L' },
    update: {},
    create: {
      productId: milkProduct.id,
      unitName: '1 L',
      price: 54,
      mrp: 56,
      sku: 'SKU-AMUL-MILK-1L',
      isAvailable: true,
    },
  });

  // 4. Create Store Inventory
  await prisma.inventory.upsert({
    where: { storeId_variantId: { storeId: store.id, variantId: variant.id } },
    update: { stockQuantity: 250 },
    create: {
      storeId: store.id,
      variantId: variant.id,
      stockQuantity: 250,
    },
  });

  console.log('🎉 Development database seeded successfully!');
}

seedDatabase()
  .catch((e) => {
    console.error('❌ Database seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
