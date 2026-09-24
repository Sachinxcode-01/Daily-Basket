import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { CartService, AddToCartDto } from './cart.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';

@ApiTags('Shopping Cart')
@ApiBearerAuth()
@UseGuards(OptionalJwtAuthGuard)
@Controller('cart')
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Get active persistent cart (user derived from token; guest otherwise)' })
  async getCart(@ResolvedUserId() userId: string) {
    return this.cartService.getCart(userId);
  }

  @Post('add')
  @ApiOperation({ summary: 'Add item to persistent cart with stock and max limit check' })
  async addItem(@ResolvedUserId() userId: string, @Body() body: AddToCartDto) {
    return this.cartService.addItem(userId, body);
  }

  @Patch('item/:id')
  @ApiOperation({ summary: 'Update cart item quantity' })
  async updateQuantity(
    @ResolvedUserId() userId: string,
    @Param('id') itemId: string,
    @Body() body: { quantity: number },
  ) {
    return this.cartService.updateQuantity(userId, itemId, body.quantity);
  }

  @Delete('item/:id')
  @ApiOperation({ summary: 'Remove item from cart' })
  async removeItem(@ResolvedUserId() userId: string, @Param('id') itemId: string) {
    return this.cartService.removeItem(userId, itemId);
  }

  @Post('save-for-later/:id')
  @ApiOperation({ summary: 'Toggle save for later vs active cart item' })
  async saveForLater(
    @ResolvedUserId() userId: string,
    @Param('id') itemId: string,
    @Body() body: { isSavedForLater: boolean },
  ) {
    return this.cartService.toggleSaveForLater(userId, itemId, body.isSavedForLater);
  }

  @Post('merge')
  @ApiOperation({ summary: 'Merge guest cart items into authenticated user cart' })
  async mergeGuestCart(@ResolvedUserId() userId: string, @Body() body: { items: AddToCartDto[] }) {
    return this.cartService.mergeGuestCart(userId, body.items);
  }

  @Delete('clear')
  @ApiOperation({ summary: 'Clear active cart items' })
  async clearCart(@ResolvedUserId() userId: string) {
    return this.cartService.clearCart(userId);
  }
}
