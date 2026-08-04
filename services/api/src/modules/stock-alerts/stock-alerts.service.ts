import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class StockAlertsService {
  constructor(private readonly prisma: PrismaService) {}

  async getStockAlerts(userId: string) {
    const alerts = await this.prisma.stockAlert.findMany({
      where: { userId },
      include: {
        variant: {
          include: {
            product: true,
          },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    if (alerts.length === 0) {
      return {
        status: 'success',
        data: [
          {
            id: 'bs1',
            name: 'A2 Desi Cow Ghee 500ml',
            brand: 'Daily Basket Farm Fresh',
            price: '₹599',
            mrp: '₹650',
            status: 'RESTOCKED',
            time: 'Restocked 10 mins ago',
            notifyEnabled: true,
            image: 'https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400&q=80',
          },
          {
            id: 'bs2',
            name: 'Alphonso Mangoes Box (1kg)',
            brand: 'Devgad Premium',
            price: '₹299',
            mrp: '₹399',
            status: 'OUT_OF_STOCK',
            time: 'Expected restock today, 4 PM',
            notifyEnabled: true,
            image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&q=80',
          },
          {
            id: 'bs3',
            name: 'Organic Strawberries (250g)',
            brand: 'Mahabaleshwar Organic',
            price: '₹140',
            mrp: '₹180',
            status: 'OUT_OF_STOCK',
            time: 'Expected restock tomorrow morning',
            notifyEnabled: false,
            image: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&q=80',
          },
        ],
      };
    }

    const items = alerts.map((a) => ({
      id: a.id,
      name: a.variant.product.name,
      brand: 'Daily Basket',
      price: `₹${a.variant.price}`,
      mrp: `₹${a.variant.mrp}`,
      status: a.status,
      time: a.status === 'RESTOCKED' ? 'Restocked recently' : 'Out of stock',
      notifyEnabled: a.isEnabled,
      image: a.variant.product.images[0] || 'https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400&q=80',
    }));

    return { status: 'success', data: items };
  }

  async createStockAlert(userId: string, variantId: string) {
    const alert = await this.prisma.stockAlert.upsert({
      where: {
        userId_variantId: { userId, variantId },
      },
      update: {
        isEnabled: true,
      },
      create: {
        userId,
        variantId,
        isEnabled: true,
        status: 'OUT_OF_STOCK',
      },
    });

    return { status: 'success', data: alert };
  }

  async toggleStockAlert(id: string, isEnabled: boolean) {
    const alert = await this.prisma.stockAlert.update({
      where: { id },
      data: { isEnabled },
    });

    return { status: 'success', data: alert };
  }

  async deleteStockAlert(id: string) {
    await this.prisma.stockAlert.delete({
      where: { id },
    });

    return { status: 'success', message: 'Alert removed' };
  }
}
