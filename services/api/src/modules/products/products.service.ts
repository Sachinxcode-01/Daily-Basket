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
    if (categoryId) {
      where.OR = [
        { categoryId: categoryId },
        { category: { slug: categoryId } },
      ];
    }
    if (query) {
      const searchConditions = [
        { name: { contains: query, mode: 'insensitive' } },
        { description: { contains: query, mode: 'insensitive' } },
        { brand: { contains: query, mode: 'insensitive' } },
      ];
      if (where.OR) {
        where.AND = [
          { OR: where.OR },
          { OR: searchConditions },
        ];
        delete where.OR;
      } else {
        where.OR = searchConditions;
      }
    }

    return this.prisma.product.findMany({
      where,
      include: { category: true, variants: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(idOrSlug: string) {
    if (!idOrSlug) {
      throw new NotFoundException('Product identifier is required');
    }

    const cleanId = idOrSlug.trim();

    // 1. Try finding by ID, slug, barcode, or variant SKU in database
    const product = await this.prisma.product.findFirst({
      where: {
        OR: [
          { id: cleanId },
          { slug: cleanId },
          { slug: { contains: cleanId, mode: 'insensitive' } },
          { barcode: cleanId },
          { variants: { some: { sku: { contains: cleanId, mode: 'insensitive' } } } },
        ],
      },
      include: { category: true, variants: true, reviews: true, aiInsight: true },
    });

    if (product) {
      return product;
    }

    // 2. Resilient fallback: lookup directly in master catalog JSON
    try {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const catalogData = require('../../prisma/products_catalog.json');
      const allProducts: any[] = catalogData.all || Object.values(catalogData).flat();
      const match = allProducts.find(
        (p) =>
          p.id === cleanId ||
          p.id === `prod_${cleanId}` ||
          cleanId.includes(p.id) ||
          p.name.toLowerCase().includes(cleanId.toLowerCase()),
      );

      if (match) {
        const price = Number(match.price) || 0;
        const mrp = Number(match.mrp) || price;
        const webImage = match.image?.startsWith('assets/') ? `/${match.image.replace(/^assets\//, '')}` : match.image;

        return {
          id: match.id,
          name: match.name,
          slug: match.id,
          description: `${match.name} (${match.subtitle || match.unit || ''}). Fresh quality guaranteed. Delivered in 10 minutes.`,
          brand: match.brand || 'Daily Basket Select',
          images: [webImage],
          isOrganic: Boolean(match.badge?.toLowerCase().includes('organic')),
          rating: match.rating || 4.7,
          reviewCount: parseInt(match.reviews, 10) || 120,
          category: {
            id: match.categorySlug || 'cat_general',
            name: match.category || 'Produce & Essentials',
            slug: match.categorySlug || 'general',
          },
          variants: [
            {
              id: `var_${match.id}`,
              unitName: match.unit || match.subtitle || '1 unit',
              price,
              mrp,
              sku: `SKU-${match.id.toUpperCase()}`,
              isAvailable: match.inStock ?? true,
              stockQuantity: 100,
            },
          ],
          reviews: [],
          aiInsight: {
            nutritionalSummary: {
              calories: '65 kcal',
              carbohydrates: '12g',
              protein: '2.5g',
              fiber: '3g',
            },
            benefits: ['Rich in essential vitamins', 'Supports immune health', '100% farm fresh'],
            bestFor: ['Daily meals', 'Healthy salads', 'Quick preparation'],
            usage: 'Wash thoroughly before consumption. Best used fresh within 3-4 days.',
            storage: 'Store in a cool, dry place or refrigerate to retain freshness.',
          },
        };
      }
    } catch {
      // Fallback read failed
    }

    throw new NotFoundException(`Product ${idOrSlug} not found`);
  }
}
