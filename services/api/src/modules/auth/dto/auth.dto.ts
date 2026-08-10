import { IsEmail, IsNotEmpty, IsString, IsOptional, MinLength, IsBoolean } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterEmailDto {
  @ApiProperty({ example: 'user@dailybasket.com' })
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @ApiProperty({ example: 'P@ssword123!' })
  @IsString()
  @MinLength(8)
  password!: string;

  @ApiProperty({ example: 'Rahul Sharma' })
  @IsString()
  @IsNotEmpty()
  name!: string;

  @ApiPropertyOptional({ example: '+919876543210' })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  termsAccepted?: boolean;

  @ApiPropertyOptional({ default: true })
  @IsOptional()
  @IsBoolean()
  privacyAccepted?: boolean;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  marketingConsent?: boolean;

  @ApiPropertyOptional({ example: 'REF1234' })
  @IsOptional()
  @IsString()
  referralCode?: string;
}

export class LoginEmailDto {
  @ApiProperty({ example: 'user@dailybasket.com' })
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @ApiProperty({ example: 'P@ssword123!' })
  @IsString()
  @IsNotEmpty()
  pass!: string;

  @ApiPropertyOptional({ example: '123456' })
  @IsOptional()
  @IsString()
  mfaCode?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  platform?: string;
}

export class SendEmailOtpDto {
  @ApiProperty({ example: 'admin@dailybasket.com' })
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @ApiPropertyOptional({ example: 'ADMIN_LOGIN' })
  @IsOptional()
  @IsString()
  type?: string;
}

export class VerifyEmailOtpDto {
  @ApiProperty({ example: 'admin@dailybasket.com' })
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @ApiProperty({ example: '482109' })
  @IsString()
  @IsNotEmpty()
  otp!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  platform?: string;
}

export class RequestOtpDto {

  @ApiProperty({ example: '9876543210' })
  @IsString()
  @IsNotEmpty()
  phone!: string;

  @ApiPropertyOptional({ example: 'LOGIN' })
  @IsOptional()
  @IsString()
  type?: string;
}

export class VerifyOtpDto {
  @ApiProperty({ example: '9876543210' })
  @IsString()
  @IsNotEmpty()
  phone!: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @IsNotEmpty()
  otp!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  platform?: string;
}

export class GoogleOAuthDto {
  @ApiProperty({ example: 'google-id-token-xyz' })
  @IsString()
  @IsNotEmpty()
  idToken!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  deviceName?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  platform?: string;
}

export class ForgotPasswordDto {
  @ApiProperty({ example: 'user@dailybasket.com' })
  @IsEmail()
  @IsNotEmpty()
  email!: string;
}

export class ResetPasswordDto {
  @ApiProperty({ example: 'reset_token_xyz' })
  @IsString()
  @IsNotEmpty()
  token!: string;

  @ApiProperty({ example: 'NewP@ssword123!' })
  @IsString()
  @MinLength(8)
  newPass!: string;
}

export class VerifyEmailDto {
  @ApiProperty({ example: 'verification_token_xyz' })
  @IsString()
  @IsNotEmpty()
  token!: string;
}

export class EnableMfaDto {
  @ApiProperty({ example: 'TOTP' })
  @IsString()
  @IsNotEmpty()
  type!: string;
}

export class VerifyMfaDto {
  @ApiProperty({ example: '123456' })
  @IsString()
  @IsNotEmpty()
  code!: string;
}

export class RevokeSessionDto {
  @ApiProperty({ example: 'sess_123' })
  @IsString()
  @IsNotEmpty()
  sessionId!: string;
}

export class ChangePasswordDto {
  @ApiProperty({ example: 'OldP@ssword123!' })
  @IsString()
  @IsNotEmpty()
  currentPass!: string;

  @ApiProperty({ example: 'NewP@ssword123!' })
  @IsString()
  @MinLength(8)
  newPass!: string;
}
