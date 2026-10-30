import { Module } from '@nestjs/common';
import { AdminWishlistController } from './admin.controller';
import { WishlistService } from './wishlist.service';

@Module({
  controllers: [AdminWishlistController],
  providers: [WishlistService],
})
export class AdminWishlistModule {}
