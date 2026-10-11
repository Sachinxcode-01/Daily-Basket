import { Global, Module } from '@nestjs/common';
import { DeliveryService } from './delivery.service';
import { DeliveryController } from './delivery.controller';
import { PrismaService } from '../../database/prisma.service';
import { GeofenceService } from './geofence.service';
import { TimedDispatchService } from './timed-dispatch.service';
import { EventsModule } from '../events/events.module';

@Global()
@Module({
  imports: [EventsModule],
  controllers: [DeliveryController],
  providers: [DeliveryService, PrismaService, GeofenceService, TimedDispatchService],
  exports: [DeliveryService, GeofenceService, TimedDispatchService],
})
export class DeliveryModule {}

