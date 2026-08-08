import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';
import { DetectedVisualProduct } from './vision.service';
import { OcrExtractedMetadata } from './ocr.service';

export interface ProductMatchResult {
  exactMatch?: any;
  similarProducts: any[];
  healthyAlternatives: any[];
  budgetAlternatives: any[];
  organicAlternatives: any[];
  matchType: 'EXACT' | 'SIMILAR' | 'ALTERNATIVES_ONLY';
  overallConfidence: number;
}

@Injectable()
export class ProductMatchingService {
  private readonly logger = new Logger(ProductMatchingService.name);

  constructor(private prisma: PrismaService) {}

  async matchProducts(
    detectedProducts: DetectedVisualProduct[],
    ocrMetadata?: OcrExtractedMetadata,
  ): Promise<ProductMatchResult> {
    this.logger.log(`Matching ${detectedProducts.length} visual items against dark store catalog...`);

    const primaryItem = detectedProducts[0];
    const searchTerm = ocrMetadata?.brand || primaryItem?.brand || primaryItem?.detectedName || 'Milk';

    // Search local database products
    const dbProducts = await this.prisma.product.findMany({
      where: {
        OR: [
          { name: { contains: searchTerm, mode: 'insensitive' } },
          { brand: { contains: searchTerm, mode: 'insensitive' } },
          { tags: { hasSome: [searchTerm] } },
        ],
      },
      take: 8,
      include: { variants: true, category: true, aiInsight: true },
    });

    const formattedProducts = dbProducts.map((p) => ({
      id: p.id,
      name: p.name,
      brand: p.brand || 'Daily Basket',
      category: p.category?.name || 'Grocery',
      price: p.variants[0]?.price || 60,
      mrp: p.variants[0]?.mrp || 65,
      unit: p.variants[0]?.unitName || '1L',
      imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      isOrganic: p.isOrganic,
      healthScore: p.aiInsight?.healthScore || 8.5,
      confidenceScore: Math.min(99.5, (primaryItem?.confidenceScore || 90) + (ocrMetadata ? 4 : 0)),
    }));

    const exactMatch = formattedProducts.length > 0 ? formattedProducts[0] : undefined;
    const similarProducts = formattedProducts.slice(1);

    const healthyAlternatives = formattedProducts.filter((p) => p.healthScore >= 8.5);
    const budgetAlternatives = [...formattedProducts].sort((a, b) => a.price - b.price).slice(0, 3);
    const organicAlternatives = formattedProducts.filter((p) => p.isOrganic);

    return {
      exactMatch,
      similarProducts,
      healthyAlternatives,
      budgetAlternatives,
      organicAlternatives,
      matchType: exactMatch ? 'EXACT' : 'SIMILAR',
      overallConfidence: exactMatch ? exactMatch.confidenceScore : 88.0,
    };
  }
}
