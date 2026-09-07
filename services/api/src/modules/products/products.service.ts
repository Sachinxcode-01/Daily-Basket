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

    // Pull real catalog products (with their cheapest available variant) to build
    // the home feed dynamically instead of returning hardcoded arrays.
    const products = await this.prisma.product.findMany({
      include: {
        category: true,
        variants: { where: { isAvailable: true }, orderBy: { price: 'asc' } },
      },
    });

    const withPricing = products
      .filter((p) => p.variants.length > 0)
      .map((p) => {
        const v = p.variants[0];
        const discountPercent = v.mrp > v.price ? Math.round(((v.mrp - v.price) / v.mrp) * 100) : 0;
        return {
          id: p.id,
          productId: p.id,
          variantId: v.id,
          name: p.name,
          brand: p.brand,
          unitName: v.unitName,
          price: v.price,
          mrp: v.mrp,
          discountPercent,
          imageUrl: p.images?.[0] ?? null,
          categoryId: p.categoryId,
          categoryName: p.category?.name ?? null,
        };
      });

    // Flash deals = biggest real discounts.
    const flashDeals = [...withPricing]
      .filter((p) => p.discountPercent > 0)
      .sort((a, b) => b.discountPercent - a.discountPercent)
      .slice(0, 8);

    // Best sellers = featured-category products (fallback to any) as a deterministic slice.
    const featuredCategoryIds = new Set(
      categories.filter((c) => c.isFeatured).map((c) => c.id),
    );
    const bestSellers = withPricing
      .filter((p) => featuredCategoryIds.has(p.categoryId))
      .slice(0, 8);

    // Banners derived from featured categories (no separate Banner entity exists).
    const banners = categories
      .filter((c) => c.isFeatured)
      .slice(0, 3)
      .map((c) => ({
        id: `banner_${c.id}`,
        title: c.name,
        subtitle: c.description ?? 'Fresh essentials delivered in 10 minutes',
        imageUrl: c.bannerImage ?? c.imageUrl ?? null,
        categoryId: c.id,
        categorySlug: c.slug,
      }));

    return {
      etaMins: 10,
      banners,
      categories,
      flashDeals,
      bestSellers: bestSellers.length > 0 ? bestSellers : withPricing.slice(0, 8),
      quickReorder: withPricing.slice(0, 6),
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
