import { Module } from '@nestjs/common';
import { DeliveryPartnerService } from './delivery-partner.service';
import { DeliveryPartnerController } from './delivery-partner.controller';
import { PrismaService } from '../../database/prisma.service';

@Module({
  controllers: [DeliveryPartnerController],
  providers: [DeliveryPartnerService, PrismaService],
  exports: [DeliveryPartnerService],
})
export class DeliveryPartnerModule {}
