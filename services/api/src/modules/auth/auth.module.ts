import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PrismaService } from '../../database/prisma.service';
import { EmailModule } from '../email/email.module';
import { PasswordPolicyService } from './password-policy.service';
import { TotpService } from './totp.service';
import { JwtStrategy } from './strategies/jwt.strategy';

@Module({
  imports: [
    EmailModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'daily_basket_super_secret_jwt_key_2026',
      signOptions: { expiresIn: '15m' },
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    PrismaService,
    PasswordPolicyService,
    TotpService,
    JwtStrategy,
  ],
  exports: [AuthService, PasswordPolicyService, TotpService],
})
export class AuthModule {}
