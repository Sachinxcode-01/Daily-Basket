import { Injectable, Scope } from '@nestjs/common';
import DataLoader from 'dataloader';
import { PrismaService } from '../../database/prisma.service';

@Injectable({ scope: Scope.REQUEST })
export class DataLoaderService {
  constructor(private readonly prisma: PrismaService) {}

  // DataLoader for batching Product Variants by productId
  public readonly variantsByProductId = new DataLoader<string, any[]>(
    async (productIds: readonly string[]) => {
      const variants = await this.prisma.productVariant.findMany({
        where: { productId: { in: [...productIds] } },
      });

      const variantMap = new Map<string, any[]>();
      productIds.forEach((id) => variantMap.set(id, []));
      variants.forEach((v) => {
        const list = variantMap.get(v.productId) || [];
        list.push(v);
        variantMap.set(v.productId, list);
      });

      return productIds.map((id) => variantMap.get(id) || []);
    },
  );

  // DataLoader for batching Categories by ID
  public readonly categoryById = new DataLoader<string, any>(
    async (categoryIds: readonly string[]) => {
      const categories = await this.prisma.category.findMany({
        where: { id: { in: [...categoryIds] } },
      });
      const map = new Map(categories.map((c) => [c.id, c]));
      return categoryIds.map((id) => map.get(id) || null);
    },
  );

  // DataLoader for batching Inventory by variantId
  public readonly inventoryByVariantId = new DataLoader<string, any[]>(
    async (variantIds: readonly string[]) => {
      const inventories = await this.prisma.inventory.findMany({
        where: { variantId: { in: [...variantIds] } },
      });

      const invMap = new Map<string, any[]>();
      variantIds.forEach((id) => invMap.set(id, []));
      inventories.forEach((inv) => {
        const list = invMap.get(inv.variantId) || [];
        list.push(inv);
        invMap.set(inv.variantId, list);
      });

      return variantIds.map((id) => invMap.get(id) || []);
    },
  );

  // DataLoader for batching Users by ID
  public readonly userById = new DataLoader<string, any>(
    async (userIds: readonly string[]) => {
      const users = await this.prisma.user.findMany({
        where: { id: { in: [...userIds] } },
        select: {
          id: true,
          fullName: true,
          email: true,
          phoneNumber: true,
          role: true,
          avatarUrl: true,
        },
      });
      const map = new Map(users.map((u) => [u.id, u]));
      return userIds.map((id) => map.get(id) || null);
    },
  );
}
