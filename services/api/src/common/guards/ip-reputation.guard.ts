import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { RedisService } from '../../modules/redis/redis.service';

@Injectable()
export class IpReputationGuard implements CanActivate {
  private readonly logger = new Logger(IpReputationGuard.name);

  constructor(private readonly redisService: RedisService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const ip = request.ip || request.connection.remoteAddress || '127.0.0.1';

    const blockedKey = `dailybasket:security:blocked_ip:${ip}`;
    const isBlocked = await this.redisService.get(blockedKey);

    if (isBlocked) {
      this.logger.warn(`🛑 BLOCKED IP ATTEMPT: ${ip}`);
      throw new ForbiddenException('Your IP address is temporarily blocked due to security policies.');
    }

    return true;
  }
}
