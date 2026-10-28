import { Module } from '@nestjs/common';
import { ProductsService } from './products.service';
import { ProductsController } from './products.controller';
import { PrismaService } from '../../database/prisma.service';
import { BlinkitMigrationService } from './blinkit-migration.service';
import { ProductValidatorService } from './product-validator.service';

@Module({
  controllers: [ProductsController],
  providers: [ProductsService, PrismaService, BlinkitMigrationService, ProductValidatorService],
  exports: [ProductsService, BlinkitMigrationService, ProductValidatorService],
})
export class ProductsModule {}

