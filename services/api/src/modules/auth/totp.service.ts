import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

@Injectable()
export class TotpService {
  private readonly alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  /**
   * Generates a random Base32 TOTP secret key.
   */
  generateSecret(userEmail: string): { secret: string; otpauthUrl: string } {
    const bytes = crypto.randomBytes(20);
    let secret = '';
    for (let i = 0; i < bytes.length; i++) {
      secret += this.alphabet[bytes[i] % 32];
    }

    const encodedIssuer = encodeURIComponent('Daily Basket');
    const encodedUser = encodeURIComponent(userEmail);
    const otpauthUrl = `otpauth://totp/${encodedIssuer}:${encodedUser}?secret=${secret}&issuer=${encodedIssuer}&algorithm=SHA1&digits=6&period=30`;

    return { secret, otpauthUrl };
  }

  /**
   * Generates a TOTP 6-digit code for a given base32 secret and time step.
   */
  generateTotp(base32Secret: string, timeStep = Math.floor(Date.now() / 1000 / 30)): string {
    const key = this.base32ToBuffer(base32Secret);
    const buffer = Buffer.alloc(8);
    buffer.writeBigInt64BE(BigInt(timeStep), 0);

    const hmac = crypto.createHmac('sha1', key);
    hmac.update(buffer);
    const digest = hmac.digest();

    const offset = digest[digest.length - 1] & 0xf;
    const code =
      ((digest[offset] & 0x7f) << 24) |
      ((digest[offset + 1] & 0xff) << 16) |
      ((digest[offset + 2] & 0xff) << 8) |
      (digest[offset + 3] & 0xff);

    const strCode = (code % 1000000).toString();
    return strCode.padStart(6, '0');
  }

  /**
   * Verifies a 6-digit code against a base32 secret with allowed time drift window (default 1 step = +/- 30s).
   */
  verifyTotp(token: string, base32Secret: string, window = 1): boolean {
    if (!token || token.length !== 6 || !/^\d+$/.test(token)) {
      return false;
    }

    const currentStep = Math.floor(Date.now() / 1000 / 30);
    for (let i = -window; i <= window; i++) {
      const generated = this.generateTotp(base32Secret, currentStep + i);
      if (crypto.timingSafeEqual(Buffer.from(token), Buffer.from(generated))) {
        return true;
      }
    }
    return false;
  }

  /**
   * Generates N single-use backup recovery codes.
   */
  generateBackupCodes(count = 8): string[] {
    const codes: string[] = [];
    for (let i = 0; i < count; i++) {
      codes.push(crypto.randomBytes(4).toString('hex').toUpperCase());
    }
    return codes;
  }

  private base32ToBuffer(base32Str: string): Buffer {
    const cleanStr = base32Str.toUpperCase().replace(/[^A-Z2-7]/g, '');
    let bits = '';
    for (let i = 0; i < cleanStr.length; i++) {
      const val = this.alphabet.indexOf(cleanStr[i]);
      bits += val.toString(2).padStart(5, '0');
    }

    const bytes: number[] = [];
    for (let i = 0; i + 8 <= bits.length; i += 8) {
      bytes.push(parseInt(bits.substring(i, i + 8), 2));
    }
    return Buffer.from(bytes);
  }
}
