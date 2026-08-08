import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface UpdateStoreSettingsDto {
  isOpen?: boolean;
  businessHours?: { open: string; close: string };
  holidaySchedule?: Array<{ date: string; reason: string }>;
  deliveryRadiusKm?: number;
  minOrderValue?: number;
  maxDeliveryDistanceKm?: number;
  storeCapacityPerHour?: number;
  orderCutoffTime?: string;
  isMaintenanceMode?: boolean;
  maintenanceMessage?: string;
}

@Injectable()
export class StoreOperationsService {
  constructor(private readonly prisma: PrismaService) {}

  async getStoreStatus(storeId: string = 'default-store-id') {
    const store = await this.prisma.store.findFirst();
    if (!store) {
      return {
        storeId: 'demo-store-01',
        name: 'Daily Basket Main Kirana',
        isOpen: true,
        businessHours: { open: '07:00', close: '22:00' },
        deliveryRadiusKm: 5.0,
        minOrderValue: 149.0,
        storeCapacityPerHour: 60,
        orderCutoffTime: '21:30',
        isMaintenanceMode: false,
        activeOrdersCount: 8,
        packingQueueCount: 3,
      };
    }

    const settings = await this.prisma.storeSettings.findUnique({
      where: { storeId: store.id },
    });

    return {
      storeId: store.id,
      name: store.name,
      address: store.address,
      isOpen: settings?.isOpen ?? store.isOpen,
      businessHours: settings?.businessHours ?? { open: '07:00', close: '22:00' },
      holidaySchedule: settings?.holidaySchedule ?? [],
      deliveryRadiusKm: settings?.deliveryRadiusKm ?? 5.0,
      minOrderValue: settings?.minOrderValue ?? 149.0,
      maxDeliveryDistanceKm: settings?.maxDeliveryDistanceKm ?? 10.0,
      storeCapacityPerHour: settings?.storeCapacityPerHour ?? 60,
      orderCutoffTime: settings?.orderCutoffTime ?? '21:30',
      isMaintenanceMode: settings?.isMaintenanceMode ?? false,
      maintenanceMessage: settings?.maintenanceMessage,
    };
  }

  async toggleStoreStatus(storeId: string, isOpen: boolean) {
    const store = await this.prisma.store.findFirst();
    const targetId = store ? store.id : storeId;

    await this.prisma.storeSettings.upsert({
      where: { storeId: targetId },
      update: { isOpen },
      create: {
        storeId: targetId,
        isOpen,
        businessHours: { open: '07:00', close: '22:00' },
      },
    });

    return { storeId: targetId, isOpen, message: `Store status updated to ${isOpen ? 'OPEN' : 'CLOSED'}` };
  }

  async updateStoreSettings(storeId: string, dto: UpdateStoreSettingsDto) {
    const store = await this.prisma.store.findFirst();
    const targetId = store ? store.id : storeId;

    const updated = await this.prisma.storeSettings.upsert({
      where: { storeId: targetId },
      update: { ...dto },
      create: {
        storeId: targetId,
        isOpen: dto.isOpen ?? true,
        businessHours: dto.businessHours ?? { open: '07:00', close: '22:00' },
        ...dto,
      },
    });

    return updated;
  }
}
