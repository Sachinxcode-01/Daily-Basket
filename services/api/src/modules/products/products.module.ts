import { Module } from '@nestjs/common';
import { ProductsService } from './products.service';
import { ProductsController } from './products.controller';
import { PrismaService } from '../../database/prisma.service';
import { BlinkitMigrationService } from './blinkit-migration.service';

@Module({
  controllers: [ProductsController],
  providers: [ProductsService, PrismaService, BlinkitMigrationService],
  exports: [ProductsService, BlinkitMigrationService],
})
export class ProductsModule {}

