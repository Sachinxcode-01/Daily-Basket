import { Global, Module } from '@nestjs/common';
import { DeliveryService } from './delivery.service';
import { DeliveryController } from './delivery.controller';
import { PrismaService } from '../../database/prisma.service';
import { GeofenceService } from './geofence.service';

@Global()
@Module({
  controllers: [DeliveryController],
  providers: [DeliveryService, PrismaService, GeofenceService],
  exports: [DeliveryService, GeofenceService],
})
export class DeliveryModule {}
