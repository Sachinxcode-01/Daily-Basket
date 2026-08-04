import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class DeliveryService {
  constructor(private prisma: PrismaService) {}

  async getOrderTracking(orderId: string) {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: true,
        address: true,
        deliveryPartner: true,
      },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    // Simulated 10-minute delivery driver location telemetry
    const simulatedLocations = [
      { step: 'PACKING', lat: 12.9352, lng: 77.6245, etaMins: 10, note: 'Packing at Hub Store #01' },
      { step: 'OUT_FOR_DELIVERY', lat: 12.937, lng: 77.621, etaMins: 6, note: 'Rider on the way via 100 Feet Rd' },
      { step: 'DELIVERED', lat: 12.939, lng: 77.618, etaMins: 0, note: 'Delivered at customer doorstep' },
    ];

    const driverDetails = {
      name: 'Ramesh Kumar',
      phone: '+91 98765 00112',
      vehicleNumber: 'KA 01 EB 4821',
      rating: 4.9,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
    };

    return {
      orderId: order.id,
      orderNumber: order.orderNumber,
      status: order.status,
      estimatedArrivalMins: order.estimatedArrivalMins,
      driver: driverDetails,
      currentLocation: simulatedLocations[1],
      deliveryAddress: order.address,
      itemsSummary: order.items.map((i) => `${i.quantity}x ${i.productName}`).join(', '),
    };
  }

  async updateDeliveryStatus(orderId: string, status: any) {
    const order = await this.prisma.order.update({
      where: { id: orderId },
      data: { status },
    });

    return {
      success: true,
      orderId: order.id,
      newStatus: order.status,
    };
  }

  async checkLocation(lat?: number, lng?: number, addressText?: string) {
    // Check dark store availability & SLA for latitude/longitude
    return {
      serviceable: true,
      darkStore: {
        id: 'ds_koramangala_01',
        name: 'Daily Basket Hub — Koramangala 4th Block',
        distanceKm: 0.8,
        estimatedDeliveryMins: 10,
        isOpen: true,
      },
      userLocation: {
        lat: lat || 12.9352,
        lng: lng || 77.6245,
        address: addressText || 'Koramangala, Bengaluru, Karnataka 560034',
      },
      featuresAvailable: [
        '10-Minute Express Delivery',
        'Live GPS Tracking',
        'Pay on Delivery / UPI / Card',
        'Free Shipping on orders above ₹199',
      ],
    };
  }
}

