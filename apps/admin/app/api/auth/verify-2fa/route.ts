import { NextRequest, NextResponse } from 'next/server';
import { ADMIN_PRESETS, AUTH_COOKIE_NAME } from '../../../lib/auth-constants';

export async function POST(req: NextRequest) {
  try {
    const { email, code, tempToken } = await req.json();

    if (!code || code.length < 6) {
      return NextResponse.json(
        { success: false, message: 'Please enter a valid 6-digit TOTP security code.' },
        { status: 400 }
      );
    }

    // Match preset
    const matchedPreset = Object.values(ADMIN_PRESETS).find(
      (p) => p.user.email.toLowerCase() === email?.toLowerCase()
    );

    // Accept preset pin, standard master dev pin 123456 or match
    const isValidPin =
      code === '123456' ||
      code === '984210' ||
      (matchedPreset && matchedPreset.pin === code);

    if (!isValidPin) {
      return NextResponse.json(
        { success: false, message: 'Invalid or expired 2FA code. Try demo code: 123456 or 984210.' },
        { status: 401 }
      );
    }

    const user = matchedPreset
      ? matchedPreset.user
      : {
          id: 'adm_verified',
          name: email?.split('@')[0] || 'Admin',
          email: email || 'admin@dailybasket.com',
          role: 'SUPER_ADMIN' as const,
          storeId: 'hub_koramangala_01',
          storeName: 'Koramangala Mega Dark Store #01',
          permissions: ['ALL'],
          twoFactorEnabled: true,
          lastLoginAt: new Date().toISOString(),
        };

    const now = Date.now();
    const token = Buffer.from(
      JSON.stringify({
        userId: user.id,
        email: user.email,
        role: user.role,
        twoFactorVerified: true,
        iat: now,
        exp: now + 86400000 * 7,
      })
    ).toString('base64');

    const res = NextResponse.json({
      success: true,
      user,
      token,
      message: 'Two-factor authentication verified. Session elevated.',
    });

    res.cookies.set({
      name: AUTH_COOKIE_NAME,
      value: token,
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 * 24 * 7,
    });

    return res;
  } catch (err: any) {
    return NextResponse.json(
      { success: false, message: err.message || 'Verification error' },
      { status: 500 }
    );
  }
}
