import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { EmailService, EmailOptions, InboundEmailDto } from './email.service';

@ApiTags('SMTP & AI Email Support')
@Controller('email')
export class EmailController {
  constructor(private readonly emailService: EmailService) { }

  @Post('send')
  @ApiOperation({ summary: 'Send transaction or alert email via SMTP provider' })
  async sendEmail(@Body() body: EmailOptions) {
    return this.emailService.sendEmail(body);
  }

  @Post(['inbound', 'inbound-webhook'])
  @ApiOperation({
    summary:
      'Receive incoming customer support email and automatically reply with human-like AI (Sarah J.)',
  })
  @ApiBody({
    description: 'Inbound email webhook payload from email provider (SendGrid, Mailgun, AWS SES, or direct)',
    schema: {
      type: 'object',
      required: ['from', 'subject'],
      properties: {
        from: { type: 'string', example: 'customer@gmail.com' },
        to: { type: 'string', example: 'support@dailybasket.com' },
        subject: { type: 'string', example: 'Where is my order #DB-9824?' },
        body: {
          type: 'string',
          example: 'Hi, I placed an order 15 minutes ago but rider has not arrived. Can you check?',
        },
        orderId: { type: 'string', example: '#DB-9824' },
      },
    },
  })
  async handleInboundEmail(@Body() body: InboundEmailDto) {
    return this.emailService.handleInboundEmail(body);
  }
}
