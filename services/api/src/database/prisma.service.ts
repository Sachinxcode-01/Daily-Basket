import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '../../node_modules/.prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(PrismaService.name);

  constructor() {
    super({
      log: [
        { emit: 'event', level: 'query' },
        { emit: 'stdout', level: 'error' },
        { emit: 'stdout', level: 'warn' },
      ],
    });
  }

  async onModuleInit() {
    await this.$connect();
    this.logger.log('⚡ Prisma ORM connected to PostgreSQL pool');

    // Register query performance middleware
    this.$use(async (params, next) => {
      const start = Date.now();
      const result = await next(params);
      const duration = Date.now() - start;

      if (duration > 100) {
        this.logger.warn(
          `🐢 SLOW DB QUERY [${duration}ms]: ${params.model}.${params.action}`,
        );
      }
      return result;
    });
  }

  async onModuleDestroy() {
    await this.$disconnect();
    this.logger.log('Prisma ORM disconnected');
  }
}

