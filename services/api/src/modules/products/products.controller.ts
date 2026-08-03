import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { ProductsService } from './products.service';

@ApiTags('Products & Home Feed')
@Controller('products')
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Get('home-feed')
  @ApiOperation({ summary: 'Get complete aggregated Home Feed data (banners, flash deals, categories)' })
  async getHomeFeed() {
    return this.productsService.getHomeFeed();
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
}
