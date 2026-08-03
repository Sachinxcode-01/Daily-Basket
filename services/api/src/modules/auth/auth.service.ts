import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { EmailService } from '../email/email.service';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private emailService: EmailService,
  ) {}

  async requestOtp(phone: string) {
    return {
      success: true,
      phone,
      message: 'OTP sent to mobile number',
      demoOtp: '123456',
    };
  }

  async verifyOtp(phone: string, otp: string) {
    if (otp !== '123456' && otp !== '4821') {
      throw new UnauthorizedException('Invalid OTP PIN');
    }

    const mockUser = {
      id: 'usr_demo_8921',
      phone,
      name: 'Ananya Sharma',
      role: 'CUSTOMER',
      email: 'ananya@dailybasket.com',
    };

    return {
      accessToken: `jwt_access_token_demo_${Date.now()}`,
      refreshToken: `jwt_refresh_token_demo_${Date.now()}`,
      user: mockUser,
    };
  }

  async googleOAuthLogin(idToken: string) {
    const mockGoogleUser = {
      id: 'usr_google_9021',
      name: 'Sachin Kumar',
      email: 'sachiii8827@gmail.com',
      avatar: 'https://lh3.googleusercontent.com/a/default-user',
      role: 'CUSTOMER',
      loginProvider: 'GOOGLE',
    };

    // Send Welcome Email
    await this.emailService.sendEmail({
      to: mockGoogleUser.email,
      subject: 'Welcome to Daily Basket!',
      template: 'WELCOME',
      data: { customerName: mockGoogleUser.name },
    });

    return {
      accessToken: `jwt_google_access_token_${Date.now()}`,
      refreshToken: `jwt_google_refresh_token_${Date.now()}`,
      user: mockGoogleUser,
    };
  }

  async registerEmail(data: { email: string; pass: string; name: string }) {
    const verificationToken = `token_${Date.now()}`;
    
    // Trigger Email Verification link
    await this.emailService.sendEmail({
      to: data.email,
      subject: 'Verify Your Daily Basket Email',
      template: 'WELCOME',
      data: {
        customerName: data.name,
        message: `Please verify your email using token: ${verificationToken}`,
      },
    });

    return {
      success: true,
      email: data.email,
      message: 'Account created! Verification email dispatched.',
    };
  }

  async loginEmail(data: { email: string; pass: string }) {
    if (data.pass.length < 6) {
      throw new BadRequestException('Password must be at least 6 characters');
    }

    return {
      accessToken: `jwt_email_access_token_${Date.now()}`,
      refreshToken: `jwt_email_refresh_token_${Date.now()}`,
      user: {
        id: 'usr_email_1092',
        email: data.email,
        name: 'Daily Basket Customer',
        role: 'CUSTOMER',
      },
    };
  }

  async forgotPassword(email: string) {
    const resetToken = `reset_${Date.now()}`;

    await this.emailService.sendEmail({
      to: email,
      subject: 'Reset Your Daily Basket Password',
      template: 'WELCOME',
      data: { message: `Click link or use reset token: ${resetToken}` },
    });

    return {
      success: true,
      email,
      message: 'Password reset link dispatched to your inbox.',
    };
  }

  async resetPassword(token: string, newPass: string) {
    return {
      success: true,
      message: 'Your password has been reset successfully. Please log in with your new password.',
    };
  }

  async verifyEmailToken(token: string) {
    return {
      success: true,
      message: 'Email address verified successfully!',
    };
  }

  async getActiveSessions(userId: string) {
    return [
      { id: 'sess_1', device: 'Pixel 8 Pro (Flutter)', ip: '157.34.12.8', location: 'Bengaluru, India', isCurrent: true, lastActive: 'Just now' },
      { id: 'sess_2', device: 'Chrome Web (Windows 11)', ip: '157.34.12.9', location: 'Bengaluru, India', isCurrent: false, lastActive: '2 hours ago' },
    ];
  }

  async revokeSession(userId: string, sessionId: string) {
    return {
      success: true,
      sessionId,
      message: 'Device session revoked successfully.',
    };
  }

  async revokeAllSessions(userId: string) {
    return {
      success: true,
      userId,
      message: 'All active device sessions revoked. User logged out across all devices.',
    };
  }
}
