import { NextResponse } from 'next/server';
import { AuditLogEntry } from '../../../lib/auth-types';

export async function GET() {
  const sampleLogs: AuditLogEntry[] = [
    {
      id: 'aud_9812',
      timestamp: new Date(Date.now() - 1000 * 60 * 3).toISOString(),
      action: 'ADMIN_LOGIN_SUCCESS',
      actor: 'admin@dailybasket.com',
      role: 'SUPER_ADMIN',
      ip: '192.168.1.104',
      status: 'SUCCESS',
      details: 'Elevated TOTP authentication completed from trusted workstation.',
    },
    {
      id: 'aud_9811',
      timestamp: new Date(Date.now() - 1000 * 60 * 25).toISOString(),
      action: 'DAILY_MANDI_PRICE_SYNC',
      actor: 'manager@dailybasket.com',
      role: 'STORE_MANAGER',
      ip: '10.0.4.88',
      status: 'SUCCESS',
      details: 'Automated 60-second price push applied to 42 farm SKUs.',
    },
    {
      id: 'aud_9810',
      timestamp: new Date(Date.now() - 1000 * 60 * 62).toISOString(),
      action: 'FAILED_CREDENTIAL_CHALLENGE',
      actor: 'unknown_operator@dailybasket.com',
      role: 'DISPATCH_HEAD',
      ip: '49.207.199.12',
      status: 'WARNING',
      details: 'Incorrect password entered. Brute force defense logged incident.',
    },
    {
      id: 'aud_9809',
      timestamp: new Date(Date.now() - 1000 * 60 * 180).toISOString(),
      action: 'INWARD_GRN_BATCH_VERIFY',
      actor: 'inventory@dailybasket.com',
      role: 'INVENTORY_LEAD',
      ip: '10.0.4.92',
      status: 'SUCCESS',
      details: 'GRN-2026-0418 verified. 180 kg Alphonso Mangoes received at Koramangala Hub.',
    },
  ];

  return NextResponse.json({
    success: true,
    logs: sampleLogs,
    total: sampleLogs.length,
    securityLevel: 'STRICT_ZERO_TRUST',
  });
}
