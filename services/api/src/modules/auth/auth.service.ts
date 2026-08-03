import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../../database/prisma.service';

export interface TokenPayload {
  sub: string;
  phoneNumber: string;
  role: string;
}

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async requestOtp(phoneNumber: string) {
    if (!phoneNumber || phoneNumber.length < 10) {
      throw new BadRequestException('Invalid phone number provided');
    }

    // In production, integrate SMS provider (Twilio / Firebase / MSG91)
    const demoCode = '123456';
    return {
      success: true,
      message: `OTP sent successfully to +91 ${phoneNumber}.`,
      demoCode, // Returned for dev testing
    };
  }

  async verifyOtp(phoneNumber: string, code: string, userAgent?: string) {
    if (code !== '123456') {
      throw new UnauthorizedException('Invalid OTP code. Please enter 123456 for demo.');
    }

    let user = await this.prisma.user.findUnique({
      where: { phoneNumber },
    });

    if (!user) {
      user = await this.prisma.user.create({
        data: {
          phoneNumber,
          fullName: 'Customer ' + phoneNumber.slice(-4),
          role: 'CUSTOMER',
          isVerified: true,
        },
      });
    }

    const payload: TokenPayload = {
      sub: user.id,
      phoneNumber: user.phoneNumber,
      role: user.role,
    };

    const accessToken = this.jwtService.sign(payload, { expiresIn: '15m' });
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '7d' });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        phoneNumber: user.phoneNumber,
        fullName: user.fullName,
        role: user.role,
        avatarUrl: user.avatarUrl,
      },
    };
  }

  async registerUser(data: { phoneNumber: string; fullName: string; email?: string }) {
    let user = await this.prisma.user.findUnique({
      where: { phoneNumber: data.phoneNumber },
    });

    if (user) {
      user = await this.prisma.user.update({
        where: { id: user.id },
        data: { fullName: data.fullName, email: data.email },
      });
    } else {
      user = await this.prisma.user.create({
        data: {
          phoneNumber: data.phoneNumber,
          fullName: data.fullName,
          email: data.email,
          role: 'CUSTOMER',
          isVerified: true,
        },
      });
    }

    const payload: TokenPayload = { sub: user.id, phoneNumber: user.phoneNumber, role: user.role };
    const accessToken = this.jwtService.sign(payload, { expiresIn: '15m' });
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '7d' });

    return { accessToken, refreshToken, user };
  }
}
