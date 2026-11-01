import { NextRequest, NextResponse } from 'next/server';

const BACKEND_URL = (process.env.API_BASE_URL || process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000').replace(/\/$/, '');

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const limit = searchParams.get('limit') || '50';

  try {
    const res = await fetch(`${BACKEND_URL}/api/v1/users/admin/customers?limit=${limit}`, {
      headers: { 'Content-Type': 'application/json' },
      cache: 'no-store',
    });

    if (res.ok) {
      const data = await res.json();
      return NextResponse.json({
        success: true,
        customers: Array.isArray(data) ? data : data.data || [],
      });
    }
  } catch {
    // Backend offline / starting up
  }

  return NextResponse.json({
    success: false,
    message: 'Backend customers service unreachable, falling back to local store.',
  });
}
