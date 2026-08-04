import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class OrdersService {
  private readonly logger = new Logger(OrdersService.name);

  constructor(
    private prisma: PrismaService,
    private redisService: RedisService,
  ) {}

  async createOrder(userId: string, data: { addressId: string; paymentMethod: any; items: any[] }) {
    const lockResource = `inventory_user_${userId}`;
    const lockToken = await this.redisService.acquireLock(lockResource, 5);

    try {
      const orderNumber = `DB-${Date.now().toString().slice(-6)}`;
      const subtotal = data.items.reduce((acc, item) => acc + item.price * item.quantity, 0);
      const deliveryFee = subtotal >= 199 ? 0 : 25;
      const totalAmount = subtotal + deliveryFee;

      const order = await this.prisma.order.create({
        data: {
          orderNumber,
          storeId: 'store_main_01',
          userId,
          addressId: data.addressId,
          subtotal,
          deliveryFee,
          discount: 0,
          totalAmount,
          paymentMethod: data.paymentMethod,
          status: 'CONFIRMED',
          estimatedArrivalMins: 10,
          items: {
            create: data.items.map((item) => ({
              variantId: item.variantId,
              productName: item.productName,
              unitName: item.unitName,
              price: item.price,
              quantity: item.quantity,
              totalPrice: item.price * item.quantity,
            })),
          },
        },
        include: {
          items: true,
          address: true,
        },
      });

      // Enqueue order for async processing in Redis Order Worker
      await this.redisService.enqueueOrderProcessing({
        jobId: `job_${order.id}`,
        orderId: order.id,
        userId,
        timestamp: Date.now(),
        payload: {
          totalAmount,
          itemCount: data.items.length,
        },
      });

      return order;
    } finally {
      if (lockToken) {
        await this.redisService.releaseLock(lockResource, lockToken);
      }
    }
  }

  async getOrderTracking(orderId: string) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: { items: true, address: true, deliveryPartner: true },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    const queueMetrics = await this.redisService.getQueueMetrics();

    return {
      order,
      stepStatus: order.status,
      driverLocation: { lat: 12.9716, lng: 77.5946 },
      estimatedEtaMins: order.estimatedArrivalMins,
      queueMetrics,
    };
  }
}
