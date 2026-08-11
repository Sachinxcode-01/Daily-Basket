import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable, of } from 'rxjs';
import { tap } from 'rxjs/operators';
import { RedisService } from '../../modules/redis/redis.service';
import { CACHE_KEY_METADATA, CACHE_TTL_METADATA } from '../decorators/cache.decorator';

@Injectable()
export class HttpCacheInterceptor implements NestInterceptor {
  private readonly logger = new Logger(HttpCacheInterceptor.name);

  constructor(
    private readonly reflector: Reflector,
    private readonly redisService: RedisService,
  ) {}

  async intercept(context: ExecutionContext, next: CallHandler): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest();

    // Only cache GET requests
    if (request.method !== 'GET') {
      return next.handle();
    }

    const customKey = this.reflector.get<string>(CACHE_KEY_METADATA, context.getHandler());
    const ttl = this.reflector.get<number>(CACHE_TTL_METADATA, context.getHandler()) || 60; // default 60s

    const cacheKey = customKey
      ? `dailybasket:httpcache:${customKey}:${request.url}`
      : `dailybasket:httpcache:${request.url}`;

    try {
      const cachedResponse = await this.redisService.get(cacheKey);
      if (cachedResponse) {
        this.logger.debug(`⚡ CACHE HIT [${request.url}]`);
        const response = context.switchToHttp().getResponse();
        response.setHeader('X-Cache-Status', 'HIT');
        return of(cachedResponse);
      }
    } catch (err: any) {
      this.logger.warn(`Cache read error: ${err.message}`);
    }

    return next.handle().pipe(
      tap(async (responseBody) => {
        if (responseBody) {
          try {
            await this.redisService.set(cacheKey, responseBody, ttl);
            this.logger.debug(`💾 CACHE STORED [${request.url}] (TTL: ${ttl}s)`);
          } catch (err: any) {
            this.logger.warn(`Cache write error: ${err.message}`);
          }
        }
      }),
    );
  }
}
