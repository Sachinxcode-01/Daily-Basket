import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface CreateStoreDto {
  name: string;
  code: string;
  address: string;
  city: string;
  pincode: string;
  latitude: number;
  longitude: number;
  type?: string; // OWNED, FRANCHISE
}

@Injectable()
export class MultiStoreService {
  constructor(private readonly prisma: PrismaService) {}

  async listStores(city?: string) {
    const stores = await this.prisma.store.findMany({
      where: city ? { city } : undefined,
      include: { settings: true },
      orderBy: { name: 'asc' },
    });

    if (stores.length === 0) {
      return [
        {
          id: 'store_01',
          name: 'Daily Basket Main Kirana (Indiranagar)',
          code: 'DB_BLR_01',
          city: 'Bengaluru',
          address: '100ft Rd, Indiranagar, Bengaluru',
          type: 'OWNED',
          isOpen: true,
          activeOrders: 8,
          dailyRevenue: 28480.0,
        },
        {
          id: 'store_02',
          name: 'Daily Basket Express (Koramangala)',
          code: 'DB_BLR_02',
          city: 'Bengaluru',
          address: '5th Block, Koramangala, Bengaluru',
          type: 'FRANCHISE',
          isOpen: true,
          activeOrders: 14,
          dailyRevenue: 34200.0,
        },
        {
          id: 'store_03',
          name: 'Daily Basket Superstore (HSR Layout)',
          code: 'DB_BLR_03',
          city: 'Bengaluru',
          address: '27th Main Rd, HSR Layout, Bengaluru',
          type: 'OWNED',
          isOpen: true,
          activeOrders: 11,
          dailyRevenue: 41800.0,
        },
      ];
    }
    return stores;
  }

  async createStore(dto: CreateStoreDto) {
    return this.prisma.store.create({
      data: {
        name: dto.name,
        code: dto.code,
        address: dto.address,
        city: dto.city,
        pincode: dto.pincode,
        latitude: dto.latitude,
        longitude: dto.longitude,
        isOpen: true,
      },
    });
  }

  async getStoreAnalytics(storeId: string) {
    return {
      storeId,
      period: 'TODAY',
      totalRevenue: 34200.0,
      totalOrdersCount: 142,
      averageFulfillmentMins: 8.4,
      onTimeDeliveryRate: 98.6,
      topSellingCategories: ['Dairy & Milk', 'Atta & Flours', 'Fresh Vegetables'],
    };
  }
}
