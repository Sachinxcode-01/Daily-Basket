import { Injectable, NestMiddleware, ForbiddenException, Logger } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class BotDetectionMiddleware implements NestMiddleware {
  private readonly logger = new Logger(BotDetectionMiddleware.name);

  private readonly knownBadUserAgents = [
    'sqlmap',
    'nikto',
    'curb',
    'python-requests',
    'go-http-client',
    'libwww-perl',
    'zgrab',
    'masscan',
    'w3af',
  ];

  use(req: Request, res: Response, next: NextFunction) {
    const userAgent = (req.headers['user-agent'] || '').toLowerCase();

    // Block automated scanner user agents
    for (const badAgent of this.knownBadUserAgents) {
      if (userAgent.includes(badAgent)) {
        this.logger.warn(`🤖 BOT DETECTED & BLOCKED: IP=${req.ip} UA="${userAgent}"`);
        throw new ForbiddenException('Access denied by Security Shield bot protection.');
      }
    }

    next();
  }
}
