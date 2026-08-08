import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface CreateWarehouseDto {
  name: string;
  code: string;
  city: string;
  address: string;
  latitude: number;
  longitude: number;
  capacitySqFt?: number;
}

export interface CreateTransferDto {
  fromType: string;
  fromId: string;
  toType: string;
  toId: string;
  items: Array<{ productId: string; quantity: number }>;
}

@Injectable()
export class WarehouseService {
  constructor(private readonly prisma: PrismaService) {}

  async listWarehouses(city?: string) {
    const warehouses = await this.prisma.warehouse.findMany({
      where: city ? { city } : undefined,
      orderBy: { name: 'asc' },
    });

    if (warehouses.length === 0) {
      return [
        {
          id: 'wh_01',
          name: 'Central Fulfillment Hub - Whitefield',
          code: 'WH_BLR_01',
          city: 'Bengaluru',
          address: 'Whitefield Main Rd, Bengaluru',
          capacitySqFt: 35000,
          occupancyPercent: 68.4,
          storageZones: ['RECEIVING', 'PACKING', 'DISPATCH', 'COLD_STORAGE', 'DAMAGED'],
          isActive: true,
        },
        {
          id: 'wh_02',
          name: 'North Micro-Warehouse - Peenya',
          code: 'WH_BLR_02',
          city: 'Bengaluru',
          address: 'Peenya 3rd Stage, Bengaluru',
          capacitySqFt: 18000,
          occupancyPercent: 52.1,
          storageZones: ['RECEIVING', 'PACKING', 'DISPATCH'],
          isActive: true,
        },
      ];
    }
    return warehouses;
  }

  async createWarehouse(dto: CreateWarehouseDto) {
    return this.prisma.warehouse.create({
      data: {
        name: dto.name,
        code: dto.code,
        city: dto.city,
        address: dto.address,
        latitude: dto.latitude,
        longitude: dto.longitude,
        capacitySqFt: dto.capacitySqFt ?? 25000,
        storageZones: ['RECEIVING', 'PACKING', 'DISPATCH', 'COLD_STORAGE'],
        shelfMap: { racks: 12, shelvesPerRack: 5 },
      },
    });
  }

  async listTransfers() {
    const transfers = await this.prisma.interLocationTransfer.findMany({
      orderBy: { createdAt: 'desc' },
    });

    if (transfers.length === 0) {
      return [
        {
          id: 'tr_101',
          transferNumber: 'TR-2026-089',
          fromType: 'WAREHOUSE',
          fromName: 'Whitefield Central Hub',
          toType: 'STORE',
          toName: 'Indiranagar Main Kirana',
          status: 'IN_TRANSIT',
          itemsCount: 14,
          trackingNumber: 'TRK-98231',
          createdAt: new Date(),
        },
      ];
    }
    return transfers;
  }

  async createTransfer(dto: CreateTransferDto) {
    const count = await this.prisma.interLocationTransfer.count();
    const transferNumber = `TR-2026-${String(count + 1).padStart(3, '0')}`;

    return this.prisma.interLocationTransfer.create({
      data: {
        transferNumber,
        fromType: dto.fromType,
        fromId: dto.fromId,
        toType: dto.toType,
        toId: dto.toId,
        items: dto.items,
        status: 'APPROVED',
        trackingNumber: `TRK-${Date.now().toString().slice(-6)}`,
      },
    });
  }
}
