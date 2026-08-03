import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class DeliveryPartnerService {
  constructor(private prisma: PrismaService) {}

  async getRiderDashboard(driverId: string = 'dr_101') {
    const activeOrder = {
      orderId: 'DB-892104',
      orderNumber: '#892104',
      pickupStore: 'Hub Store #01 Koramangala',
      pickupAddress: '#12 100 Feet Rd, Koramangala',
      customerName: 'Ananya Sharma',
      customerPhone: '+91 98765 12345',
      deliveryAddress: '#42 100 Feet Rd, 4th Block, Koramangala',
      itemsCount: 3,
      earnings: 45,
      distanceKm: 1.8,
      status: 'OUT_FOR_DELIVERY',
      otpRequired: '4821',
    };

    return {
      driverId,
      isOnline: true,
      todayEarnings: 850,
      completedDeliveries: 18,
      incentives: 150,
      activeOrder,
    };
  }

  async toggleDutyStatus(driverId: string, isOnline: boolean) {
    return {
      success: true,
      driverId,
      isOnline,
      message: isOnline ? 'Driver is now ONLINE and receiving delivery orders.' : 'Driver is now OFFLINE.',
    };
  }

  async completeOrder(orderId: string, otp: string) {
    if (otp !== '4821') {
      throw new BadRequestException('Invalid delivery confirmation OTP.');
    }

    await this.prisma.order.update({
      where: { id: orderId },
      data: { status: 'DELIVERED' },
    });

    return {
      success: true,
      orderId,
      status: 'DELIVERED',
      earningsAdded: 45,
      message: 'Order marked DELIVERED successfully! ₹45 credited to rider wallet.',
    };
  }
}
