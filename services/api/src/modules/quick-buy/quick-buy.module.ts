import { Module } from '@nestjs/common';
import { QuickBuyController } from './quick-buy.controller';
import { QuickBuyService } from './quick-buy.service';
import { PrismaService } from '../../database/prisma.service';

@Module({
  controllers: [QuickBuyController],
  providers: [QuickBuyService, PrismaService],
  exports: [QuickBuyService],
})
export class QuickBuyModule {}
