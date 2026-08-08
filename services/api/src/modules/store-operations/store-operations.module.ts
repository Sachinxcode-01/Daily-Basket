import { Module } from '@nestjs/common';
import { StoreOperationsService } from './store-operations.service';
import { StoreOperationsController } from './store-operations.controller';
import { PrismaModule } from '../../database/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [StoreOperationsService],
  controllers: [StoreOperationsController],
  exports: [StoreOperationsService],
})
export class StoreOperationsModule {}
