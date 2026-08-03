import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class SearchService {
  constructor(private prisma: PrismaService) {}

  async searchProducts(query: string) {
    if (!query || query.trim() === '') {
      return {
        products: [],
        suggestions: ['Tomatoes', 'Amul Milk', 'Brown Bread', 'Alphonso Mangoes'],
        recentSearches: ['Fresh Organic Produce', 'Dairy Milk', 'Atta & Flour'],
      };
    }

    const products = await this.prisma.product.findMany({
      where: {
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { description: { contains: query, mode: 'insensitive' } },
          { tags: { hasSome: [query.toLowerCase()] } },
        ],
      },
      include: { category: true, variants: true },
    });

    const suggestions = [
      `${query} 500g`,
      `Organic ${query}`,
      `Fresh ${query} pack`,
    ];

    return {
      products,
      suggestions,
      totalCount: products.length,
    };
  }
}
