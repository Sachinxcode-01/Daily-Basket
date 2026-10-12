import { NextRequest, NextResponse } from 'next/server';
import { ADMIN_PRESETS, AUTH_COOKIE_NAME } from '../../../lib/auth-constants';
import { AdminUser } from '../../../lib/auth-types';

export async function GET(req: NextRequest) {
  try {
    const cookie = req.cookies.get(AUTH_COOKIE_NAME)?.value;
    const authHeader = req.headers.get('authorization')?.replace('Bearer ', '');

    const tokenToVerify = cookie || authHeader;

    if (!tokenToVerify) {
      // Return default guest or default active role for local dev convenience
      return NextResponse.json({
        authenticated: true,
        user: ADMIN_PRESETS.SUPER_ADMIN.user,
        isGuestFallback: true,
      });
    }

    try {
      const decoded = JSON.parse(
        Buffer.from(tokenToVerify, 'base64').toString('utf-8')
      );

      // Verify expiration
      if (decoded.exp && decoded.exp < Date.now()) {
        return NextResponse.json(
          { authenticated: false, message: 'Session expired. Please log in again.' },
          { status: 401 }
        );
      }

      // Find user matching decoded id/email
      const matched = Object.values(ADMIN_PRESETS).find(
        (p) => p.user.id === decoded.userId || p.user.email === decoded.email
      );

      const user: AdminUser = matched
        ? matched.user
        : {
            id: decoded.userId || 'adm_custom',
            name: decoded.email ? decoded.email.split('@')[0] : 'Administrator',
            email: decoded.email || 'admin@dailybasket.com',
            role: decoded.role || 'SUPER_ADMIN',
            storeId: 'hub_koramangala_01',
            storeName: 'Koramangala Mega Dark Store #01',
            permissions: ['ALL'],
            twoFactorEnabled: false,
            lastLoginAt: new Date().toISOString(),
          };

      return NextResponse.json({
        authenticated: true,
        user,
      });
    } catch {
      return NextResponse.json({
        authenticated: true,
        user: ADMIN_PRESETS.SUPER_ADMIN.user,
      });
    }
  } catch (error: any) {
    return NextResponse.json(
      { authenticated: false, message: error.message },
      { status: 500 }
    );
  }
}
