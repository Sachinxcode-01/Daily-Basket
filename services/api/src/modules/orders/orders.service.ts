import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';
import { QueueProcessor } from '../queue/queue.processor';
import { OrderStatus } from '@prisma/client';

import { OrderPricingService } from './order-pricing.service';

@Injectable()
export class OrdersService {
  private readonly logger = new Logger(OrdersService.name);

  constructor(
    private prisma: PrismaService,
    private redisService: RedisService,
    private eventsGateway: EventsGateway,
    private queueProcessor: QueueProcessor,
    private orderPricingService: OrderPricingService,
  ) {}

  async createOrder(
    userId: string,
    data: {
      addressId: string;
      paymentMethod: any;
      items: any[];
      couponCode?: string;
      useWallet?: boolean;
    },
  ) {
    const lockResource = `inventory_user_${userId}`;
    const lockToken = await this.redisService.acquireLock(lockResource, 5);

    try {
      const orderNumber = `DB-${Date.now().toString().slice(-6)}`;
      const pricing = this.orderPricingService.calculatePricing({
        items: data.items.map((i) => ({
          id: i.variantId || i.id || 'prod_01',
          productName: i.productName || i.name || 'Item',
          price: i.price,
          quantity: i.quantity || i.qty || 1,
        })),
        couponCode: data.couponCode,
        useWallet: data.useWallet,
        paymentMethod: typeof data.paymentMethod === 'string' ? data.paymentMethod : data.paymentMethod?.id,
      });

      const subtotal = pricing.subtotal;
      const deliveryFee = pricing.deliveryFee;
      const discount = pricing.couponDiscount + pricing.itemDiscounts;
      const totalAmount = pricing.finalPayable;
      const paymentMethod = pricing.selectedPaymentMethod;
      const deliveryOtp = Math.floor(100000 + Math.random() * 900000).toString();

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
          status: OrderStatus.CONFIRMED,
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

      // Automated BullMQ Async Processing
      await this.queueProcessor.enqueueJob('ORDER', order);
      await this.queueProcessor.enqueueJob('NOTIFICATION', {
        userId,
        title: 'Order Confirmed! 🛒',
        body: `Your order ${orderNumber} for ₹${totalAmount} has been placed. Packing now!`,
        data: { orderId: order.id, deliveryOtp },
      });

      // Realtime Socket.IO Broadcasts
      this.eventsGateway.broadcastOrderCreated(order);
      this.eventsGateway.broadcastOrderPacking(order);

      return { ...order, deliveryOtp };
    } finally {
      if (lockToken) {
        await this.redisService.releaseLock(lockResource, lockToken);
      }
    }
  }

  async assignDeliveryPartner(orderId: string, riderId: string, riderDetails: any) {
    const order = await this.prisma.order.update({
      where: { id: orderId },
      data: { status: OrderStatus.READY_FOR_PICKUP, deliveryPartnerId: riderId },
      include: { items: true, address: true },
    });

    this.eventsGateway.broadcastRiderAssigned(orderId, order.userId, riderId, riderDetails);
    await this.queueProcessor.enqueueJob('NOTIFICATION', {
      userId: order.userId,
      title: 'Delivery Partner Assigned 🛵',
      body: `${riderDetails.name || 'Rider'} is on the way to pick up your order!`,
      data: { orderId, riderId },
    });

    return order;
  }

  async startDelivery(orderId: string) {
    const order = await this.prisma.order.update({
      where: { id: orderId },
      data: { status: OrderStatus.OUT_FOR_DELIVERY },
    });

    this.eventsGateway.broadcastLiveLocation(orderId, order.deliveryPartnerId || 'rider_01', 12.9716, 77.5946);
    return order;
  }

  async completeDelivery(orderId: string, otpCode?: string) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: { items: true, address: true },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    const updatedOrder = await this.prisma.order.update({
      where: { id: orderId },
      data: { status: OrderStatus.DELIVERED },
    });

    const invoice = {
      invoiceNumber: `INV-${Date.now().toString().slice(-8)}`,
      gstin: '29AABCD1234E1Z5',
      cgst: +(order.totalAmount * 0.025).toFixed(2),
      sgst: +(order.totalAmount * 0.025).toFixed(2),
      totalPaid: order.totalAmount,
      generatedAt: new Date().toISOString(),
    };

    // Automated Post-Delivery Ledger & Reward Processing
    await this.queueProcessor.enqueueJob('ANALYTICS', { event: 'ORDER_DELIVERED', orderId, revenue: order.totalAmount });
    await this.queueProcessor.enqueueJob('NOTIFICATION', {
      userId: order.userId,
      title: 'Order Delivered! 🎉',
      body: `Order ${order.orderNumber} delivered successfully. Invoice ${invoice.invoiceNumber} attached.`,
      data: { orderId, invoice },
    });

    this.eventsGateway.broadcastOrderDelivered(orderId, order.userId, invoice);
    return { order: updatedOrder, invoice };
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
