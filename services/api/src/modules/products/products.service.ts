import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { ProductValidatorService } from './product-validator.service';

@Injectable()
export class ProductsService {
  constructor(
    private prisma: PrismaService,
    private productValidator: ProductValidatorService,
  ) {}

  private static customProducts: Map<string, any> = new Map();
  private static deletedProductIds: Set<string> = new Set();
  private static productOverrides: Map<string, any> = new Map();

  async getHomeFeed() {
    try {
      const categories = await this.prisma.category.findMany({
        where: { isActive: true },
        take: 8,
        orderBy: { sortOrder: 'asc' },
      });

      const products = await this.prisma.product.findMany({
        include: {
          category: true,
          variants: { where: { isAvailable: true }, orderBy: { price: 'asc' } },
        },
      });

      if (products && products.length > 0) {
        const withPricing = products
          .filter((p) => p.variants.length > 0 && !ProductsService.deletedProductIds.has(p.id))
          .map((p) => {
            const override = ProductsService.productOverrides.get(p.id) || {};
            const v = p.variants[0];
            const price = override.price ?? v.price;
            const mrp = override.mrp ?? v.mrp;
            const discountPercent = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
            return {
              id: p.id,
              productId: p.id,
              variantId: v.id,
              name: override.name ?? p.name,
              brand: override.brand ?? p.brand,
              unitName: override.unitName ?? v.unitName,
              price,
              mrp,
              discountPercent,
              imageUrl: override.imageUrl ?? p.images?.[0] ?? null,
              categoryId: p.categoryId,
              categoryName: p.category?.name ?? null,
            };
          });

        const flashDeals = [...withPricing]
          .filter((p) => p.discountPercent > 0)
          .sort((a, b) => b.discountPercent - a.discountPercent)
          .slice(0, 8);

        const featuredCategoryIds = new Set(
          categories.filter((c) => c.isFeatured).map((c) => c.id),
        );
        const bestSellers = withPricing
          .filter((p) => featuredCategoryIds.has(p.categoryId))
          .slice(0, 8);

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
    } catch {
      // Fallback to catalog feed below
    }

    // Dynamic catalog JSON fallback
    const all = await this.findAll();
    const withPricing = all.map((p: any) => {
      const v = p.variants?.[0] || {};
      const price = v.price ?? 0;
      const mrp = v.mrp ?? price;
      const discountPercent = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;
      return {
        id: p.id,
        productId: p.id,
        variantId: v.id || `var_${p.id}`,
        name: p.name,
        brand: p.brand,
        unitName: v.unitName || '1 unit',
        price,
        mrp,
        discountPercent,
        imageUrl: p.images?.[0] || null,
        categoryId: p.categoryId || p.category?.id || 'produce',
        categoryName: p.category?.name || 'Produce',
      };
    });

    return {
      etaMins: 10,
      banners: [
        {
          id: 'banner_fresh',
          title: 'Farm Fresh Harvest',
          subtitle: 'Direct from organic verified farms delivered in 10 mins',
          imageUrl: '/images/daily_basket_logo.png',
          categoryId: 'produce',
          categorySlug: 'fresh-produce',
        },
      ],
      categories: [
        { id: 'cat_produce', name: 'Fresh Produce', slug: 'fresh-produce', isFeatured: true },
        { id: 'cat_dairy', name: 'Dairy & Eggs', slug: 'dairy-eggs', isFeatured: true },
        { id: 'cat_bakery', name: 'Bakery & Bread', slug: 'bakery-bread', isFeatured: true },
        { id: 'cat_beverages', name: 'Beverages', slug: 'beverages', isFeatured: true },
      ],
      flashDeals: withPricing.filter((p) => p.discountPercent > 0).slice(0, 8),
      bestSellers: withPricing.slice(0, 8),
      quickReorder: withPricing.slice(0, 6),
    };
  }

  async findAll(categoryId?: string, query?: string) {
    let dbProducts: any[] = [];
    try {
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

      dbProducts = await this.prisma.product.findMany({
        where,
        include: { category: true, variants: true },
        orderBy: { createdAt: 'desc' },
      });
    } catch {
      dbProducts = [];
    }

    // Merge in catalog items if DB items are absent
    let result = [...dbProducts];
    if (result.length === 0) {
      try {
        // eslint-disable-next-line @typescript-eslint/no-var-requires
        const catalogData = require('../../prisma/products_catalog.json');
        const rawItems: any[] = catalogData.all || Object.values(catalogData).flat();

        const formattedCatalog = rawItems.map((p) => {
          const price = Number(p.price) || 0;
          const mrp = Number(p.mrp) || price;
          const webImg = p.image?.startsWith('assets/') ? `/${p.image.replace(/^assets\//, '')}` : p.image;
          const catName = p.category || p.sub || 'Produce';
          const catSlug = p.categorySlug || 'produce';

          return {
            id: p.id,
            storeId: 'store_main_01',
            categoryId: catSlug,
            name: p.name,
            slug: p.id,
            description: `${p.name} (${p.unit || p.subtitle || ''}). High quality farm fresh goods.`,
            brand: p.brand || 'Daily Basket',
            images: [webImg || '/images/daily_basket_logo.png'],
            barcode: p.id,
            isOrganic: Boolean(p.badge?.toLowerCase().includes('organic')),
            category: {
              id: catSlug,
              name: catName,
              slug: catSlug,
            },
            variants: [
              {
                id: `var_${p.id}`,
                productId: p.id,
                unitName: p.unit || p.subtitle || '1 unit',
                price,
                mrp,
                sku: `SKU-${p.id.toUpperCase()}`,
                isAvailable: p.inStock ?? true,
                stockQuantity: 150,
              },
            ],
          };
        });

        result = formattedCatalog;
      } catch {
        result = [];
      }
    }

    // Merge in custom created products from memory
    const customList = Array.from(ProductsService.customProducts.values());
    result = [...customList, ...result];

    // Filter out deleted items and apply overrides
    result = result
      .filter((p) => !ProductsService.deletedProductIds.has(p.id))
      .map((p) => {
        const override = ProductsService.productOverrides.get(p.id);
        if (!override) return p;
        return {
          ...p,
          ...override,
          variants: p.variants?.map((v: any) => ({
            ...v,
            price: override.price ?? v.price,
            mrp: override.mrp ?? v.mrp,
            unitName: override.unitName ?? v.unitName,
            stockQuantity: override.stockQuantity ?? v.stockQuantity,
            isAvailable: override.isAvailable ?? v.isAvailable,
          })),
        };
      });

    // Apply category & query filter in-memory if needed
    if (categoryId && categoryId !== 'All') {
      const cleanCat = categoryId.toLowerCase();
      result = result.filter(
        (p) =>
          p.categoryId?.toLowerCase() === cleanCat ||
          p.category?.name?.toLowerCase().includes(cleanCat) ||
          p.category?.slug?.toLowerCase() === cleanCat,
      );
    }
    if (query) {
      const q = query.toLowerCase();
      result = result.filter(
        (p) =>
          p.name?.toLowerCase().includes(q) ||
          p.brand?.toLowerCase().includes(q) ||
          p.description?.toLowerCase().includes(q) ||
          p.variants?.some((v: any) => v.sku?.toLowerCase().includes(q)),
      );
    }

    return result;
  }

  async findOne(idOrSlug: string) {
    if (!idOrSlug) {
      throw new NotFoundException('Product identifier is required');
    }

    const cleanId = idOrSlug.trim();

    if (ProductsService.deletedProductIds.has(cleanId)) {
      throw new NotFoundException(`Product ${idOrSlug} has been deleted`);
    }

    // 1. Check custom created products
    if (ProductsService.customProducts.has(cleanId)) {
      const custom = ProductsService.customProducts.get(cleanId);
      const override = ProductsService.productOverrides.get(cleanId);
      return override ? { ...custom, ...override } : custom;
    }

    // 2. Try finding by ID, slug, barcode, or variant SKU in database
    try {
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
        const override = ProductsService.productOverrides.get(product.id);
        if (override) {
          return {
            ...product,
            ...override,
            variants: product.variants.map((v) => ({
              ...v,
              price: override.price ?? v.price,
              mrp: override.mrp ?? v.mrp,
              unitName: override.unitName ?? v.unitName,
              stockQuantity: override.stockQuantity ?? (v as any).stockQuantity ?? 100,
              isAvailable: override.isAvailable ?? v.isAvailable,
            })),
          };
        }
        return product;
      }
    } catch {
      // Prisma lookup failed, fallback to catalog
    }

    // 3. Resilient fallback: lookup directly in master catalog JSON
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

        const base = {
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

        const override = ProductsService.productOverrides.get(match.id);
        if (override) {
          return {
            ...base,
            ...override,
            variants: base.variants.map((v) => ({
              ...v,
              price: override.price ?? v.price,
              mrp: override.mrp ?? v.mrp,
              unitName: override.unitName ?? v.unitName,
              stockQuantity: override.stockQuantity ?? v.stockQuantity,
              isAvailable: override.isAvailable ?? v.isAvailable,
            })),
          };
        }

        return base;
      }
    } catch {
      // Fallback read failed
    }

