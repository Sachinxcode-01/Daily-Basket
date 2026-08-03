import { Controller, Post, Body, Headers } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { AuthService } from './auth.service';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login-otp')
  @ApiOperation({ summary: 'Request 6-digit SMS OTP for authentication' })
  @ApiBody({ schema: { type: 'object', properties: { phoneNumber: { type: 'string', example: '9876543210' } } } })
  async requestOtp(@Body('phoneNumber') phoneNumber: string) {
    return this.authService.requestOtp(phoneNumber);
  }

  @Post('verify-otp')
  @ApiOperation({ summary: 'Verify OTP code and obtain JWT Access & Refresh tokens' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        phoneNumber: { type: 'string', example: '9876543210' },
        code: { type: 'string', example: '123456' },
      },
    },
  })
  async verifyOtp(
    @Body('phoneNumber') phoneNumber: string,
    @Body('code') code: string,
    @Headers('user-agent') userAgent?: string,
  ) {
    return this.authService.verifyOtp(phoneNumber, code, userAgent);
  }

  @Post('register')
  @ApiOperation({ summary: 'Complete new user profile registration' })
  async register(
    @Body() body: { phoneNumber: string; fullName: string; email?: string },
  ) {
    return this.authService.registerUser(body);
  }
}
