import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
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
}
