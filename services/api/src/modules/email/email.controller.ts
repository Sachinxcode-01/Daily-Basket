import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { EmailService, EmailOptions } from './email.service';

@ApiTags('SMTP Email Notifications')
@Controller('email')
export class EmailController {
  constructor(private readonly emailService: EmailService) {}

  @Post('send')
  @ApiOperation({ summary: 'Send transaction or alert email via SMTP provider' })
  async sendEmail(@Body() body: EmailOptions) {
    return this.emailService.sendEmail(body);
  }
}
