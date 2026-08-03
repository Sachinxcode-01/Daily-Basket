import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { AuthService } from './auth.service';

@ApiTags('Authentication & Security')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login-otp')
  @ApiOperation({ summary: 'Request phone OTP PIN' })
  async requestOtp(@Body() body: { phone: string }) {
    return this.authService.requestOtp(body.phone);
  }

  @Post('verify-otp')
  @ApiOperation({ summary: 'Verify OTP PIN & generate JWT bearer tokens' })
  async verifyOtp(@Body() body: { phone: string; otp: string }) {
    return this.authService.verifyOtp(body.phone, body.otp);
  }

  @Get('sessions/:userId')
  @ApiOperation({ summary: 'Get active logged-in device sessions' })
  async getSessions(@Param('userId') userId: string) {
    return this.authService.getActiveSessions(userId);
  }

  @Post('sessions/revoke')
  @ApiOperation({ summary: 'Revoke specific device session' })
  async revokeSession(@Body() body: { userId: string; sessionId: string }) {
    return this.authService.revokeSession(body.userId, body.sessionId);
  }

  @Post('sessions/revoke-all')
  @ApiOperation({ summary: 'Log out across all active devices' })
  async revokeAllSessions(@Body() body: { userId: string }) {
    return this.authService.revokeAllSessions(body.userId);
  }
}
