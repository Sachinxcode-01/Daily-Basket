import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Query,
  Body,
  ParseIntPipe,
  DefaultValuePipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { CategoriesService } from './categories.service';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  @ApiOperation({ summary: 'Get active grocery taxonomy categories' })
  @ApiQuery({ name: 'featured', required: false, type: Boolean })
  async findAll(@Query('featured') featured?: string) {
    const featuredOnly = featured === 'true';
    return this.categoriesService.findAll(featuredOnly);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get category by ID or slug' })
  async findOne(@Param('id') idOrSlug: string) {
    return this.categoriesService.findOne(idOrSlug);
  }

  @Get(':id/subcategories')
  @ApiOperation({ summary: 'Get subcategories for a parent category' })
  async getSubcategories(@Param('id') parentId: string) {
    return this.categoriesService.getSubcategories(parentId);
  }

  @Get(':id/products')
  @ApiOperation({ summary: 'Get products in category with subcategory filtering & search' })
  @ApiQuery({ name: 'q', required: false })
  @ApiQuery({ name: 'subcategoryId', required: false })
  @ApiQuery({ name: 'sort', required: false })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  async getCategoryProducts(
    @Param('id') idOrSlug: string,
    @Query('q') query?: string,
    @Query('subcategoryId') subcategoryId?: string,
    @Query('sort') sort = 'popular',
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page = 1,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit = 20,
  ) {
    return this.categoriesService.getCategoryProducts(
      idOrSlug,
      query,
      subcategoryId,
      sort,
      page,
      limit,
    );
  }

  @Post()
  @ApiOperation({ summary: 'Admin create a category or subcategory' })
  async createCategory(@Body() dto: any) {
    return this.categoriesService.createCategory(dto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Admin update category details or banner/icon' })
  async updateCategory(@Param('id') id: string, @Body() dto: any) {
    return this.categoriesService.updateCategory(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Admin delete category' })
  async deleteCategory(@Param('id') id: string) {
    return this.categoriesService.deleteCategory(id);
  }

  @Patch('batch/reorder')
  @ApiOperation({ summary: 'Admin reorder category list' })
  async reorderCategories(@Body() body: { items: { id: string; sortOrder: number }[] }) {
    return this.categoriesService.reorderCategories(body.items || []);
  }
}
