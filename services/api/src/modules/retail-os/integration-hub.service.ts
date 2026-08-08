import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class IntegrationHubService {
  constructor(private readonly prisma: PrismaService) {}

  async listConnections() {
    const connections = await this.prisma.integrationConnection.findMany({
      orderBy: { providerName: 'asc' },
    });

    if (connections.length === 0) {
      return [
        {
          id: 'int_01',
          providerName: 'RAZORPAY',
          category: 'PAYMENT',
          status: 'CONNECTED',
          apiEndpoint: 'https://api.razorpay.com/v1',
          lastSyncAt: new Date(),
        },
        {
          id: 'int_02',
          providerName: 'GOOGLE_MAPS',
          category: 'MAPS',
          status: 'CONNECTED',
          apiEndpoint: 'https://maps.googleapis.com/maps/api',
          lastSyncAt: new Date(),
        },
        {
          id: 'int_03',
          providerName: 'WHATSAPP_BUSINESS',
          category: 'COMMUNICATIONS',
          status: 'CONNECTED',
          apiEndpoint: 'https://graph.facebook.com/v17.0',
          lastSyncAt: new Date(),
        },
        {
          id: 'int_04',
          providerName: 'CLOUDINARY',
          category: 'STORAGE',
          status: 'CONNECTED',
          apiEndpoint: 'https://api.cloudinary.com/v1_1',
          lastSyncAt: new Date(),
        },
        {
          id: 'int_05',
          providerName: 'POS_GATEWAY',
          category: 'POS',
          status: 'CONNECTED',
          apiEndpoint: 'http://localhost:3000/api/v1/retail-os/pos',
          lastSyncAt: new Date(),
        },
      ];
    }
    return connections;
  }
}
