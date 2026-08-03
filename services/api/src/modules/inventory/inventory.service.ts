import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class InventoryService {
  constructor(private prisma: PrismaService) {}

  async getStoreInventory(storeId: string) {
    return this.prisma.inventory.findMany({
      where: { storeId },
      include: { variant: { include: { product: true } } },
    });
  }

  async updateStock(storeId: string, variantId: string, stockQuantity: number) {
    return this.prisma.inventory.upsert({
      where: { storeId_variantId: { storeId, variantId } },
      update: { stockQuantity },
      create: { storeId, variantId, stockQuantity },
    });
  }
}
