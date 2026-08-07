import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface VisionAnalysisResult {
  extractedMetadata: {
    productName: string;
    brand: string;
    category: string;
    weight: string;
    mrp: number;
    variant: string;
    barcode?: string;
    confidenceScore: number;
    description: string;
  };
  matchedProducts: Array<{
    id: string;
    name: string;
    brand: string;
    categoryName: string;
    price: number;
    mrp: number;
    unit: string;
    imageUrl: string;
    rating: number;
    deliveryEtaMins: number;
    confidencePercentage: number;
    isAvailable: boolean;
    stock: number;
  }>;
  noMatchFound: boolean;
  similarProducts?: any[];
  sameBrandProducts?: any[];
  sameCategoryProducts?: any[];
}

@Injectable()
export class SearchService {
  private readonly logger = new Logger(SearchService.name);

  constructor(private prisma: PrismaService) {}

  private static readonly SYNONYM_MAP: Record<string, string[]> = {
    doodh: ['milk', 'dairy', 'taaza'],
    milk: ['doodh', 'dairy', 'toned milk'],
    atta: ['flour', 'wheat', 'chakki'],
    flour: ['atta', 'wheat', 'maida'],
    makkhan: ['butter', 'amul butter', 'spread'],
    butter: ['makkhan', 'amul', 'spread'],
    anda: ['egg', 'eggs', 'farm fresh'],
    egg: ['anda', 'eggs', 'poultry'],
    dahi: ['curd', 'yogurt', 'fresh curd'],
    curd: ['dahi', 'yogurt', 'mishti doi'],
    sabzi: ['vegetable', 'vegetables', 'veggie'],
    veggie: ['vegetable', 'sabzi', 'fresh produce'],
    paneer: ['cottage cheese', 'fresh paneer', 'dairy'],
    ghee: ['clarified butter', 'cow ghee', 'pure ghee'],
  };

  private resolveSynonyms(query: string): string[] {
    const clean = query.trim().toLowerCase();
    const terms = new Set<string>([clean]);
    
    // Exact map check
    if (SearchService.SYNONYM_MAP[clean]) {
      SearchService.SYNONYM_MAP[clean].forEach((s) => terms.add(s));
    }

    // Word token check
    const words = clean.split(/\s+/);
    for (const w of words) {
      if (SearchService.SYNONYM_MAP[w]) {
        SearchService.SYNONYM_MAP[w].forEach((s) => terms.add(s));
      }
    }

    return Array.from(terms);
  }

  async searchProducts(query: string) {
    if (!query || query.trim() === '') {
      return {
        products: [],
        suggestions: [
          'Tomatoes',
          'Amul Milk',
          'Aashirvaad Atta',
          'Fortune Oil',
          'Cadbury Silk',
        ],
        recentSearches: ['Fresh Organic Produce', 'Dairy Milk', 'Atta & Flour'],
      };
    }

    const searchTerms = this.resolveSynonyms(query);

    const searchConditions = searchTerms.flatMap((term) => [
      { name: { contains: term, mode: 'insensitive' as const } },
      { description: { contains: term, mode: 'insensitive' as const } },
      { brand: { contains: term, mode: 'insensitive' as const } },
      { barcode: { equals: term } },
      { tags: { hasSome: [term] } },
      { searchKeywords: { hasSome: [term] } },
    ]);

    const products = await this.prisma.product.findMany({
      where: {
        OR: searchConditions,
      },
      include: { category: true, variants: true },
    });

    const suggestions = [
      `${query} 500g`,
      `Organic ${query}`,
      `Fresh ${query} pack`,
      `Best price ${query}`,
    ];

    return {
      products,
      suggestions,
      totalCount: products.length,
      resolvedTerms: searchTerms,
    };
  }

  async searchByBarcode(barcode: string) {
    if (!barcode || barcode.trim() === '') {
      throw new BadRequestException('Barcode string is required');
    }

    const cleanBarcode = barcode.trim();

    // 1. Direct barcode match on Product
    let product = await this.prisma.product.findFirst({
      where: {
        OR: [
          { barcode: cleanBarcode },
          { searchKeywords: { hasSome: [cleanBarcode] } },
        ],
      },
      include: { category: true, variants: true },
    });

    // 2. Direct SKU match on ProductVariant
    if (!product) {
      const variant = await this.prisma.productVariant.findFirst({
        where: { sku: cleanBarcode },
        include: { product: { include: { category: true, variants: true } } },
      });
      if (variant) {
        product = variant.product;
      }
    }

    if (product) {
      const defaultVariant = product.variants[0] || {
        price: 99,
        mrp: 120,
        unitName: '1 unit',
        isAvailable: true,
      };
      return {
        matchedProduct: {
          id: product.id,
          name: product.name,
          brand: product.brand || 'Daily Basket',
          categoryName: product.category?.name || 'Grocery',
          price: defaultVariant.price,
          mrp: defaultVariant.mrp,
          unit: defaultVariant.unitName,
          imageUrl: product.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
          barcode: product.barcode || cleanBarcode,
          rating: 4.8,
          deliveryEtaMins: 10,
          confidencePercentage: 99.5,
          isAvailable: defaultVariant.isAvailable,
          stock: 45,
        },
        found: true,
      };
    }

    // Fallback search if exact barcode string not indexed
    const recommendations = await this.getFallbackRecommendations('Grocery');
    return {
      matchedProduct: null,
      found: false,
      message: 'No exact barcode match found.',
      ...recommendations,
    };
  }

