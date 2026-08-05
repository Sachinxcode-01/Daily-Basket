import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

export const INITIAL_CATEGORIES = [
  {
    id: 'cat-fresh-fruits-veg',
    name: 'Fresh Fruits & Vegetables',
    slug: 'fresh-fruits-vegetables',
    description: 'Farm fresh organic vegetables, fresh fruits, leafy greens & exotic herbs',
    iconName: 'eco',
    imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=1200&q=80',
    sortOrder: 1,
    isFeatured: true,
    subcategories: ['Fresh Vegetables', 'Fresh Fruits', 'Exotics & Premium', 'Organic Produce', 'Cuts & Sprouts', 'Leafy Greens'],
  },
  {
    id: 'cat-dairy-bread-eggs',
    name: 'Dairy, Bread & Eggs',
    slug: 'dairy-bread-eggs',
    description: 'Fresh milk, butter, paneer, curd, fresh bread, and farm eggs delivered in 10 mins',
    iconName: 'egg_alt',
    imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=1200&q=80',
    sortOrder: 2,
    isFeatured: true,
    subcategories: ['Milk', 'Butter & Spread', 'Paneer & Tofu', 'Curd & Yogurt', 'Bread & Pav', 'Eggs', 'Cheese', 'Cream & Whitener'],
  },
  {
    id: 'cat-snacks-packaged',
    name: 'Snacks & Packaged Foods',
    slug: 'snacks-packaged-foods',
    description: 'Crunchy chips, namkeen, instant noodles, pasta, cereals and popcorn',
    iconName: 'fastfood',
    imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=1200&q=80',
    sortOrder: 3,
    isFeatured: true,
    subcategories: ['Chips & Wafers', 'Namkeen & Bhujia', 'Instant Noodles', 'Pasta & Macaroni', 'Ready To Eat', 'Popcorn', 'Breakfast Cereals', 'Energy Bars'],
  },
  {
    id: 'cat-grocery',
    name: 'Grocery',
    slug: 'grocery',
    description: 'Basmati rice, premium atta, pulses, dals, salt, sugar and dry fruits',
    iconName: 'shopping_bag',
    imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=1200&q=80',
    sortOrder: 4,
    isFeatured: true,
    subcategories: ['Rice & Rice Products', 'Atta & Flours', 'Dal & Pulses', 'Sugar & Jaggery', 'Salt & Spices', 'Dry Fruits & Seeds', 'Poha, Sooji & Rava'],
  },
  {
    id: 'cat-cooking-essentials',
    name: 'Cooking Essentials',
    slug: 'cooking-essentials',
    description: 'Pure mustard & sunflower oil, desi ghee, masalas, sauces, and pickles',
    iconName: 'opacity',
    imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=1200&q=80',
    sortOrder: 5,
    isFeatured: true,
    subcategories: ['Cooking Oil', 'Ghee & Butter', 'Sauces & Ketchup', 'Mayonnaise & Dips', 'Pickles & Chutneys', 'Blended Masalas', 'Vinegar & Baking'],
  },
  {
    id: 'cat-pooja-needs',
    name: 'Pooja Needs',
    slug: 'pooja-needs',
    description: 'Agarbatti, dhoop, pure camphor, cotton wicks, kumkum and pooja oil',
    iconName: 'temple_hindu',
    imageUrl: 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=1200&q=80',
    sortOrder: 6,
    isFeatured: false,
    subcategories: ['Agarbatti & Dhoop', 'Camphor & Kapur', 'Cotton Wicks', 'Kumkum & Turmeric', 'Pooja Oil & Ghee', 'Fresh Flowers & Coconut', 'Brass & Incense Holders'],
  },
  {
    id: 'cat-cleaning-essentials',
    name: 'Cleaning Essentials',
    slug: 'cleaning-essentials',
    description: 'Disinfectant floor cleaners, dishwash liquids, detergent powders and garbage bags',
    iconName: 'cleaning_services',
    imageUrl: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=1200&q=80',
    sortOrder: 7,
    isFeatured: false,
    subcategories: ['Floor Cleaners', 'Toilet Cleaners', 'Dishwash Liquids', 'Detergent Powders', 'Liquid Detergents', 'Mops & Brushes', 'Glass Cleaners', 'Garbage Bags'],
  },
  {
    id: 'cat-household-lifestyle',
    name: 'Household & Lifestyle',
    slug: 'household-lifestyle',
    description: 'Storage containers, kitchenware, aluminium foil, tissues, batteries and repellents',
    iconName: 'home_work',
    imageUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=1200&q=80',
    sortOrder: 8,
    isFeatured: false,
    subcategories: ['Containers & Jars', 'Kitchen Tools', 'Aluminium Foil & Cling Wrap', 'Tissue & Paper Towels', 'Mosquito Repellents', 'Batteries & Bulbs', 'Buckets & Mugs'],
  },
  {
    id: 'cat-personal-care',
    name: 'Personal Care',
    slug: 'personal-care',
    description: 'Bathing soaps, shampoos, toothpastes, skincare lotions, and hygiene products',
    iconName: 'face',
    imageUrl: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=1200&q=80',
    sortOrder: 9,
    isFeatured: false,
    subcategories: ['Soaps & Body Wash', 'Shampoo & Conditioner', 'Oral Care', 'Skin Care & Lotions', 'Deodorants & Perfumes', 'Hair Oils', 'Sanitary Hygiene'],
  },
  {
    id: 'cat-baby-care',
    name: 'Baby Care',
    slug: 'baby-care',
    description: 'Diapers, baby wipes, infant food, baby shampoos, and gentle skincare',
    iconName: 'child_care',
    imageUrl: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=1200&q=80',
    sortOrder: 10,
    isFeatured: false,
    subcategories: ['Diapers & Pants', 'Baby Wipes', 'Baby Food & Formula', 'Baby Bath & Hygiene', 'Baby Skincare', 'Feeding & Bottles'],
  },
  {
    id: 'cat-pet-care',
    name: 'Pet Care',
    slug: 'pet-care',
    description: 'Nutritious dog food, cat treats, litter sand, grooming shampoos and pet toys',
    iconName: 'pets',
    imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=1200&q=80',
    sortOrder: 11,
    isFeatured: false,
    subcategories: ['Dog Food', 'Cat Food', 'Pet Treats', 'Cat Litter & Hygiene', 'Grooming & Shampoos', 'Pet Toys & Accessories'],
  },
  {
    id: 'cat-cold-drinks-juices',
    name: 'Cold Drinks & Juices',
    slug: 'cold-drinks-juices',
    description: 'Chilled soft drinks, fruit juices, coconut water, energy drinks, and soda',
    iconName: 'local_drink',
    imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=1200&q=80',
    sortOrder: 12,
    isFeatured: true,
    subcategories: ['Soft Drinks & Cola', 'Fruit Juices', 'Tender Coconut Water', 'Energy Drinks', 'Soda & Mixer', 'Flavored Water & Iced Tea'],
  },
  {
    id: 'cat-tea-coffee-bev',
    name: 'Tea, Coffee & Beverages',
    slug: 'tea-coffee-beverages',
    description: 'Premium Assam tea leaves, instant coffee powder, green tea, health drinks and syrups',
    iconName: 'coffee',
    imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=1200&q=80',
    sortOrder: 13,
    isFeatured: false,
    subcategories: ['Tea Powder & Leaves', 'Green & Herbal Tea', 'Instant Coffee', 'Filter Coffee Powder', 'Health Drink Mixes', 'Syrups & Concentrates'],
  },
  {
    id: 'cat-biscuits-bakery',
    name: 'Biscuits & Bakery',
    slug: 'biscuits-bakery',
    description: 'Butter cookies, cream biscuits, rusks, cakes, fresh muffins, and artisan breads',
    iconName: 'bakery_dining',
    imageUrl: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=1200&q=80',
    sortOrder: 14,
    isFeatured: false,
    subcategories: ['Glucose & Marie Biscuits', 'Cream & Cookie Biscuits', 'Rusks & Khari', 'Cakes & Muffins', 'Artisan Bread', 'Snack Bars'],
  },
  {
    id: 'cat-chocolates-icecream',
    name: 'Chocolates & Ice Cream',
    slug: 'chocolates-ice-cream',
    description: 'Milk chocolates, dark chocolates, ice cream tubs, cones, and dessert toppings',
    iconName: 'icecream',
    imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=1200&q=80',
    sortOrder: 15,
    isFeatured: true,
    subcategories: ['Milk & Dark Chocolates', 'Chocolate Bars & Gift Packs', 'Ice Cream Tubs & Family Packs', 'Ice Cream Cones & Sticks', 'Frozen Desserts', 'Sweets & Mithai'],
  },
  {
    id: 'cat-organic-healthy',
    name: 'Organic & Healthy Foods',
    slug: 'organic-healthy-foods',
    description: '100% certified organic pulses, cold-pressed oils, millets, quinoa, and sugar-free snacks',
    iconName: 'spa',
    imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=1200&q=80',
    sortOrder: 16,
    isFeatured: false,
    subcategories: ['Organic Staples', 'Organic Oils & Ghee', 'Millets & Quinoa', 'Sugar Free & Keto', 'Gluten Free Foods', 'Superfoods & Seeds'],
  },
  {
    id: 'cat-frozen-foods',
    name: 'Frozen Foods',
    slug: 'frozen-foods',
    description: 'Frozen french fries, veg momos, frozen parathas, green peas, and chicken nuggets',
    iconName: 'ac_unit',
    imageUrl: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=1200&q=80',
    sortOrder: 17,
    isFeatured: false,
    subcategories: ['Frozen Veg Snacks', 'French Fries & Hashbrowns', 'Frozen Momos & Dimsums', 'Frozen Parathas & Breads', 'Frozen Vegetables & Peas', 'Frozen Non-Veg Snacks'],
  },
  {
    id: 'cat-meat-fish-eggs',
    name: 'Meat, Fish & Eggs',
    slug: 'meat-fish-eggs',
    description: 'Fresh chicken curry cut, mutton, fresh sea fish, prawns, and brown eggs',
    iconName: 'restaurant',
    imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=1200&q=80',
    sortOrder: 18,
    isFeatured: false,
    subcategories: ['Fresh Chicken', 'Fresh Mutton', 'Fresh Fish & Seafood', 'Prawns & Crabs', 'Eggs', 'Cold Cuts & Sausages'],
  },
];

