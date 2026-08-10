import { Controller, Get, Post, Param, Body, UseGuards, Req } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import {
  RegisterEmailDto,
  LoginEmailDto,
  RequestOtpDto,
  VerifyOtpDto,
  SendEmailOtpDto,
  VerifyEmailOtpDto,
  GoogleOAuthDto,
  ForgotPasswordDto,
  ResetPasswordDto,
  VerifyEmailDto,
  ChangePasswordDto,
} from './dto/auth.dto';


@ApiTags('Authentication & Security')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login-otp')
  @ApiOperation({ summary: 'Request phone OTP PIN with 60s cooldown & rate limiting' })
  async requestOtp(@Body() body: RequestOtpDto) {
    return this.authService.requestOtp(body);
  }

  @Post('verify-otp')
  @ApiOperation({ summary: 'Verify OTP PIN & generate JWT bearer tokens' })
  async verifyOtp(@Body() body: VerifyOtpDto) {
    return this.authService.verifyOtp(body);
  }

  @Post('google-login')
  @ApiOperation({ summary: 'Google OAuth 2.0 single sign-on authentication' })
  async googleOAuthLogin(@Body() body: GoogleOAuthDto) {
    return this.authService.googleOAuthLogin(body);
  }

  @Post('register-email')
  @ApiOperation({ summary: 'Create new customer account via Email & Password with policy check' })
  async registerEmail(@Body() body: RegisterEmailDto) {
    return this.authService.registerEmail(body);
  }

  @Post('login-email')
  @ApiOperation({ summary: 'Log in using Email & Password with lockout & MFA support' })
  async loginEmail(@Body() body: LoginEmailDto) {
    return this.authService.loginEmail(body);
  }

  @Post('refresh-token')
  @ApiOperation({ summary: 'Refresh JWT access token with token rotation' })
  async refreshTokens(@Body() body: { refreshToken: string }) {
    return this.authService.refreshTokens(body.refreshToken);
  }

  @Post('forgot-password')
  @ApiOperation({ summary: 'Request single-use password reset link & token' })
  async forgotPassword(@Body() body: ForgotPasswordDto) {
    return this.authService.forgotPassword(body.email);
  }

  @Post('reset-password')
  @ApiOperation({ summary: 'Reset account password, enforce history, and revoke active sessions' })
  async resetPassword(@Body() body: ResetPasswordDto) {
    return this.authService.resetPassword(body.token, body.newPass);
  }

  @Post('verify-email')
  @ApiOperation({ summary: 'Verify customer email address token' })
  async verifyEmailToken(@Body() body: VerifyEmailDto) {
    return this.authService.verifyEmailToken(body.token);
  }

  @Post('mfa/setup')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Generate TOTP MFA secret and QR code URL' })
  async setupMfa(@Req() req: any) {
    return this.authService.setupMfa(req.user.id);
  }

  @Post('mfa/confirm')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Confirm TOTP code, enable MFA, and generate backup codes' })
  async confirmMfa(@Req() req: any, @Body() body: { secret: string; code: string }) {
    return this.authService.confirmMfa(req.user.id, body.secret, body.code);
  }

  @Post('mfa/disable')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Disable Multi-Factor Authentication' })
  async disableMfa(@Req() req: any) {
    return this.authService.disableMfa(req.user.id);
  }

  @Get('sessions/:userId')
  @ApiOperation({ summary: 'Get active logged-in device sessions' })
  async getSessions(@Param('userId') userId: string) {
    return this.authService.getActiveSessions(userId);
  }

  @Post('sessions/revoke')
  @ApiOperation({ summary: 'Revoke specific device session' })
  async revokeSession(@Body() body: { userId?: string; sessionId: string }) {
    return this.authService.revokeSession(body.userId || 'usr_demo', body.sessionId);
  }

  @Post('sessions/revoke-all')
  @ApiOperation({ summary: 'Log out across all active devices' })
  async revokeAllSessions(@Body() body: { userId: string }) {
    return this.authService.revokeAllSessions(body.userId);
  }

  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change account password with current password verification' })
  async changePassword(@Req() req: any, @Body() body: ChangePasswordDto) {
    return this.authService.changePassword(req.user.id, body);
  }

  @Post('preferences')
  @ApiOperation({ summary: 'Save onboarding completed state and user permissions' })
  async savePreferences(
    @Body() body: { userId?: string; locationGranted?: boolean; notificationsGranted?: boolean },
  ) {
    return this.authService.saveOnboardingPreferences(body);
  }

  @Post('passkeys/register-options')
  @ApiOperation({ summary: 'Generate FIDO2 / WebAuthn passkey registration challenge' })
  async getPasskeyRegisterOptions(@Body() body: { email: string }) {
    return this.authService.getPasskeyRegisterOptions(body.email);
  }

  @Post('passkeys/verify-register')
  @ApiOperation({ summary: 'Verify and register FIDO2 WebAuthn public key credential' })
  async verifyPasskeyRegistration(@Body() body: { email: string; credential: any }) {
    return this.authService.verifyPasskeyRegistration(body.email, body.credential);
  }

  @Post('passkeys/authenticate')
  @ApiOperation({ summary: 'Authenticate user with biometric Passkey (FaceID / TouchID / Windows Hello)' })
  async authenticatePasskey(@Body() body: { credentialId: string; signature: string }) {
    return this.authService.authenticatePasskey(body.credentialId, body.signature);
  }

  @Post('send-email-otp')
  @ApiOperation({ summary: 'Request 6-digit Email OTP with 60s cooldown & rate limiting' })
  async sendEmailOtp(@Body() body: SendEmailOtpDto) {
    return this.authService.sendEmailOtp(body.email, body.type);
  }

  @Post('verify-email-otp')
  @ApiOperation({ summary: 'Verify Email 6-digit OTP & generate JWT bearer tokens' })
  async verifyEmailOtp(@Body() body: VerifyEmailOtpDto) {
    return this.authService.verifyEmailOtp(body.email, body.otp, {
      deviceId: body.deviceId,
      deviceName: body.deviceName,
      platform: body.platform,
    });
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Log out active admin session & invalidate refresh token' })
  async logout(@Req() req: any, @Body() body: { refreshToken?: string }) {
    return this.authService.logout(req.user?.id || 'usr_admin_01', body.refreshToken);
  }

  @Post('logout-all')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Log out across all devices and invalidate all active sessions' })
  async logoutAll(@Req() req: any) {
    return this.authService.revokeAllSessions(req.user?.id || 'usr_admin_01');
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get logged-in admin user profile & permissions' })
  async getProfile(@Req() req: any) {
    return this.authService.getAdminProfile(req.user?.id || 'usr_admin_01');
  }

  @Get('session')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current session metadata, risk score & trusted device info' })
  async getSession(@Req() req: any) {
    return this.authService.getUserSession(req.user?.id || 'usr_admin_01');
  }

  @Post('risk-score')
  @ApiOperation({ summary: 'Evaluate device fingerprint security risk score' })
  async evaluateDeviceRisk(@Body() body: { userId?: string; deviceId: string; ipAddress: string; platform: string }) {
    return this.authService.evaluateDeviceRisk(body.userId || 'usr_demo', body.deviceId, body.ipAddress, body.platform);
  }
}


