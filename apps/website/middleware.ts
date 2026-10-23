import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

// Blocked path traversal and reconnaissance patterns
const BLOCKED_PATTERNS = [
  /\.\./,                          // Directory traversal
  /\.env/i,                       // Environment files probe
  /\.git/i,                       // Git repository probe
  /wp-admin|wp-login|xmlrpc/i,     // WordPress bots
  /phpmyadmin/i,                  // DB probes
  /\.(bak|config|sql|tar|gz|zip)$/i, // Sensitive archive dumps
  /%00|\\0/,                      // Null byte poisoning
];

export function middleware(request: NextRequest) {
  const { pathname, search } = request.nextUrl;
  const fullPath = `${pathname}${search}`;

  // 1. Defense-in-depth: Block malicious URL patterns, null bytes, and path traversal
  for (const pattern of BLOCKED_PATTERNS) {
    if (pattern.test(fullPath)) {
      return new NextResponse(
        JSON.stringify({
          error: 'Forbidden',
          message: 'Security policy violation detected.',
          code: 'SECURITY_BLOCKED',
        }),
        {
          status: 403,
          headers: {
            'Content-Type': 'application/json',
            'X-Content-Type-Options': 'nosniff',
          },
        }
      );
    }
  }

  // 2. Anti-CSRF & Origin verification for state-changing HTTP methods
  if (['POST', 'PUT', 'DELETE', 'PATCH'].includes(request.method)) {
    const origin = request.headers.get('origin');
    const host = request.headers.get('host');

    if (origin && host) {
      try {
        const originUrl = new URL(origin);
        const originHost = originUrl.host;

        // Allow localhost development or matching production host
        const isAllowedOrigin =
          originHost === host ||
          originHost.startsWith('localhost:') ||
          originHost.startsWith('127.0.0.1:') ||
          originHost.endsWith('.dailybasket.com') ||
          originHost === 'dailybasket.com';

        if (!isAllowedOrigin) {
          return new NextResponse(
            JSON.stringify({
              error: 'Forbidden',
              message: 'Cross-Origin Request Blocked by Anti-CSRF Policy.',
              code: 'CSRF_BLOCKED',
            }),
            {
              status: 403,
              headers: {
                'Content-Type': 'application/json',
                'X-Content-Type-Options': 'nosniff',
              },
            }
          );
        }
      } catch {
        return new NextResponse(
          JSON.stringify({ error: 'Bad Request', message: 'Malformed Origin Header' }),
          { status: 400 }
        );
      }
    }
  }

  // 3. Clone response and apply high-security headers
  const response = NextResponse.next();

  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  response.headers.set('X-DNS-Prefetch-Control', 'on');
  response.headers.set('X-Permitted-Cross-Domain-Policies', 'none');
  response.headers.set('Cross-Origin-Opener-Policy', 'same-origin');
  response.headers.set('Cross-Origin-Resource-Policy', 'same-origin');
  response.headers.set(
    'Permissions-Policy',
    'camera=(), microphone=(), geolocation=(self), payment=(self)'
  );

  return response;
}

export const config = {
  matcher: [
    /*
     * Match all request paths except static files and Next.js internals:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - images/ (public images)
     */
    '/((?!_next/static|_next/image|favicon.ico|images/).*)',
  ],
};