@Injectable()
export class CategoriesService {
  constructor(
    private prisma: PrismaService,
    private redis: RedisService,
  ) {}

  async findAll(featuredOnly = false) {
    const cacheKey = featuredOnly ? 'categories:featured' : 'categories:all';
    const cached = await this.redis.get(cacheKey);
    if (cached) {
      return JSON.parse(cached as string);
    }

    let categories = await this.prisma.category.findMany({
      where: {
        isActive: true,
        parentId: null,
        ...(featuredOnly ? { isFeatured: true } : {}),
      },
      include: {
        children: {
          where: { isActive: true },
          orderBy: { sortOrder: 'asc' },
        },
      },
      orderBy: { sortOrder: 'asc' },
    });

    if (categories.length === 0) {
      categories = INITIAL_CATEGORIES.map((cat) => ({
        ...cat,
        parentId: null,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date(),
        children: cat.subcategories.map((sub, idx) => ({
          id: `${cat.id}-sub-${idx}`,
          name: sub,
          slug: sub.toLowerCase().replace(/[^a-z0-9]+/g, '-'),
          description: `${sub} in ${cat.name}`,
          imageUrl: cat.imageUrl,
          bannerImage: cat.bannerImage,
          iconName: cat.iconName,
          parentId: cat.id,
          sortOrder: idx + 1,
          isFeatured: false,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
        })),
      })) as any;
    }

    await this.redis.set(cacheKey, JSON.stringify(categories), 1800); // 30 mins
    return categories;
  }

