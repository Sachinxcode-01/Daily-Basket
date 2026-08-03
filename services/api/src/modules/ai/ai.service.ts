import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class AiService {
  constructor(private prisma: PrismaService) {}

  async processAiShoppingQuery(query: string) {
    const normalizedQuery = query.toLowerCase();

    if (normalizedQuery.includes('salad') || normalizedQuery.includes('healthy')) {
      return {
        query,
        aiIntent: 'HEALTHY_SALAD_RECIPE',
        suggestedProducts: [
          { id: 'p1', name: 'Organic Farm Tomatoes', unit: '500g', price: 24 },
          { id: 'p4', name: 'Fresh Cucumbers', unit: '500g', price: 20 },
        ],
        aiTip: 'Great choice! These fresh organic vegetables will make a nutrient-rich garden salad.',
      };
    }

    return {
      query,
      aiIntent: 'GENERAL_GROCERY_SEARCH',
      suggestedProducts: [
        { id: 'p2', name: 'Amul Taaza Toned Milk', unit: '1 Litre', price: 54 },
        { id: 'p3', name: 'Brown Sandwich Bread', unit: '400g', price: 45 },
      ],
      aiTip: 'Here are the top-rated essentials matching your search.',
    };
  }

  async getSmartSubstitutions(productId: string) {
    return {
      productId,
      substitutions: [
        { id: 'sub_1', name: 'Organic Roma Tomatoes', unit: '500g', price: 26, matchPercentage: 98 },
        { id: 'sub_2', name: 'Cherry Tomatoes Box', unit: '250g', price: 35, matchPercentage: 92 },
      ],
    };
  }

  async getDemandForecast(storeId: string = 'store_main_01') {
    return {
      storeId,
      forecastDate: new Date().toISOString().split('T')[0],
      predictedPeakHours: ['08:00 AM - 10:00 AM', '06:00 PM - 09:00 PM'],
      predictedTopItems: [
        { name: 'Organic Tomatoes', expectedDemandUnits: 480, restockRecommended: 200 },
        { name: 'Amul Toned Milk', expectedDemandUnits: 400, restockRecommended: 150 },
      ],
      confidenceScore: 0.94,
    };
  }
}
