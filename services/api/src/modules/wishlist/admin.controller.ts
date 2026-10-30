import { Controller, Get, Post, Delete, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { WishlistService } from './wishlist.service';

@ApiTags('Wishlist (Admin)')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('admin/wishlists')
export class AdminWishlistController {
  constructor(private readonly wishlistService: WishlistService) {}

  @Delete(':id')
  @ApiOperation({ summary: 'Admin force remove a wishlist entry' })
  async adminRemove(@Param('id') id: string) {
    return this.wishlistService.removeFromWishlist(id, undefined);
  }
}