  async findOne(idOrSlug: string) {
    const category = await this.prisma.category.findFirst({
      where: {
        OR: [{ id: idOrSlug }, { slug: idOrSlug }],
      },
      include: {
        children: {
          where: { isActive: true },
          orderBy: { sortOrder: 'asc' },
        },
      },
    });

    if (category) {
      return category;
    }

    const fallback = INITIAL_CATEGORIES.find(
      (c) => c.id === idOrSlug || c.slug === idOrSlug,
    );

    if (!fallback) {
      throw new NotFoundException(`Category ${idOrSlug} not found`);
    }

    return {
      ...fallback,
      children: fallback.subcategories.map((sub, idx) => ({
        id: `${fallback.id}-sub-${idx}`,
        name: sub,
        slug: sub.toLowerCase().replace(/[^a-z0-9]+/g, '-'),
        parentId: fallback.id,
        sortOrder: idx + 1,
      })),
    };
  }

  async getSubcategories(parentId: string) {
    const subs = await this.prisma.category.findMany({
      where: { parentId, isActive: true },
      orderBy: { sortOrder: 'asc' },
    });

    if (subs.length > 0) {
      return subs;
    }

    const parent = INITIAL_CATEGORIES.find(
      (c) => c.id === parentId || c.slug === parentId,
    );

    if (!parent) return [];

    return parent.subcategories.map((sub, idx) => ({
      id: `${parent.id}-sub-${idx}`,
      name: sub,
      slug: sub.toLowerCase().replace(/[^a-z0-9]+/g, '-'),
      parentId: parent.id,
      sortOrder: idx + 1,
    }));
  }

