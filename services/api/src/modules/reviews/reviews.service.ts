import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class ReviewsService {
  constructor(private prisma: PrismaService) {}

  async getProductReviews(productId: string = 'prod_1') {
    return [
      {
        id: 'rev_1',
        user: 'Pooja Sharma',
        rating: 5,
        comment: 'Extremely fresh organic tomatoes! Delivered in just 7 minutes!',
        date: '2 hours ago',
      },
      {
        id: 'rev_2',
        user: 'Arjun Mehta',
        rating: 5,
        comment: 'Great packaging and super fast 10-minute delivery.',
        date: 'Yesterday',
      },
    ];
  }

  async createReview(data: { productId: string; rating: number; comment: string }) {
    return {
      success: true,
      id: `rev_${Date.now()}`,
      ...data,
      message: 'Thank you! Your product review has been submitted.',
    };
  }
}
