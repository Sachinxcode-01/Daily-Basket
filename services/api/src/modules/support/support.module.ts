import { Module } from '@nestjs/common';
import { SupportController } from './support.controller';
import { SupportService } from './support.service';
import { SupportGateway } from './support.gateway';
import { PrismaService } from '../../database/prisma.service';

@Module({
  controllers: [SupportController],
  providers: [SupportService, SupportGateway, PrismaService],
  exports: [SupportService, SupportGateway],
})
export class SupportModule {}
