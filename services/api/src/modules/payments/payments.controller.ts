import { Controller, Post, Get, Body, Param, Headers, Req } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam, ApiHeader } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';

@ApiTags('Payments')
@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('initiate')
  @ApiOperation({ summary: 'Initiate Razorpay checkout payment intent' })
  async initiatePayment(@Body() body: { orderId: string; amount: number }) {
    return this.paymentsService.initiateRazorpayOrder(body.orderId, body.amount);
  }

  @Post('verify')
  @ApiOperation({ summary: 'Verify Razorpay HMAC SHA-256 payment signature' })
  async verifyPayment(
    @Body() body: { paymentId: string; razorpayOrderId: string; razorpaySignature: string },
  ) {
    return this.paymentsService.verifySignature(body.paymentId, body.razorpayOrderId, body.razorpaySignature);
  }

  // ==========================================
  // YOUPI PG V2 Endpoints
  // ==========================================

  @Post('youpi/initiate')
  @ApiOperation({ summary: 'Initiate 0% fee YouPI UPI checkout session' })
  async initiateYoupi(
    @Body() body: { orderId: string; amount: number; phoneNumber?: string; fullName?: string },
  ) {
    return this.paymentsService.initiateYoupiOrder(body.orderId, body.amount, {
      phoneNumber: body.phoneNumber,
      fullName: body.fullName,
    });
  }

  @Get('youpi/status/:id')
  @ApiOperation({ summary: 'Query YouPI payment session verification status' })
  @ApiParam({ name: 'id', description: 'YouPI payment session ID' })
  async getYoupiStatus(@Param('id') paymentId: string) {
    return this.paymentsService.getYoupiPaymentStatus(paymentId);
  }

  @Post('youpi/webhook')
  @ApiOperation({ summary: 'Authoritative YouPI bank observation HMAC-SHA256 webhook listener' })
  @ApiHeader({ name: 'x-gateway-signature', description: 'HMAC-SHA256 signature calculated over raw body' })
  async youpiWebhook(
    @Req() req: any,
    @Headers('x-gateway-signature') signature?: string,
  ) {
    const rawPayload = req.rawBody || req.body;
    return this.paymentsService.handleYoupiWebhook(rawPayload, signature);
  }
}