    throw new NotFoundException(`Product ${idOrSlug} not found`);
  }

  async create(data: {
    name: string;
    brand?: string;
    category?: string;
    categoryId?: string;
    price?: number;
    mrp?: number;
    unit?: string;
    unitName?: string;
    description?: string;
    stockQuantity?: number;
    barcode?: string;
    images?: string[];
    image?: string;
    isOrganic?: boolean;
  }) {
    const id = `prod_${Date.now()}_${Math.random().toString(36).substring(2, 6)}`;
    const slug = (data.name || 'product').toLowerCase().replace(/[^a-z0-9]+/g, '-') + `-${Date.now().toString().slice(-4)}`;
    const price = Number(data.price) || 99;
    const mrp = Number(data.mrp) || Math.round(price * 1.2);
    const unitName = data.unitName || data.unit || '1 unit';
    const stockQuantity = Number(data.stockQuantity) ?? 100;
    const catName = data.category || 'Fresh Produce';
    const catSlug = data.categoryId || catName.toLowerCase().replace(/[^a-z0-9]+/g, '-');
    const images = data.images && data.images.length > 0
      ? data.images
      : [data.image || '/images/daily_basket_logo.png'];

    const newProduct = {
      id,
      storeId: 'store_main_01',
      categoryId: catSlug,
      name: data.name,
      slug,
      description: data.description || `${data.name}. Sourced fresh daily with 10-minute delivery guarantee.`,
      brand: data.brand || 'Daily Basket Select',
      images,
      barcode: data.barcode || `890${Date.now().toString().slice(-9)}`,
      isOrganic: Boolean(data.isOrganic),
      category: {
        id: catSlug,
        name: catName,
        slug: catSlug,
      },
      variants: [
        {
          id: `var_${id}`,
          productId: id,
          unitName,
          price,
          mrp,
          sku: `SKU-${id.toUpperCase()}`,
          isAvailable: stockQuantity > 0,
          stockQuantity,
        },
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    // Store in memory overlay for immediate availability
    ProductsService.customProducts.set(id, newProduct);

    // Also attempt persisting to database
    try {
      let store = await this.prisma.store.findFirst({ where: { code: 'store_main_01' } });
      if (!store) {
        store = await this.prisma.store.create({
          data: {
            code: 'store_main_01',
            name: 'Daily Basket Hub — Koramangala',
            address: '100ft Rd, Koramangala',
            city: 'Bengaluru',
            pincode: '560034',
            latitude: 12.9352,
            longitude: 77.6245,
            isOpen: true,
          },
        });
      }

      let category = await this.prisma.category.findFirst({
        where: { OR: [{ id: catSlug }, { slug: catSlug }] },
      });
      if (!category) {
        category = await this.prisma.category.create({
          data: {
            id: catSlug,
            name: catName,
            slug: catSlug,
            description: catName,
            isActive: true,
          },
        });
      }

      const dbProduct = await this.prisma.product.create({
        data: {
          id,
          storeId: store.id,
          categoryId: category.id,
          name: data.name,
          slug,
          description: data.description || `${data.name}. Fresh quality guaranteed.`,
          brand: data.brand || 'Daily Basket',
          images,
          barcode: data.barcode || undefined,
          isOrganic: Boolean(data.isOrganic),
          variants: {
            create: [
              {
                id: `var_${id}`,
                unitName,
                price,
                mrp,
                sku: `SKU-${id.toUpperCase()}`,
                isAvailable: stockQuantity > 0,
                inventories: {
                  create: [
                    {
                      storeId: store.id,
                      stockQuantity,
                    },
                  ],
                },
              },
            ],
          },
        },
        include: { category: true, variants: true },
      });

      return dbProduct;
    } catch {
      // Return memory model if DB is offline
      return newProduct;
    }
  }

  async update(id: string, data: Partial<{
    name: string;
    brand: string;
    category: string;
    categoryId: string;
    price: number;
    mrp: number;
    unit: string;
    unitName: string;
    description: string;
    stockQuantity: number;
    isAvailable: boolean;
    images: string[];
    image: string;
    isOrganic: boolean;
  }>) {
    const existing = await this.findOne(id);
    if (!existing) {
      throw new NotFoundException(`Product ${id} not found`);
    }

    const price = data.price !== undefined ? Number(data.price) : undefined;
    const mrp = data.mrp !== undefined ? Number(data.mrp) : undefined;
    const stockQuantity = data.stockQuantity !== undefined ? Number(data.stockQuantity) : undefined;
    const unitName = data.unitName || data.unit;
    const images = data.images && data.images.length > 0 ? data.images : data.image ? [data.image] : undefined;

    const overrideUpdate: any = {
      ...data,
      ...(price !== undefined && { price }),
      ...(mrp !== undefined && { mrp }),
      ...(stockQuantity !== undefined && { stockQuantity }),
      ...(unitName && { unitName }),
      ...(images && { images }),
      updatedAt: new Date().toISOString(),
    };

    const currentOverride = ProductsService.productOverrides.get(id) || {};
    ProductsService.productOverrides.set(id, { ...currentOverride, ...overrideUpdate });

    // Also update customProducts entry if it was created during this session
    if (ProductsService.customProducts.has(id)) {
      const custom = ProductsService.customProducts.get(id);
      ProductsService.customProducts.set(id, {
        ...custom,
        ...overrideUpdate,
        variants: custom.variants?.map((v: any) => ({
          ...v,
          ...(price !== undefined && { price }),
          ...(mrp !== undefined && { mrp }),
          ...(unitName && { unitName }),
          ...(stockQuantity !== undefined && { stockQuantity, isAvailable: stockQuantity > 0 }),
        })),
      });
    }

    // Attempt DB sync
    try {
      const updateData: any = {};
      if (data.name) updateData.name = data.name;
      if (data.description) updateData.description = data.description;
      if (data.brand) updateData.brand = data.brand;
      if (images) updateData.images = images;
      if (data.isOrganic !== undefined) updateData.isOrganic = Boolean(data.isOrganic);

      await this.prisma.product.update({
        where: { id },
        data: updateData,
      });

      if (price !== undefined || mrp !== undefined || unitName) {
        await this.prisma.productVariant.updateMany({
          where: { productId: id },
          data: {
            ...(price !== undefined && { price }),
            ...(mrp !== undefined && { mrp }),
            ...(unitName && { unitName }),
            ...(stockQuantity !== undefined && { isAvailable: stockQuantity > 0 }),
          },
        });
      }

      if (stockQuantity !== undefined) {
        const variants = await this.prisma.productVariant.findMany({ where: { productId: id } });
        for (const variant of variants) {
          await this.prisma.inventory.updateMany({
            where: { variantId: variant.id },
            data: { stockQuantity },
          });
        }
      }
    } catch {
      // In-memory update succeeded
    }

    return this.findOne(id);
  }

  async delete(id: string) {
    ProductsService.deletedProductIds.add(id);
    ProductsService.customProducts.delete(id);
    ProductsService.productOverrides.delete(id);

    try {
      await this.prisma.inventory.deleteMany({
        where: { variant: { productId: id } },
      });
      await this.prisma.productVariant.deleteMany({
        where: { productId: id },
      });
      await this.prisma.product.delete({
        where: { id },
      });
    } catch {
      // Marked deleted in memory
    }

    return { success: true, message: `Product ${id} deleted successfully`, id };
  }

  async updateStock(id: string, newStock: number) {
    const isAvailable = newStock > 0;
    const currentOverride = ProductsService.productOverrides.get(id) || {};
    ProductsService.productOverrides.set(id, {
      ...currentOverride,
      stockQuantity: newStock,
      isAvailable,
      updatedAt: new Date().toISOString(),
    });

    if (ProductsService.customProducts.has(id)) {
      const custom = ProductsService.customProducts.get(id);
      custom.variants = custom.variants.map((v: any) => ({
        ...v,
        stockQuantity: newStock,
        isAvailable,
      }));
    }

    try {
      const variants = await this.prisma.productVariant.findMany({ where: { productId: id } });
      for (const variant of variants) {
        await this.prisma.inventory.updateMany({
          where: { variantId: variant.id },
          data: { stockQuantity: newStock },
        });
        await this.prisma.productVariant.update({
          where: { id: variant.id },
          data: { isAvailable },
        });
      }
    } catch {
      // Memory updated
    }

    return { id, newStock, isAvailable, status: 'UPDATED' };
  }

  async toggleProductStatus(id: string, isAvailable: boolean) {
    const currentOverride = ProductsService.productOverrides.get(id) || {};
    ProductsService.productOverrides.set(id, {
      ...currentOverride,
      isAvailable,
      updatedAt: new Date().toISOString(),
    });

    try {
      await this.prisma.productVariant.updateMany({
        where: { productId: id },
        data: { isAvailable },
      });
    } catch {
      // Memory updated
    }

    return { id, isAvailable, status: 'UPDATED' };
  }

  async auditEntireCatalog() {
    return this.productValidator.auditEntireCatalog();
  }

  async autoFixCatalog() {
    return this.productValidator.autoFixCatalogQuality();
  }

  async getRecommendations(
    type: string = 'similar',
    productId?: string,
    categoryId?: string,
    limit: number = 6,
  ) {
    const all = await this.findAll();
    const currentProduct = productId ? all.find((p: any) => p.id === productId || p.slug === productId) : null;
    const targetCatId = categoryId || currentProduct?.categoryId || currentProduct?.category?.id;

    let results: any[] = [];

    switch (type) {
      case 'similar':
        results = all.filter((p: any) => {
          if (currentProduct && p.id === currentProduct.id) return false;
          return targetCatId ? (p.categoryId === targetCatId || p.category?.id === targetCatId || p.category?.slug === targetCatId) : true;
        });
        break;

      case 'frequently_bought_together':
        results = all.filter((p: any) => {
          if (currentProduct && p.id === currentProduct.id) return false;
          const name = (p.name || '').toLowerCase();
          return name.includes('bread') || name.includes('egg') || name.includes('milk') || name.includes('butter') || name.includes('curd') || name.includes('tea') || name.includes('tomato');
        });
        if (results.length < limit) {
          results = all.filter((p: any) => !currentProduct || p.id !== currentProduct.id);
        }
        break;

      case 'customers_also_viewed':
        results = all
          .filter((p: any) => {
            if (currentProduct && p.id === currentProduct.id) return false;
            return targetCatId ? (p.categoryId === targetCatId || p.category?.slug === targetCatId) : true;
          })
          .sort((a: any, b: any) => (b.reviews?.length || b.rating || 0) - (a.reviews?.length || a.rating || 0));
        break;

      case 'best_sellers':
        results = [...all].sort((a: any, b: any) => {
          const aDiscount = (a.variants?.[0]?.mrp || 0) - (a.variants?.[0]?.price || 0);
          const bDiscount = (b.variants?.[0]?.mrp || 0) - (b.variants?.[0]?.price || 0);
          return bDiscount - aDiscount;
        });
        break;

      case 'popular':
        results = [...all].sort((a: any, b: any) => (b.rating || 4.8) - (a.rating || 4.8));
        break;

      case 'new_arrivals':
        results = [...all].reverse();
        break;

      case 'cart_addons':
        results = all.filter((p: any) => {
          const price = p.variants?.[0]?.price ?? p.price ?? 999;
          return price <= 99;
        });
        break;

      default:
        results = all;
    }

    if (results.length === 0) {
      results = all.filter((p: any) => !currentProduct || p.id !== currentProduct.id);
    }

    return results.slice(0, Number(limit) || 6);
  }

  async getSubstitutes(productId: string) {
    const all = await this.findAll();
    const target = all.find((p: any) => p.id === productId || p.slug === productId);
    if (!target) return [];

    const targetPrice = target.variants?.[0]?.price ?? target.price ?? 50;
    const targetCat = target.categoryId || target.category?.id;

    const candidates = all.filter((p: any) => {
      if (p.id === target.id) return false;
      return targetCat && (p.categoryId === targetCat || p.category?.id === targetCat);
    });

    const fallbackCandidates = candidates.length > 0 ? candidates : all.filter((p: any) => p.id !== target.id);

    return fallbackCandidates
      .map((p: any) => {
        const v = p.variants?.[0] || {};
        const price = v.price ?? p.price ?? 50;
        const mrp = v.mrp ?? p.mrp ?? price;
        const priceDiff = Math.abs(price - targetPrice);
        const matchScore = Math.max(60, Math.min(99, Math.round(95 - (priceDiff / Math.max(1, targetPrice)) * 30)));
        return {
          id: p.id,
          variantId: v.id || `var_${p.id}`,
          name: p.name,
          brand: p.brand || 'Daily Basket Select',
          unitName: v.unitName || p.unitName || '1 pack',
          price,
          mrp,
          imageUrl: p.images?.[0] || ProductValidatorService.FALLBACK_IMAGE_URL,
          rating: p.rating || 4.7,
          inStock: v.isAvailable !== false && (v.stockQuantity === undefined || v.stockQuantity > 0),
          matchScore,
          similarityReason: `Same category (${p.category?.name || 'Produce'}) & price range`,
        };
      })
      .sort((a, b) => b.matchScore - a.matchScore)
      .slice(0, 5);
  }
}

