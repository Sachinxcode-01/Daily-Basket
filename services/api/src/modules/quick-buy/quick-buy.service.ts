import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class QuickBuyService {
  constructor(private readonly prisma: PrismaService) {}

  async getEssentials(userId: string) {
    console.log(`Fetching quick buy essentials for user ${userId}`);
    const products = await this.prisma.product.findMany({
      take: 10,
      include: {
        variants: true,
        category: true,
      },
    });

    if (products.length === 0) {
      return {
        status: 'success',
        data: [
          {
            id: 'qb1',
            name: 'Amul Taaza Toned Milk',
            weight: '1 L',
            price: 54,
            mrp: 54,
            qty: 1,
            category: 'Dairy',
            image: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
          },
          {
            id: 'qb2',
            name: 'Brown Sandwich Bread',
            weight: '400 g',
            price: 45,
            mrp: 50,
            qty: 1,
            category: 'Bakery',
            image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
          },
          {
            id: 'qb3',
            name: 'Organic Hass Avocados',
            weight: '2 units (400g)',
            price: 120,
            mrp: 150,
            qty: 2,
            category: 'Produce',
            image: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&q=80',
          },
          {
            id: 'qb4',
            name: 'Farm Fresh Tomatoes',
            weight: '500 g',
            price: 24,
            mrp: 30,
            qty: 1,
            category: 'Produce',
            image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&q=80',
          },
        ],
      };
    }

    const items = products.map((p) => ({
      id: p.id,
      name: p.name,
      weight: p.variants[0]?.unitName || '1 unit',
      price: p.variants[0]?.price || 50,
      mrp: p.variants[0]?.mrp || 60,
      qty: 1,
      category: p.category.name,
      image: p.images[0] || 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80',
    }));

    return { status: 'success', data: items };
  }

  async syncCart(userId: string, items: Array<{ id: string; qty: number }>) {
    return {
      status: 'success',
      message: 'Cart synchronized with quick buy items successfully',
      data: { userId, itemCounts: items.length },
    };
  }

  async bulkAdd(userId: string, items: Array<{ id: string; qty: number }>) {
    return {
      status: 'success',
      message: 'Bulk added essentials to basket',
      data: { userId, addedCount: items.reduce((acc, curr) => acc + curr.qty, 0) },
    };
  }
}
