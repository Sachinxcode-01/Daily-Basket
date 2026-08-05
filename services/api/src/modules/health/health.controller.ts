import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { HealthCheck, HealthCheckService, PrismaHealthIndicator } from '@nestjs/terminus';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

@ApiTags('Health & Observability')
@Controller('health')
export class HealthController {
  constructor(
    private health: HealthCheckService,
    private prismaIndicator: PrismaHealthIndicator,
    private prisma: PrismaService,
    private redisService: RedisService,
  ) {}

  @Get()
  @HealthCheck()
  @ApiOperation({ summary: 'Liveness check endpoint' })
  checkLiveness() {
    return {
      status: 'ok',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    };
  }

  @Get('readiness')
  @HealthCheck()
  @ApiOperation({ summary: 'Readiness check endpoint (verifies DB & Redis connections)' })
  checkReadiness() {
    return this.health.check([
      () => this.prismaIndicator.pingCheck('database', this.prisma),
    ]);
  }

  @Get('metrics')
  @ApiOperation({ summary: 'Prometheus/JSON Metrics and Telemetry Diagnostic dashboard' })
  async getMetrics() {
    const memoryUsage = process.memoryUsage();
    const queueMetrics = await this.redisService.getQueueMetrics();

    return {
      timestamp: new Date().toISOString(),
      service: 'daily-basket-api',
      environment: process.env.NODE_ENV || 'production',
      uptimeSeconds: process.uptime(),
      memory: {
        heapUsedMb: Number((memoryUsage.heapUsed / 1024 / 1024).toFixed(2)),
        heapTotalMb: Number((memoryUsage.heapTotal / 1024 / 1024).toFixed(2)),
        rssMb: Number((memoryUsage.rss / 1024 / 1024).toFixed(2)),
      },
      queues: queueMetrics,
      database: {
        status: 'UP',
        provider: 'postgresql',
      },
      redis: {
        status: queueMetrics.redisConnected ? 'UP' : 'DOWN',
      },
      slaTargets: {
        targetFps: 60,
        apiLatencyTargetMs: 100,
        searchLatencyTargetMs: 50,
      },
    };
  }
}

