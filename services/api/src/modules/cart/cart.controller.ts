import { Controller, Get, Post, Patch, Delete, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { CartService, AddToCartDto } from './cart.service';

@ApiTags('Shopping Cart')
@Controller('cart')
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Get active persistent user cart with backend-validated totals' })
  async getCart(@Query('userId') userId = 'usr_default') {
    return this.cartService.getCart(userId);
  }

  @Post('add')
  @ApiOperation({ summary: 'Add item to persistent cart with stock and max limit check' })
  async addItem(@Body() body: AddToCartDto & { userId?: string }) {
    const userId = body.userId || 'usr_default';
    return this.cartService.addItem(userId, body);
  }

  @Patch('item/:id')
  @ApiOperation({ summary: 'Update cart item quantity' })
  async updateQuantity(
    @Param('id') itemId: string,
    @Body() body: { quantity: number; userId?: string },
  ) {
    const userId = body.userId || 'usr_default';
    return this.cartService.updateQuantity(userId, itemId, body.quantity);
  }

  @Delete('item/:id')
  @ApiOperation({ summary: 'Remove item from cart' })
  async removeItem(@Param('id') itemId: string, @Query('userId') userId = 'usr_default') {
    return this.cartService.removeItem(userId, itemId);
  }

  @Post('save-for-later/:id')
  @ApiOperation({ summary: 'Toggle save for later vs active cart item' })
  async saveForLater(
    @Param('id') itemId: string,
    @Body() body: { isSavedForLater: boolean; userId?: string },
  ) {
    const userId = body.userId || 'usr_default';
    return this.cartService.toggleSaveForLater(userId, itemId, body.isSavedForLater);
  }

  @Post('merge')
  @ApiOperation({ summary: 'Merge guest cart items into authenticated user cart' })
  async mergeGuestCart(@Body() body: { items: AddToCartDto[]; userId?: string }) {
    const userId = body.userId || 'usr_default';
    return this.cartService.mergeGuestCart(userId, body.items);
  }

  @Delete('clear')
  @ApiOperation({ summary: 'Clear active cart items' })
  async clearCart(@Query('userId') userId = 'usr_default') {
    return this.cartService.clearCart(userId);
  }
}
