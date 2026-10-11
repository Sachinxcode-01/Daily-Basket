import { Test, TestingModule } from '@nestjs/testing';
import { SubstitutionsService } from './substitutions.service';
import { PrismaService } from '../../database/prisma.service';
import { InventoryService } from '../inventory/inventory.service';
import { EventsGateway } from '../events/events.gateway';
import { OrderStatus } from '@prisma/client';

describe('SubstitutionsService Unit Tests', () => {
  let service: SubstitutionsService;

  const mockInventoryService = {
    releaseStockAtomic: jest.fn().mockResolvedValue(true),
    reserveStockAtomic: jest.fn().mockResolvedValue(true),
  };

  const mockEventsGateway = {
    broadcastItemMissing: jest.fn(),
    broadcastSubstituteAccepted: jest.fn(),
    broadcastItemRemovedAndRefunded: jest.fn(),
    broadcastInventoryUpdate: jest.fn(),
    broadcastWalletUpdated: jest.fn(),
    broadcastOrderCancelled: jest.fn(),
  };

  const mockPrismaService = {
    order: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    orderItem: {
      update: jest.fn(),
      delete: jest.fn(),
    },
    productVariant: {
      findUnique: jest.fn(),
      findMany: jest.fn(),
    },
    inventory: {
      updateMany: jest.fn().mockResolvedValue({ count: 1 }),
    },
    wallet: {
      upsert: jest.fn().mockResolvedValue({ id: 'wall_01', userId: 'user_101', balance: 100 }),
      update: jest.fn().mockResolvedValue({ id: 'wall_01', balance: 125 }),
    },
    walletTransaction: {
      create: jest.fn().mockResolvedValue({ id: 'tx_01', amount: 20 }),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SubstitutionsService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: InventoryService, useValue: mockInventoryService },
        { provide: EventsGateway, useValue: mockEventsGateway },
      ],
    }).compile();

    service = module.get<SubstitutionsService>(SubstitutionsService);
  });

  describe('markItemMissing', () => {
    it('should release inventory, zero shelf stock, check sensitive categories, and offer substitutes', async () => {
      const mockOrder = {
        id: 'ord_101',
        orderNumber: 'DB-10001',
        userId: 'user_101',
        storeId: 'store_101',
        status: OrderStatus.PACKING,
        items: [
          {
            id: 'item_01',
            variantId: 'var_milk_01',
            productName: 'Cow Milk 500ml',
            quantity: 2,
            totalPrice: 60,
            variant: {
              price: 30,
              product: {
                categoryId: 'cat_dairy',
                category: { name: 'Dairy & Milk', slug: 'dairy-milk' },
              },
            },
          },
        ],
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.productVariant.findUnique.mockResolvedValue({
        id: 'var_milk_01',
        price: 30,
        product: { categoryId: 'cat_dairy' },
      });
      mockPrismaService.productVariant.findMany.mockResolvedValue([
        {
          id: 'var_sub_01',
          unitName: '500ml',
          price: 32,
          mrp: 35,
          product: { id: 'p_sub', name: 'Fresh Buffalo Milk 500ml', images: ['milk.png'] },
          inventories: [{ storeId: 'store_101', stockQuantity: 10, reservedQuantity: 2 }],
        },
      ]);

      const result = await service.markItemMissing('ord_101', 'item_01', 'Damaged in crate');

      expect(result.success).toBe(true);
      expect(result.isSensitiveCategory).toBe(false);
      expect(result.substitutes.length).toBe(1);
      expect(mockInventoryService.releaseStockAtomic).toHaveBeenCalledWith('store_101', 'var_milk_01', 2);
      expect(mockEventsGateway.broadcastItemMissing).toHaveBeenCalled();
    });

    it('should flag sensitive categories (e.g. baby food/formula) and block automated substitution suggestions', async () => {
      const mockOrder = {
        id: 'ord_102',
        orderNumber: 'DB-10002',
        userId: 'user_101',
        storeId: 'store_101',
        status: OrderStatus.PACKING,
        items: [
          {
            id: 'item_baby_01',
            variantId: 'var_infant_formula',
            productName: 'Infant Nutrition Formula 400g',
            quantity: 1,
            totalPrice: 450,
            variant: {
              price: 450,
              product: {
                categoryId: 'cat_baby',
                category: { name: 'Baby Food & Infant Care', slug: 'baby-infant-care' },
              },
            },
          },
        ],
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);

      const result = await service.markItemMissing('ord_102', 'item_baby_01');

      expect(result.success).toBe(true);
      expect(result.isSensitiveCategory).toBe(true);
      expect(result.substitutes).toEqual([]);
      expect(mockEventsGateway.broadcastItemMissing).toHaveBeenCalledWith('ord_102', 'user_101', expect.anything(), []);
    });
  });

  describe('acceptSubstitute', () => {
    it('should atomically reserve substitute and refund difference if substitute is cheaper', async () => {
      const mockOrder = {
        id: 'ord_101',
        orderNumber: 'DB-10001',
        userId: 'user_101',
        storeId: 'store_101',
        status: OrderStatus.PACKING,
        subtotal: 100,
        totalAmount: 125,
        items: [
          {
            id: 'item_01',
            variantId: 'var_premium_milk',
            productName: 'Organic A2 Milk',
            quantity: 2,
            price: 50,
            totalPrice: 100,
          },
        ],
      };

      const mockSubstituteVariant = {
        id: 'var_regular_milk',
        price: 40,
        unitName: '500ml',
        product: { name: 'Standard Pasteurized Milk' },
        inventories: [{ storeId: 'store_101', stockQuantity: 20, reservedQuantity: 0 }],
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.productVariant.findUnique.mockResolvedValue(mockSubstituteVariant);
      mockPrismaService.orderItem.update.mockResolvedValue({
        id: 'item_01',
        productName: 'Standard Pasteurized Milk',
        price: 40,
        totalPrice: 80,
      });
      mockPrismaService.order.update.mockResolvedValue({
        ...mockOrder,
        subtotal: 80,
        totalAmount: 105,
      });

      const result = await service.acceptSubstitute('ord_101', 'item_01', 'var_regular_milk', 'user_101');

      expect(result.success).toBe(true);
      expect(result.refundCredited).toBe(20); // (100 - 80) = 20 refund
      expect(mockPrismaService.wallet.upsert).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { userId: 'user_101' },
          update: { balance: { increment: 20 } },
        }),
      );
      expect(mockEventsGateway.broadcastSubstituteAccepted).toHaveBeenCalled();
    });

    it('should absorb difference via Price Protection if substitute is more expensive', async () => {
      const mockOrder = {
        id: 'ord_101',
        orderNumber: 'DB-10001',
        userId: 'user_101',
        storeId: 'store_101',
        status: OrderStatus.PACKING,
        subtotal: 80,
        totalAmount: 105,
        items: [
          {
            id: 'item_01',
            variantId: 'var_regular_milk',
            productName: 'Standard Pasteurized Milk',
            quantity: 2,
            price: 40,
            totalPrice: 80,
          },
        ],
      };

      const mockSubstituteVariant = {
        id: 'var_premium_milk',
        price: 50,
        unitName: '500ml',
        product: { name: 'Organic A2 Milk' },
        inventories: [{ storeId: 'store_101', stockQuantity: 20, reservedQuantity: 0 }],
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.productVariant.findUnique.mockResolvedValue(mockSubstituteVariant);
      mockPrismaService.orderItem.update.mockResolvedValue({
        id: 'item_01',
        productName: 'Organic A2 Milk',
        price: 50,
        totalPrice: 80, // Customer pays old price 80!
      });

      const result = await service.acceptSubstitute('ord_101', 'item_01', 'var_premium_milk', 'user_101');

      expect(result.success).toBe(true);
      expect(result.refundCredited).toBe(0);
      expect(result.priceProtectionAbsorbed).toBe(20);
      expect(mockPrismaService.wallet.upsert).not.toHaveBeenCalled();
    });
  });

  describe('removeItemAndRefund', () => {
    it('should issue 100% wallet refund for item and update order totals', async () => {
      const mockOrder = {
        id: 'ord_101',
        orderNumber: 'DB-10001',
        userId: 'user_101',
        storeId: 'store_101',
        deliveryFee: 25,
        subtotal: 120,
        totalAmount: 145,
        status: OrderStatus.PACKING,
        items: [
          {
            id: 'item_01',
            variantId: 'var_01',
            productName: 'Tomatoes 500g',
            quantity: 1,
            totalPrice: 40,
          },
          {
            id: 'item_02',
            variantId: 'var_02',
            productName: 'Potatoes 1kg',
            quantity: 1,
            totalPrice: 80,
          },
        ],
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.order.update.mockResolvedValue({
        ...mockOrder,
        subtotal: 80,
        totalAmount: 105,
      });

      const result = await service.removeItemAndRefund('ord_101', 'item_01', 'user_101');

      expect(result.success).toBe(true);
      expect(result.refundedAmount).toBe(40);
      expect(mockPrismaService.wallet.upsert).toHaveBeenCalledWith(
        expect.objectContaining({
          where: { userId: 'user_101' },
          update: { balance: { increment: 40 } },
        }),
      );
      expect(mockPrismaService.orderItem.delete).toHaveBeenCalledWith({ where: { id: 'item_01' } });
      expect(mockEventsGateway.broadcastItemRemovedAndRefunded).toHaveBeenCalledWith('ord_101', 'user_101', 'item_01', 40);
    });

    it('should cancel entire order and refund delivery fee if all items are removed', async () => {
      const mockOrder = {
        id: 'ord_101',
        orderNumber: 'DB-10001',
        userId: 'user_101',
        storeId: 'store_101',
        deliveryFee: 25,
        subtotal: 40,
        totalAmount: 65,
        status: OrderStatus.PACKING,
        items: [
          {
            id: 'item_01',
            variantId: 'var_01',
            productName: 'Tomatoes 500g',
            quantity: 1,
            totalPrice: 40,
          },
        ],
      };

      mockPrismaService.order.findUnique.mockResolvedValue(mockOrder);
      mockPrismaService.order.update.mockResolvedValue({
        ...mockOrder,
        status: OrderStatus.CANCELLED,
        subtotal: 0,
        totalAmount: 0,
      });

      const result = await service.removeItemAndRefund('ord_101', 'item_01', 'user_101');

      expect(result.success).toBe(true);
      expect(result.refundedAmount).toBe(40);
      // Delivery fee of 25 refunded as well
      expect(mockPrismaService.wallet.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: { balance: { increment: 25 } },
        }),
      );
      expect(mockEventsGateway.broadcastOrderCancelled).toHaveBeenCalledWith(
        'ord_101',
        'user_101',
        'All items were out of stock',
      );
    });
  });
});
