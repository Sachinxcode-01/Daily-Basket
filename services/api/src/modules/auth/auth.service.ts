import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { createHmac } from 'crypto';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService) {}

  async requestOtp(phone: string) {
    // Demo OTP request logic
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
    };

    return {
      accessToken: `jwt_access_token_demo_${Date.now()}`,
      refreshToken: `jwt_refresh_token_demo_${Date.now()}`,
      user: mockUser,
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
