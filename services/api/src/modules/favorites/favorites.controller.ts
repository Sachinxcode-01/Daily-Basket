import { Controller, Get, Post, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBody } from '@nestjs/swagger';
import { FavoritesService } from './favorites.service';

@ApiTags('Favorites & Wishlist')
@Controller(['favorites', 'wishlist'])
export class FavoritesController {
  constructor(private readonly favoritesService: FavoritesService) {}

  @Get('count')
  @ApiOperation({ summary: 'Get total wishlist/favorite count for user' })
  @ApiQuery({ name: 'userId', required: false })
  async getFavoritesCount(@Query('userId') userId?: string) {
    const count = await this.favoritesService.getFavoritesCount(userId);
    return { count };
  }

  @Post('sync')
  @ApiOperation({ summary: 'Batch sync guest wishlist/favorites to authenticated user account' })
  @ApiQuery({ name: 'userId', required: false })
  @ApiBody({ schema: { type: 'object', properties: { productIds: { type: 'array', items: { type: 'string' } } } } })
  async syncGuestWishlist(
    @Query('userId') userId: string,
    @Body('productIds') productIds: string[],
  ) {
    return this.favoritesService.syncGuestWishlist(userId, productIds);
  }

  @Post(':productId/move-to-cart')
  @ApiOperation({ summary: 'Atomically move product from wishlist/favorites into cart' })
  @ApiQuery({ name: 'userId', required: false })
  async moveToCart(
    @Query('userId') userId: string,
    @Param('productId') productId: string,
  ) {
    return this.favoritesService.moveToCart(userId, productId);
  }

  @Get()
  @ApiOperation({ summary: 'Get user favorite/wishlist products with search, category filter, and sorting' })
  @ApiQuery({ name: 'userId', required: false })
  @ApiQuery({ name: 'query', required: false })
  @ApiQuery({ name: 'categoryId', required: false })
  @ApiQuery({ name: 'sort', required: false, enum: ['recently_added', 'price_low_high', 'price_high_low', 'alphabetical', 'best_selling'] })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getFavorites(
    @Query('userId') userId?: string,
    @Query('query') query?: string,
    @Query('categoryId') categoryId?: string,
    @Query('sort') sort?: any,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.favoritesService.getFavorites({ userId, query, categoryId, sort, page: Number(page) || 1, limit: Number(limit) || 20 });
  }

  @Get('search')
  @ApiOperation({ summary: 'Search within user favorites' })
  @ApiQuery({ name: 'userId', required: false })
  @ApiQuery({ name: 'q', required: true })
  async searchFavorites(@Query('userId') userId: string, @Query('q') q: string) {
    return this.favoritesService.getFavorites({ userId, query: q });
  }

  @Get('category/:id')
  @ApiOperation({ summary: 'Filter user favorites by category ID' })
  @ApiQuery({ name: 'userId', required: false })
  async getFavoritesByCategory(@Query('userId') userId: string, @Param('id') categoryId: string) {
    return this.favoritesService.getFavorites({ userId, categoryId });
  }

  @Get('discounted')
  @ApiOperation({ summary: 'Get favorited products currently on discount' })
  @ApiQuery({ name: 'userId', required: false })
  async getDiscountedFavorites(@Query('userId') userId?: string) {
    return this.favoritesService.getDiscountedFavorites(userId);
  }

  @Get('analytics')
  @ApiOperation({ summary: 'Admin analytics for favorite trends and conversion rates' })
  async getFavoritesAnalytics() {
    return this.favoritesService.getFavoritesAnalytics();
  }

  @Get(':productId/check')
  @ApiOperation({ summary: 'Check if a specific product is favorited by user' })
  @ApiQuery({ name: 'userId', required: false })
  async checkIsFavorite(@Query('userId') userId: string, @Param('productId') productId: string) {
    const isFavorite = await this.favoritesService.checkIsFavorite(userId, productId);
    return { productId, isFavorite };
  }

  @Post(':productId')
  @ApiOperation({ summary: 'Add a product to user favorites' })
  @ApiQuery({ name: 'userId', required: false })
  async addFavorite(@Query('userId') userId: string, @Param('productId') productId: string) {
    return this.favoritesService.addFavorite(userId, productId);
  }

  @Delete(':productId')
  @ApiOperation({ summary: 'Remove a product from user favorites' })
  @ApiQuery({ name: 'userId', required: false })
  async removeFavorite(@Query('userId') userId: string, @Param('productId') productId: string) {
    return this.favoritesService.removeFavorite(userId, productId);
  }

  @Delete()
  @ApiOperation({ summary: 'Clear all favorites for a user' })
  @ApiQuery({ name: 'userId', required: false })
  async clearFavorites(@Query('userId') userId?: string) {
    return this.favoritesService.clearFavorites(userId);
  }
}