  async analyzeVisionImage(
    base64OrBuffer?: string | Buffer,
    fileName?: string,
  ): Promise<VisionAnalysisResult> {
    this.logger.log(`Analyzing visual search image payload (${fileName || 'captured_camera_frame'})...`);

    // Simulated / Heuristic Gemini Vision extraction pipeline
    // Matches grocery packages, labels, fruits, bottles, chocolates, atta, milk, etc.
    const sampleProductSpecs = [
      {
        name: 'Organic Farm Fresh Tomatoes',
        brand: 'Daily Basket Farms',
        category: 'Fresh Fruits & Vegetables',
        weight: '500g',
        mrp: 45,
        price: 32,
        barcode: '8901030800012',
        confidence: 96.4,
        desc: 'Vibrant red organic tomatoes harvested fresh this morning.',
        imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500',
      },
      {
        name: 'Amul Taaza Toned Fresh Milk',
        brand: 'Amul',
        category: 'Dairy, Bread & Eggs',
        weight: '1 L Pouch',
        mrp: 56,
        price: 54,
        barcode: '8901262010015',
        confidence: 98.2,
        desc: 'Pasteurised toned milk with essential vitamins.',
        imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500',
      },
      {
        name: 'Aashirvaad Shuddh Chakki Atta',
        brand: 'Aashirvaad',
        category: 'Grocery',
        weight: '5 kg Bag',
        mrp: 299,
        price: 265,
        barcode: '8901058002102',
        confidence: 94.8,
        desc: '100% pure whole wheat grain chakki flour.',
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
      },
      {
        name: 'Cadbury Dairy Milk Silk Chocolate',
        brand: 'Cadbury',
        category: 'Chocolates & Ice Cream',
        weight: '150g Bar',
        mrp: 175,
        price: 160,
        barcode: '8901233020045',
        confidence: 97.1,
        desc: 'Rich, smooth & creamy milk chocolate.',
        imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500',
      },
    ];

    // Pick spec based on timestamp or random payload hash for realistic vision response
    const selected = sampleProductSpecs[Math.floor(Math.random() * sampleProductSpecs.length)];

    // Query real DB to see if matching product exists
    const dbMatch = await this.prisma.product.findFirst({
      where: {
        OR: [
          { name: { contains: selected.brand, mode: 'insensitive' } },
          { name: { contains: selected.name.split(' ')[0], mode: 'insensitive' } },
        ],
      },
      include: { category: true, variants: true },
    });

    const matchedProducts = [
      {
        id: dbMatch?.id || `p_vis_${Date.now()}`,
        name: dbMatch?.name || selected.name,
        brand: dbMatch?.brand || selected.brand,
        categoryName: dbMatch?.category?.name || selected.category,
        price: dbMatch?.variants[0]?.price || selected.price,
        mrp: dbMatch?.variants[0]?.mrp || selected.mrp,
        unit: dbMatch?.variants[0]?.unitName || selected.weight,
        imageUrl: dbMatch?.images[0] || selected.imageUrl,
        rating: 4.9,
        deliveryEtaMins: 10,
        confidencePercentage: selected.confidence,
        isAvailable: true,
        stock: 50,
      },
    ];

    const recommendations = await this.getFallbackRecommendations(selected.category, selected.brand);

    return {
      extractedMetadata: {
        productName: selected.name,
        brand: selected.brand,
        category: selected.category,
        weight: selected.weight,
        mrp: selected.mrp,
        variant: selected.weight,
        barcode: selected.barcode,
        confidenceScore: selected.confidence,
        description: selected.desc,
      },
      matchedProducts,
      noMatchFound: false,
      ...recommendations,
    };
  }

  private async getFallbackRecommendations(categoryName: string, brandName?: string) {
    const products = await this.prisma.product.findMany({
      take: 6,
      include: { category: true, variants: true },
    });

    const mapped = products.map((p) => ({
      id: p.id,
      name: p.name,
      brand: p.brand || brandName || 'Daily Basket',
      categoryName: p.category?.name || categoryName,
      price: p.variants[0]?.price || 85,
      mrp: p.variants[0]?.mrp || 110,
      unit: p.variants[0]?.unitName || '1 pack',
      imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      rating: 4.8,
      deliveryEtaMins: 10,
    }));

    return {
      similarProducts: mapped.slice(0, 3),
      sameBrandProducts: mapped.slice(1, 4),
      sameCategoryProducts: mapped.slice(2, 5),
    };
  }
}
