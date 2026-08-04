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

  @Post('google-login')
  @ApiOperation({ summary: 'Google OAuth 2.0 single sign-on authentication' })
  async googleOAuthLogin(@Body() body: { idToken: string }) {
    return this.authService.googleOAuthLogin(body.idToken);
  }

  @Post('register-email')
  @ApiOperation({ summary: 'Create new customer account via Email & Password' })
  async registerEmail(@Body() body: { email: string; pass: string; name: string }) {
    return this.authService.registerEmail(body);
  }

  @Post('login-email')
  @ApiOperation({ summary: 'Log in using Email & Password' })
  async loginEmail(@Body() body: { email: string; pass: string }) {
    return this.authService.loginEmail(body);
  }

  @Post('forgot-password')
  @ApiOperation({ summary: 'Request password reset verification link' })
  async forgotPassword(@Body() body: { email: string }) {
    return this.authService.forgotPassword(body.email);
  }

  @Post('reset-password')
  @ApiOperation({ summary: 'Reset account password using reset token' })
  async resetPassword(@Body() body: { token: string; newPass: string }) {
    return this.authService.resetPassword(body.token, body.newPass);
  }

  @Post('verify-email')
  @ApiOperation({ summary: 'Verify customer email address token' })
  async verifyEmailToken(@Body() body: { token: string }) {
    return this.authService.verifyEmailToken(body.token);
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

  @Post('preferences')
  @ApiOperation({ summary: 'Save onboarding completed state and user permissions' })
  async savePreferences(
    @Body() body: { userId?: string; locationGranted?: boolean; notificationsGranted?: boolean },
  ) {
    return this.authService.saveOnboardingPreferences(body);
  }
}

