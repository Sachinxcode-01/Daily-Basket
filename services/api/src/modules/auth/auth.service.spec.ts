import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../../database/prisma.service';
import { EmailService } from '../email/email.service';

describe('AuthService Unit Tests', () => {
  let service: AuthService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
  };

  const mockEmailService = {
    sendWelcomeEmail: jest.fn().mockResolvedValue(true),
    sendVerificationEmail: jest.fn().mockResolvedValue(true),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: EmailService, useValue: mockEmailService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should request OTP successfully', async () => {
    const result = await service.requestOtp('9876543210');
    expect(result.success).toBe(true);
    expect(result.message).toContain('OTP sent');
  });

  it('should verify OTP and return user session', async () => {
    const result = await service.verifyOtp('9876543210', '123456');
    expect(result.accessToken).toBeDefined();
    expect(result.refreshToken).toBeDefined();
    expect(result.user).toBeDefined();
  });
});
