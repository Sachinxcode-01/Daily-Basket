import { Injectable, BadRequestException } from '@nestjs/common';
import * as crypto from 'crypto';
import { promisify } from 'util';

const scrypt = promisify(crypto.scrypt);

const COMMON_PASSWORDS = new Set([
  'password',
  'password123',
  '12345678',
  '123456789',
  '1234567890',
  'qwertyuiop',
  'admin123',
  'dailybasket',
  'welcome123',
  'letmein123',
  'iloveyou123',
  'monkey123',
]);

export interface PasswordValidationResult {
  isValid: boolean;
  score: number; // 0 to 100
  errors: string[];
}

@Injectable()
export class PasswordPolicyService {
  /**
   * Hashes a password with a random 16-byte salt using crypto scrypt.
   * Returns format: 'saltHex:hashHex'
   */
  async hashPassword(password: string): Promise<string> {
    const salt = crypto.randomBytes(16).toString('hex');
    const derivedKey = (await scrypt(password, salt, 64)) as Buffer;
    return `${salt}:${derivedKey.toString('hex')}`;
  }

  /**
   * Compares a plain password against a stored 'salt:hash' string.
   */
  async comparePassword(password: string, storedHash: string): Promise<boolean> {
    if (!storedHash || !storedHash.includes(':')) {
      return false;
    }
    const [salt, keyHex] = storedHash.split(':');
    const derivedKey = (await scrypt(password, salt, 64)) as Buffer;
    return crypto.timingSafeEqual(Buffer.from(keyHex, 'hex'), derivedKey);
  }

  /**
   * Validates password strength against policy rules:
   * - Min 8 characters
   * - Uppercase letter
   * - Lowercase letter
   * - Digit
   * - Special character
   * - Not a common password
   */
  validatePasswordStrength(password: string): PasswordValidationResult {
    const errors: string[] = [];
    let score = 0;

    if (!password || password.length < 8) {
      errors.push('Password must be at least 8 characters long.');
    } else {
      score += 25;
    }

    if (!/[A-Z]/.test(password)) {
      errors.push('Password must contain at least one uppercase letter.');
    } else {
      score += 20;
    }

    if (!/[a-z]/.test(password)) {
      errors.push('Password must contain at least one lowercase letter.');
    } else {
      score += 20;
    }

    if (!/[0-9]/.test(password)) {
      errors.push('Password must contain at least one number.');
    } else {
      score += 15;
    }

    if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      errors.push('Password must contain at least one special character (!@#$%^&*).');
    } else {
      score += 20;
    }

    const lowerStr = password.toLowerCase();
    if (COMMON_PASSWORDS.has(lowerStr)) {
      errors.push('Password is too common and easily guessable.');
      score = Math.min(score, 20);
    }

    return {
      isValid: errors.length === 0,
      score: Math.min(score, 100),
      errors,
    };
  }

  /**
   * Asserts password validity and throws BadRequestException if invalid.
   */
  assertPasswordPolicy(password: string): void {
    const result = this.validatePasswordStrength(password);
    if (!result.isValid) {
      throw new BadRequestException({
        statusCode: 400,
        message: 'Password does not satisfy policy rules',
        errors: result.errors,
      });
    }
  }

  /**
   * Verifies if a proposed new password matches any previously used password hashes.
   */
  async isPasswordInHistory(newPassword: string, historyHashes: string[]): Promise<boolean> {
    for (const oldHash of historyHashes) {
      if (await this.comparePassword(newPassword, oldHash)) {
        return true;
      }
    }
    return false;
  }
}
