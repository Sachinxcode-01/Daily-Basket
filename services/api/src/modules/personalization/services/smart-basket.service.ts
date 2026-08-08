import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

export interface SmartBasketItem {
  productId: string;
  name: string;
  brand: string;
  price: number;
  unit: string;
  imageUrl: string;
  predictionReason: string;
  confidenceScore: number;
}

export interface BasketOptimizationResult {
  currentSubtotal: number;
  deliveryFee: number;
  optimizedDeliveryFee: number;
  suggestedAdditions: any[];
  bundleSavingsAmount: number;
  potentialCashback: number;
  recommendationsSummary: string;
}

@Injectable()
export class SmartBasketService {
  private readonly logger = new Logger(SmartBasketService.name);

  constructor(private prisma: PrismaService) {}

  async generateSmartWeeklyBasket(userId: string): Promise<{ items: SmartBasketItem[]; totalBasketAmount: number }> {
    this.logger.log(`Predicting Smart Weekly Basket for user: ${userId}`);

    const dbProducts = await this.prisma.product.findMany({
      take: 6,
      include: { variants: true, category: true },
    });

    const items: SmartBasketItem[] = dbProducts.map((p, idx) => ({
      productId: p.id,
      name: p.name,
      brand: p.brand || 'Daily Basket',
      price: p.variants[0]?.price || 56,
      unit: p.variants[0]?.unitName || '1 unit',
      imageUrl: p.images[0] || 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
      predictionReason: idx % 2 === 0 ? 'Predicted weekly staple' : 'Frequently reordered every 5 days',
      confidenceScore: Math.round(92.0 + idx * 1.2),
    }));

    const totalBasketAmount = items.reduce((sum, item) => sum + item.price, 0);

    return { items, totalBasketAmount };
  }

  async optimizeBasket(userId: string, currentItems: any[]): Promise<BasketOptimizationResult> {
    const subtotal = currentItems.reduce((sum, item) => sum + (item.price || 50) * (item.qty || 1), 0);
    const deliveryFee = subtotal >= 499 ? 0 : 30;
    const amountToFreeDelivery = Math.max(0, 499 - subtotal);

    let suggestedAdditions: any[] = [];
    if (amountToFreeDelivery > 0) {
      const cheapAdditions = await this.prisma.product.findMany({
        where: { variants: { some: { price: { lte: amountToFreeDelivery + 50 } } } },
        take: 2,
        include: { variants: true },
      });

      suggestedAdditions = cheapAdditions.map((p) => ({
        id: p.id,
        name: p.name,
        price: p.variants[0]?.price || 30,
        unit: p.variants[0]?.unitName || '100g',
      }));
    }

    return {
      currentSubtotal: subtotal,
      deliveryFee,
      optimizedDeliveryFee: amountToFreeDelivery === 0 ? 0 : 0,
      suggestedAdditions,
      bundleSavingsAmount: 45,
      potentialCashback: 25,
      recommendationsSummary:
        amountToFreeDelivery > 0
          ? `Add ₹${amountToFreeDelivery} more to get FREE 10-minute delivery!`
          : 'Congratulations! Your basket qualifies for FREE delivery and ₹45 bundle savings.',
    };
  }
}
