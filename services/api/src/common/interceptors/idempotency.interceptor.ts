import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  ConflictException,
  Logger,
} from '@nestjs/common';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';
import { RedisService } from '../../modules/redis/redis.service';

@Injectable()
export class IdempotencyInterceptor implements NestInterceptor {
  private readonly logger = new Logger(IdempotencyInterceptor.name);

  constructor(private readonly redisService: RedisService) {}

  async intercept(context: ExecutionContext, next: CallHandler): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest();

    // Idempotency applies to state-mutating requests (POST, PUT, PATCH)
    if (!['POST', 'PUT', 'PATCH'].includes(request.method)) {
      return next.handle();
    }

    const idempotencyKey = request.headers['x-idempotency-key'] as string;
    if (!idempotencyKey) {
      return next.handle();
    }

    const redisKey = `dailybasket:idempotency:${idempotencyKey}`;

    // Try acquiring lock / checking cached result
    const existing = await this.redisService.get<any>(redisKey);
    if (existing) {
      if (existing.status === 'PROCESSING') {
        throw new ConflictException('A request with this X-Idempotency-Key is currently being processed.');
      }
      this.logger.debug(`🔁 IDEMPOTENCY REPLAY [${idempotencyKey}]`);
      const response = context.switchToHttp().getResponse();
      response.setHeader('X-Idempotent-Replay', 'true');
      return of(existing.response);
    }

    // Store temporary processing lock (TTL 60s)
    await this.redisService.set(redisKey, { status: 'PROCESSING' }, 60);

    return next.handle().pipe(
      tap(async (responseBody) => {
        // Store completed response (TTL 24 hours)
        await this.redisService.set(
          redisKey,
          { status: 'COMPLETED', response: responseBody },
          86400,
        );
      }),
    );
  }
}
