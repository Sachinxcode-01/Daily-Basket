import { Controller, Get, Post, Delete, Param, Query, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { WishlistService } from './wishlist.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';

@ApiTags('Wishlist')
@ApiBearerAuth()
@UseGuards(OptionalJwtAuthGuard)
@Controller('wishlist')
export class WishlistController {
  constructor(private readonly wishlistService: WishlistService) {}

  @Get()
  @ApiOperation({ summary: 'Get user wishlist products' })
  async getWishlist(@Query('page') page?: number, @Query('limit') limit?: number) {
    return this.wishlistService.getWishlist(page, limit);
  }

  @Post()
  @ApiOperation({ summary: 'Add a product to wishlist' })
  async addWishlist(@ResolvedUserId() userId: string, @Body() body: { productId: string }) {
    return this.wishlistService.addToWishlist(userId, body.productId);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Remove a product from wishlist' })
  async removeWishlist(@Param('id') id: string, @Body() body: { userId?: string }) {
    return this.wishlistService.removeFromWishlist(id, body.userId);
  }
}
