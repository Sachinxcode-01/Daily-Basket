import { Controller, Post, Get, Param, Body, ForbiddenException, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { OrdersService } from './orders.service';
import { OrderPricingService, CalculatePricingDto } from './order-pricing.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';

@ApiTags('Orders')
@ApiBearerAuth()
@UseGuards(OptionalJwtAuthGuard)
@Controller('orders')
export class OrdersController {
  constructor(
    private readonly ordersService: OrdersService,
    private readonly orderPricingService: OrderPricingService,
  ) {}

  @Post('calculate')
  @ApiOperation({ summary: 'Calculate dynamic order pricing, delivery fees, taxes, discounts & payment methods' })
  async calculatePricing(@ResolvedUserId() userId: string, @Body() body: CalculatePricingDto) {
    return this.orderPricingService.calculatePricing({ ...body, userId });
  }

  @Post()
  @ApiOperation({ summary: 'Create new 10-minute quick-commerce order' })
  async createOrder(
    @ResolvedUserId() userId: string,
    @Body() body: { addressId: string; paymentMethod: any; items: any[]; couponCode?: string; useWallet?: boolean },
  ) {
    return this.ordersService.createOrder(userId, body);
  }

  @Get()
  @ApiOperation({ summary: 'List orders for the current user (order history)' })
  async listOrders(@ResolvedUserId() userId: string) {
    return this.ordersService.findByUser(userId);
  }

  @Get(':id/tracking')
  @ApiOperation({ summary: 'Get live GPS tracking and delivery step status' })
  async getOrderTracking(@ResolvedUserId() userId: string, @Param('id') id: string) {
    const result = await this.ordersService.getOrderTracking(id);
    if (result?.order && result.order.userId !== userId) {
      throw new ForbiddenException('You do not have access to this order.');
    }
    return result;
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get single order details by id' })
  async getOrder(@ResolvedUserId() userId: string, @Param('id') id: string) {
    const order = await this.ordersService.findOne(id);
    if (order.userId !== userId) {
      throw new ForbiddenException('You do not have access to this order.');
    }
    return order;
  }

  @Post(':id/assign-rider')
  @ApiOperation({ summary: 'Assign rider to order and dispatch socket notification' })
  async assignRider(@Param('id') id: string, @Body() body: { riderId: string; riderName?: string; riderPhone?: string }) {
    return this.ordersService.assignDeliveryPartner(id, body.riderId || 'rider_01', {
      name: body.riderName || 'Ramesh Kumar',
      phone: body.riderPhone || '+91 98765 00112',
      vehicleNumber: 'KA 01 EB 4821',
    });
  }

  @Post(':id/start-delivery')
  @ApiOperation({ summary: 'Mark order as OUT_FOR_DELIVERY and start GPS stream' })
  async startDelivery(@Param('id') id: string) {
    return this.ordersService.startDelivery(id);
  }

  @Post(':id/complete-delivery')
  @ApiOperation({ summary: 'Verify OTP code and complete order delivery + generate GST invoice' })
  async completeDelivery(@Param('id') id: string, @Body() body: { otp?: string }) {
    return this.ordersService.completeDelivery(id, body.otp);
  }
}
