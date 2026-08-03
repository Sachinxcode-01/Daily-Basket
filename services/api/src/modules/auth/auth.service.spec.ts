import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../../database/prisma.service';

describe('AuthService Unit Tests', () => {
  let service: AuthService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
  };

  const mockJwtService = {
    sign: jest.fn().mockReturnValue('mocked_jwt_token'),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: JwtService, useValue: mockJwtService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should request OTP successfully', async () => {
    const result = await service.requestOtp('9876543210');
    expect(result.success).toBe(true);
    expect(result.message).toContain('OTP sent');
  });

  it('should verify OTP and return JWT token', async () => {
    mockPrismaService.user.findUnique.mockResolvedValue({
      id: 'user_123',
      phoneNumber: '9876543210',
      role: 'CUSTOMER',
    });

    const result = await service.verifyOtp('9876543210', '123456');
    expect(result.accessToken).toBe('mocked_jwt_token');
    expect(result.user.id).toBe('user_123');
  });
});
