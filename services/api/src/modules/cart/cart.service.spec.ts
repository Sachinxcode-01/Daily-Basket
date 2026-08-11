import { Test, TestingModule } from '@nestjs/testing';
import { CartService } from './cart.service';
import { PrismaService } from '../../database/prisma.service';
import { EventsGateway } from '../events/events.gateway';

describe('CartService Unit & Calculation Tests', () => {
  let service: CartService;

  const mockPrismaService = {
    cart: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    cartItem: {
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      deleteMany: jest.fn(),
    },
  };

  const mockEventsGateway = {
    server: {
      to: jest.fn().mockReturnThis(),
      emit: jest.fn(),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CartService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: EventsGateway, useValue: mockEventsGateway },
      ],
    }).compile();

    service = module.get<CartService>(CartService);
  });

  describe('getCart', () => {
    it('should calculate cart totals accurately (item total, delivery fee, GST, grand total)', async () => {
      mockPrismaService.cart.findUnique.mockResolvedValue({
        id: 'cart_101',
        userId: 'user_101',
        items: [
          { id: 'item_1', variantId: 'var_1', productName: 'Milk 1L', unitName: '1L', price: 54, quantity: 2, isSavedForLater: false },
          { id: 'item_2', variantId: 'var_2', productName: 'Bread', unitName: '400g', price: 45, quantity: 1, isSavedForLater: false },
        ],
      });

      const cart = await service.getCart('user_101');

      expect(cart.summary.itemTotal).toBe(153); // 54*2 + 45 = 153
      expect(cart.summary.deliveryFee).toBe(0); // Free delivery >= 149
      expect(cart.summary.platformFee).toBe(5);
      expect(cart.summary.packagingCharges).toBe(10);
      expect(cart.summary.grandTotal).toBeGreaterThan(153);
    });
  });

  describe('addItem', () => {
    it('should enforce max 10 purchase limit per item', async () => {
      mockPrismaService.cart.findUnique.mockResolvedValue({ id: 'cart_101' });
      mockPrismaService.cartItem.findFirst.mockResolvedValue({ id: 'item_1', quantity: 9 });

      await expect(
        service.addItem('user_101', {
          variantId: 'var_1',
          productName: 'Milk 1L',
          unitName: '1L',
          price: 54,
          quantity: 2,
        }),
      ).rejects.toThrow('Maximum purchase limit per item is 10 units.');
    });
  });
});
