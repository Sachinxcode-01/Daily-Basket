import { Controller, Get, Post, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { ProductsService } from './products.service';
import { BlinkitMigrationService } from './blinkit-migration.service';
import { EventsGateway } from '../events/events.gateway';

@ApiTags('Products & Home Feed')
@Controller('products')
export class ProductsController {
  constructor(
    private readonly productsService: ProductsService,
    private readonly blinkitMigrationService: BlinkitMigrationService,
    private readonly eventsGateway: EventsGateway,
  ) {}

  @Get('home-feed')
  @ApiOperation({ summary: 'Get complete aggregated Home Feed data (banners, flash deals, categories)' })
  async getHomeFeed() {
    return this.productsService.getHomeFeed();
  }

  @Post('delete-all')
  @ApiOperation({ summary: 'Admin Clean Wipe: Delete all catalog products, variants, and stock inventories' })
  async deleteAllProducts() {
    const result = await this.blinkitMigrationService.deleteAllProducts();
    this.eventsGateway.server?.emit('catalog_reset', { timestamp: new Date().toISOString() });
    return result;
  }

  @Post('run-blinkit-migration')
  @ApiOperation({ summary: 'Admin Trigger: Run Blinkit product migration and data enrichment pipeline' })
  async runBlinkitMigration() {
    const report = await this.blinkitMigrationService.runMigration();
    this.eventsGateway.server?.emit('catalog_migrated', report);
    return report;
  }

  @Get()
  @ApiOperation({ summary: 'Get product catalog with optional category and search query filters' })
  @ApiQuery({ name: 'categoryId', required: false })
  @ApiQuery({ name: 'query', required: false })
  async findAll(@Query('categoryId') categoryId?: string, @Query('query') query?: string) {
    return this.productsService.findAll(categoryId, query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get single product details with variants' })
  async findOne(@Param('id') id: string) {
    return this.productsService.findOne(id);
  }

  @Post(':id/toggle-status')
  @ApiOperation({ summary: 'Admin toggle product availability (broadcasts real-time WebSockets to apps)' })
  async toggleProductStatus(@Param('id') id: string, @Body() body: { isAvailable: boolean }) {
    this.eventsGateway.broadcastProductStatus(id, body.isAvailable);
    return { id, isAvailable: body.isAvailable, status: 'BROADCASTED' };
  }

  @Post(':id/update-stock')
  @ApiOperation({ summary: 'Admin update product stock quantity (broadcasts real-time WebSockets to apps)' })
  async updateProductStock(@Param('id') id: string, @Body() body: { newStock: number }) {
    const isAvailable = body.newStock > 0;
    this.eventsGateway.broadcastInventoryUpdate(id, body.newStock, isAvailable);
    return { id, newStock: body.newStock, isAvailable, status: 'BROADCASTED' };
  }
}

