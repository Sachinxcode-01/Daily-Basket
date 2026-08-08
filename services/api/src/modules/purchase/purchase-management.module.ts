import { Module } from '@nestjs/common';
import { PurchaseManagementService } from './purchase-management.service';
import { PurchaseManagementController } from './purchase-management.controller';
import { PrismaModule } from '../../database/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [PurchaseManagementService],
  controllers: [PurchaseManagementController],
  exports: [PurchaseManagementService],
})
export class PurchaseManagementModule {}
