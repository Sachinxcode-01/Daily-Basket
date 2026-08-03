import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding Daily Basket database...');

  const store = await prisma.store.upsert({
    where: { code: 'STORE_01' },
    update: {},
    create: {
      id: 'store_main_01',
      name: 'Daily Basket Main Hub - Koramangala',
      code: 'STORE_01',
      address: '100 Feet Road, 4th Block, Koramangala',
      city: 'Bengaluru',
      pincode: '560034',
      latitude: 12.9352,
      longitude: 77.6245,
      isOpen: true,
    },
  });

  const categoriesData = [
    { id: 'cat_vegetables', name: 'Fresh Vegetables & Fruits', slug: 'fresh-vegetables-fruits', iconName: 'apple' },
    { id: 'cat_dairy', name: 'Dairy, Bread & Eggs', slug: 'dairy-bread-eggs', iconName: 'milk' },
    { id: 'cat_beverages', name: 'Cold Drinks & Juices', slug: 'cold-drinks-juices', iconName: 'cup-soda' },
    { id: 'cat_snacks', name: 'Munchies & Snacks', slug: 'munchies-snacks', iconName: 'cookie' },
    { id: 'cat_bakery', name: 'Fresh Bakery & Cakes', slug: 'fresh-bakery-cakes', iconName: 'cake' },
  ];

  for (const cat of categoriesData) {
    await prisma.category.upsert({
      where: { slug: cat.slug },
      update: {},
      create: cat,
    });
  }

  console.log('✅ Daily Basket Seeding Completed Successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
