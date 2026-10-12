import { NextResponse } from 'next/server';
import { AUTH_COOKIE_NAME } from '../../../lib/auth-constants';

export async function POST() {
  const res = NextResponse.json({
    success: true,
    message: 'Logged out successfully. Administrative session terminated.',
  });

  res.cookies.set({
    name: AUTH_COOKIE_NAME,
    value: '',
    httpOnly: true,
    expires: new Date(0),
    path: '/',
  });

  return res;
}

export async function GET() {
  return POST();
}
