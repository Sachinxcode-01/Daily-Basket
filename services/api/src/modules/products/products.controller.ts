import { Controller, Get, Post, Put, Patch, Delete, Param, Query, Body } from '@nestjs/common';
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

  @Post()
  @ApiOperation({ summary: 'Create a new product with variant and initial inventory' })
  async createProduct(@Body() body: any) {
    const product = await this.productsService.create(body);
    this.eventsGateway.server?.emit('product_created', product);
    return product;
  }

  @Get('recommendations')
  @ApiOperation({ summary: 'Get smart recommendations (similar, frequently_bought_together, customers_also_viewed, best_sellers, popular, cart_addons)' })
  @ApiQuery({ name: 'type', required: false })
  @ApiQuery({ name: 'productId', required: false })
  @ApiQuery({ name: 'categoryId', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getRecommendations(
    @Query('type') type?: string,
    @Query('productId') productId?: string,
    @Query('categoryId') categoryId?: string,
    @Query('limit') limit?: number,
  ) {
    return this.productsService.getRecommendations(type, productId, categoryId, limit);
  }

  @Get('substitutes')
  @ApiOperation({ summary: 'Get smart 1:1 substitutes for an out-of-stock product' })
  @ApiQuery({ name: 'productId', required: true })
  async getSubstitutes(@Query('productId') productId: string) {
    return this.productsService.getSubstitutes(productId);
  }

  @Get('audit-catalog')
  @ApiOperation({ summary: 'Catalog Quality & Integrity Audit (broken images, duplicate SKUs, price anomalies)' })
  async auditCatalog() {
    return this.productsService.auditEntireCatalog();
  }

  @Post('auto-fix-catalog')
  @ApiOperation({ summary: 'Admin Action: Auto-fix catalog quality issues (assign fallback images, fix prices)' })
  async autoFixCatalog() {
    return this.productsService.autoFixCatalog();
  }

  @Get(':id/substitutes')
  @ApiOperation({ summary: 'Get smart 1:1 substitutes for a specific product' })
  async getProductSubstitutes(@Param('id') id: string) {
    return this.productsService.getSubstitutes(id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get single product details with variants' })
  async findOne(@Param('id') id: string) {
    return this.productsService.findOne(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update an existing product and its variant/inventory pricing' })
  async updateProduct(@Param('id') id: string, @Body() body: any) {
    const updated = await this.productsService.update(id, body);
    this.eventsGateway.server?.emit('product_updated', updated);
    return updated;
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Partially update product details' })
  async patchProduct(@Param('id') id: string, @Body() body: any) {
    const updated = await this.productsService.update(id, body);
    this.eventsGateway.server?.emit('product_updated', updated);
    return updated;
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a single product and associated variants/inventories' })
  async deleteProduct(@Param('id') id: string) {
    const result = await this.productsService.delete(id);
    this.eventsGateway.server?.emit('product_deleted', { id });
    return result;
  }

  @Post(':id/toggle-status')
  @ApiOperation({ summary: 'Admin toggle product availability (broadcasts real-time WebSockets to apps)' })
  async toggleProductStatus(@Param('id') id: string, @Body() body: { isAvailable: boolean }) {
    await this.productsService.toggleProductStatus(id, body.isAvailable);
    this.eventsGateway.broadcastProductStatus(id, body.isAvailable);
    return { id, isAvailable: body.isAvailable, status: 'BROADCASTED' };
  }

  @Post(':id/update-stock')
  @ApiOperation({ summary: 'Admin update product stock quantity (broadcasts real-time WebSockets to apps)' })
  async updateProductStock(@Param('id') id: string, @Body() body: { newStock: number }) {
    const result = await this.productsService.updateStock(id, body.newStock);
    this.eventsGateway.broadcastInventoryUpdate(id, body.newStock, result.isAvailable);
    return { id, newStock: body.newStock, isAvailable: result.isAvailable, status: 'BROADCASTED' };
  }
}