  async getCategoryProducts(
    idOrSlug: string,
    query?: string,
    subcategoryId?: string,
    sort = 'popular',
    page = 1,
    limit = 20,
  ) {
    const category = await this.findOne(idOrSlug);

    const whereClause: any = {
      OR: [{ categoryId: category.id }, { category: { slug: category.slug } }],
    };

    if (query) {
      whereClause.name = { contains: query, mode: 'insensitive' };
    }

    let orderBy: any = { createdAt: 'desc' };
    if (sort === 'price_asc') {
      orderBy = { variants: { _count: 'desc' } };
    } else if (sort === 'price_desc') {
      orderBy = { createdAt: 'desc' };
    } else if (sort === 'alphabetical') {
      orderBy = { name: 'asc' };
    }

    const [products, total] = await Promise.all([
      this.prisma.product.findMany({
        where: whereClause,
        include: {
          variants: true,
          category: true,
        },
        orderBy,
        skip: (page - 1) * limit,
        take: limit,
      }),
      this.prisma.product.count({ where: whereClause }),
    ]);

    return {
      category,
      subcategories: category.children || [],
      data: products,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit) || 1,
      },
    };
  }

  async createCategory(dto: any) {
    const newCat = await this.prisma.category.create({
      data: {
        name: dto.name,
        slug: dto.slug || dto.name.toLowerCase().replace(/[^a-z0-9]+/g, '-'),
        description: dto.description,
        imageUrl: dto.imageUrl,
        bannerImage: dto.bannerImage,
        iconName: dto.iconName || 'shopping_basket',
        parentId: dto.parentId || null,
        sortOrder: dto.sortOrder || 0,
        isFeatured: dto.isFeatured || false,
        isActive: dto.isActive !== undefined ? dto.isActive : true,
      },
    });

    await this.redis.delByPattern('categories:*');
    return newCat;
  }

  async updateCategory(id: string, dto: any) {
    const updated = await this.prisma.category.update({
      where: { id },
      data: dto,
    });

    await this.redis.delByPattern('categories:*');
    return updated;
  }

  async deleteCategory(id: string) {
    const deleted = await this.prisma.category.delete({
      where: { id },
    });

    await this.redis.delByPattern('categories:*');
    return deleted;
  }

  async reorderCategories(items: { id: string; sortOrder: number }[]) {
    await Promise.all(
      items.map((item) =>
        this.prisma.category.update({
          where: { id: item.id },
          data: { sortOrder: item.sortOrder },
        }),
      ),
    );

    await this.redis.delByPattern('categories:*');
    return { status: 'SUCCESS', count: items.length };
  }
}
