import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  async getHomeFeed() {
    const categories = await this.prisma.category.findMany({
      where: { isActive: true },
      take: 8,
      orderBy: { sortOrder: 'asc' },
    });

    const mockBanners = [
      {
        id: 'banner_01',
        title: '⚡ 10-Minute Farm Fresh Vegetables',
        subtitle: 'Up to 40% OFF on Organic Produce',
        bgGradient: 'from-emerald-600 to-teal-800',
        imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=800&q=80',
      },
      {
        id: 'banner_02',
        title: '🥛 Fresh Dairy & Breakfast Essentials',
        subtitle: 'Milk, Eggs, Bread delivered instantly',
        bgGradient: 'from-amber-600 to-orange-800',
        imageUrl: 'https://images.unsplash.com/photo-1528498033373-3c6c08e93d79?w=800&q=80',
      },
    ];

    const flashDeals = [
      {
        id: 'p1',
        name: 'Fresh Organic Farm Tomatoes',
        unitName: '500g',
        price: 24,
        mrp: 40,
        discountPercent: 40,
        imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
        rating: 4.8,
      },
      {
        id: 'p2',
        name: 'Amul Taaza Toned Fresh Milk',
        unitName: '1 Litre',
        price: 54,
        mrp: 56,
        discountPercent: 4,
        imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80',
        rating: 4.9,
      },
      {
        id: 'p3',
        name: 'Whole Wheat Brown Sandwich Bread',
        unitName: '400g',
        price: 45,
        mrp: 50,
        discountPercent: 10,
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
        rating: 4.7,
      },
      {
        id: 'p4',
        name: 'Fresh Alphonso Mangoes (Box)',
        unitName: '1 kg',
        price: 299,
        mrp: 450,
        discountPercent: 33,
        imageUrl: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
        rating: 5.0,
      },
    ];

    return {
      etaMins: 10,
      currentAddress: 'Koramangala 4th Block, Bengaluru',
      banners: mockBanners,
      categories,
      flashDeals,
      bestSellers: flashDeals.slice(0, 3),
      quickReorder: flashDeals.slice(1, 4),
    };
  }

  async findAll(categoryId?: string, query?: string) {
    const where: any = {};
    if (categoryId) where.categoryId = categoryId;
    if (query) {
      where.OR = [
        { name: { contains: query, mode: 'insensitive' } },
        { description: { contains: query, mode: 'insensitive' } },
      ];
    }

    return this.prisma.product.findMany({
      where,
      include: { category: true, variants: true },
    });
  }

  async findOne(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: { category: true, variants: true, reviews: true },
    });

    if (!product) {
      throw new NotFoundException(`Product ${id} not found`);
    }

    return product;
  }
}
