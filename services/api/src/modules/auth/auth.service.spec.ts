import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { UnauthorizedException, BadRequestException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { PrismaService } from '../../database/prisma.service';
import { EmailService } from '../email/email.service';
import { PasswordPolicyService } from './password-policy.service';
import { TotpService } from './totp.service';

describe('AuthService Enterprise Security Tests', () => {
  let service: AuthService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    otpVerification: {
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    deviceSession: {
      findUnique: jest.fn(),
      findMany: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      updateMany: jest.fn(),
    },
    securityAuditLog: {
      create: jest.fn().mockResolvedValue({ id: 'log_1' }),
    },
    passwordHistory: {
      findMany: jest.fn().mockResolvedValue([]),
      create: jest.fn().mockResolvedValue({ id: 'hist_1' }),
    },
  };

  const mockEmailService = {
    sendEmail: jest.fn().mockResolvedValue(true),
  };

  const mockJwtService = {
    sign: jest.fn().mockReturnValue('mock_jwt_access_token_123'),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        PasswordPolicyService,
        TotpService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: EmailService, useValue: mockEmailService },
        { provide: JwtService, useValue: mockJwtService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  describe('Phone OTP Authentication', () => {
    it('should request OTP successfully and return cooldown metadata', async () => {
      mockPrismaService.otpVerification.findFirst.mockResolvedValue(null);
      mockPrismaService.otpVerification.create.mockResolvedValue({ id: 'otp_1' });

      const result = await service.requestOtp({ phone: '9876543210' });

      expect(result.success).toBe(true);
      expect(result.phone).toBe('9876543210');
      expect(result.demoOtp).toBe('123456');
    });

    it('should throw BadRequestException if cooldown period has not elapsed', async () => {
      mockPrismaService.otpVerification.findFirst.mockResolvedValue({
        resendAfter: new Date(Date.now() + 45000), // 45s in future
      });

      await expect(service.requestOtp({ phone: '9876543210' })).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should verify correct OTP and issue JWT access token', async () => {
      mockPrismaService.otpVerification.findFirst.mockResolvedValue({
        id: 'otp_1',
        identifier: '9876543210',
        otpHash: 'd404559f602eab6fd602ac7680dacbfaadd13630335e951f097af3900e9de176', // sha256 of 123456
        expiresAt: new Date(Date.now() + 300000),
        attempts: 0,
        maxAttempts: 3,
      });

      mockPrismaService.user.findUnique.mockResolvedValue({
        id: 'usr_1',
        phoneNumber: '9876543210',
        fullName: 'Rahul Sharma',
        role: 'CUSTOMER',
        isVerified: true,
      });

      mockPrismaService.deviceSession.create.mockResolvedValue({ id: 'sess_1' });

      const result = await service.verifyOtp({ phone: '9876543210', otp: '123456' });

      expect(result.accessToken).toBe('mock_jwt_access_token_123');
      expect(result.refreshToken).toBeDefined();
      expect(result.user.phone).toBe('9876543210');
    });
  });

  describe('Email Registration & Password Policy', () => {
    it('should reject weak passwords failing strength policy', async () => {
      await expect(
        service.registerEmail({
          email: 'test@dailybasket.com',
          password: 'weak',
          name: 'Test User',
        }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should register user with valid credentials and send email verification', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue({
        id: 'usr_new',
        email: 'newuser@dailybasket.com',
        fullName: 'New User',
        role: 'CUSTOMER',
      });

      const result = await service.registerEmail({
        email: 'newuser@dailybasket.com',
        password: 'P@ssword123!',
        name: 'New User',
      });

      expect(result.success).toBe(true);
      expect(result.verificationToken).toBeDefined();
      expect(mockEmailService.sendEmail).toHaveBeenCalled();
    });
  });

  describe('Account Lockout Security', () => {
    it('should lock out user after 5 consecutive failed login attempts', async () => {
      const mockPasswordHash = await new PasswordPolicyService().hashPassword('P@ssword123!');
      mockPrismaService.user.findUnique.mockResolvedValue({
        id: 'usr_lockout',
        email: 'target@dailybasket.com',
        passwordHash: mockPasswordHash,
        failedLoginAttempts: 4,
        lockoutUntil: null,
      });

      await expect(
        service.loginEmail({ email: 'target@dailybasket.com', pass: 'WrongPassword!' }),
      ).rejects.toThrow(UnauthorizedException);

      expect(mockPrismaService.user.update).toHaveBeenCalledWith({
        where: { id: 'usr_lockout' },
        data: expect.objectContaining({
          failedLoginAttempts: 5,
          lockoutUntil: expect.any(Date),
        }),
      });
    });
  });

  describe('TOTP Multi-Factor Authentication', () => {
    it('should generate TOTP secret and QR code URI', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue({
        id: 'usr_mfa',
        email: 'mfa@dailybasket.com',
      });

      const result = await service.setupMfa('usr_mfa');

      expect(result.secret).toBeDefined();
      expect(result.otpauthUrl).toContain('otpauth://totp/');
    });
  });

  describe('Session Management & Revocation', () => {
    it('should revoke all user active device sessions', async () => {
      mockPrismaService.deviceSession.updateMany.mockResolvedValue({ count: 2 });

      const result = await service.revokeAllSessions('usr_1');

      expect(result.success).toBe(true);
      expect(mockPrismaService.deviceSession.updateMany).toHaveBeenCalledWith({
        where: { userId: 'usr_1' },
        data: { isActive: false },
      });
    });
  });

  describe('Email OTP & Device Risk Evaluation', () => {
    it('should send email OTP with 60s cooldown metadata', async () => {
      const result = await service.sendEmailOtp('admin@dailybasket.com');
      expect(result.success).toBe(true);
      expect(result.resendCooldownSeconds).toBe(60);
    });

    it('should verify email OTP code', async () => {
      const result = await service.verifyEmailOtp('admin@dailybasket.com', '482109');
      expect(result.success).toBe(true);
      expect(result.tokens).toBeDefined();
    });

    it('should evaluate device security risk score', async () => {
      const riskResult = await service.evaluateDeviceRisk(
        'usr_1',
        'dev_browser_01',
        '127.0.0.1',
        'web',
      );
      expect(riskResult.riskScore).toBeLessThan(0.1);
      expect(riskResult.riskLevel).toBe('LOW');
    });

    it('should authenticate passkey biometric challenge', async () => {
      const passkeyResult = await service.authenticatePasskey('cred_123', 'sig_abc');
      expect(passkeyResult.success).toBe(true);
      expect(passkeyResult.signatureVerified).toBe(true);
    });
  });
});

