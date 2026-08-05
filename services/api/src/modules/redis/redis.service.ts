import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

export interface OrderQueueJob {
  jobId: string;
  orderId: string;
  userId: string;
  timestamp: number;
  payload: any;
}

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(RedisService.name);
  private client: Redis;
  private subscriberClient: Redis;
  private isProcessingQueue = false;

  constructor(private configService: ConfigService) {}

  onModuleInit() {
    const host = this.configService.get<string>('redis.host', 'localhost');
    const port = this.configService.get<number>('redis.port', 6379);

    this.client = new Redis({ host, port, lazyConnect: true, retryStrategy: (times) => Math.min(times * 100, 3000) });
    this.subscriberClient = new Redis({ host, port, lazyConnect: true });

    this.client.connect().then(() => {
      this.logger.log(`⚡ Production Redis Connected at ${host}:${port}`);
      this.startQueueWorker();
    }).catch((err) => {
      this.logger.warn(`Redis connection deferred: ${err.message}`);
    });
  }

  onModuleDestroy() {
    this.isProcessingQueue = false;
    if (this.client) this.client.disconnect();
    if (this.subscriberClient) this.subscriberClient.disconnect();
  }

  // ─── Basic Key-Value Operations ────────────────────────────────────────────
  async get<T>(key: string): Promise<T | null> {
    try {
      const data = await this.client.get(key);
      return data ? JSON.parse(data) : null;
    } catch {
      return null;
    }
  }

  async set(key: string, value: any, ttlSeconds?: number): Promise<void> {
    try {
      const serialized = JSON.stringify(value);
      if (ttlSeconds) {
        await this.client.set(key, serialized, 'EX', ttlSeconds);
      } else {
        await this.client.set(key, serialized);
      }
    } catch (err: any) {
      this.logger.error(`Redis set failed for key ${key}: ${err.message}`);
    }
  }

  async del(key: string): Promise<void> {
    try {
      await this.client.del(key);
    } catch {}
  }

  async delByPattern(pattern: string): Promise<void> {
    try {
      const keys = await this.client.keys(pattern);
      if (keys.length > 0) {
        await this.client.del(...keys);
      }
    } catch {}
  }

  // ─── Distributed Redlock Algorithm for Inventory Locking ──────────────────
  async acquireLock(resource: string, ttlSeconds = 10): Promise<string | null> {
    const lockKey = `dailybasket:lock:${resource}`;
    const token = Math.random().toString(36).substring(2) + Date.now().toString(36);
    try {
      const result = await this.client.set(lockKey, token, 'EX', ttlSeconds, 'NX');
      if (result === 'OK') {
        this.logger.debug(`🔒 Lock acquired for resource: ${resource} (token: ${token})`);
        return token;
      }
      return null;
    } catch (err: any) {
      this.logger.error(`Failed to acquire lock for ${resource}: ${err.message}`);
      return null;
    }
  }

  async releaseLock(resource: string, token: string): Promise<boolean> {
    const lockKey = `dailybasket:lock:${resource}`;
    const luaScript = `
      if redis.call("get", KEYS[1]) == ARGV[1] then
        return redis.call("del", KEYS[1])
      else
        return 0
      end
    `;
    try {
      const result = await this.client.eval(luaScript, 1, lockKey, token);
      if (result === 1) {
        this.logger.debug(`🔓 Lock released for resource: ${resource}`);
        return true;
      }
      return false;
    } catch (err: any) {
      this.logger.error(`Failed to release lock for ${resource}: ${err.message}`);
      return false;
    }
  }

  // ─── Production BullMQ-style Redis Queue Producer/Consumer ────────────────
  async enqueueOrderProcessing(job: OrderQueueJob): Promise<void> {
    const queueKey = 'dailybasket:queue:orders';
    try {
      await this.client.rpush(queueKey, JSON.stringify(job));
      this.logger.log(`📥 Enqueued async order job ${job.jobId} for Order #${job.orderId}`);
      
      // Publish PubSub event for WebSocket Gateway
      await this.publishEvent('events:order:queued', { orderId: job.orderId, status: 'QUEUED' });
    } catch (err: any) {
      this.logger.error(`Failed to enqueue order job ${job.jobId}: ${err.message}`);
    }
  }

  private async startQueueWorker() {
    this.isProcessingQueue = true;
    const queueKey = 'dailybasket:queue:orders';

    while (this.isProcessingQueue) {
      try {
        const rawJob = await this.client.lpop(queueKey);
        if (rawJob) {
          const job: OrderQueueJob = JSON.parse(rawJob);
          this.logger.log(`⚙️ Processing async order queue job ${job.jobId} for Order #${job.orderId}...`);
          
          // Simulate async processing (inventory allocation, dark store picker dispatch)
          await new Promise((res) => setTimeout(res, 300));

          await this.publishEvent('events:order:processed', {
            orderId: job.orderId,
            status: 'DISPATCHED_TO_DARK_STORE',
            timestamp: Date.now(),
          });

          this.logger.log(`✅ Order queue job ${job.jobId} completed successfully.`);
        } else {
          // Sleep briefly if queue is empty
          await new Promise((res) => setTimeout(res, 1000));
        }
      } catch (err: any) {
        this.logger.error(`Queue worker error: ${err.message}`);
        await new Promise((res) => setTimeout(res, 2000));
      }
    }
  }

  // ─── Redis Pub/Sub Event Producer ──────────────────────────────────────────
  async publishEvent(channel: string, payload: any): Promise<void> {
    try {
      await this.client.publish(channel, JSON.stringify(payload));
    } catch (err: any) {
      this.logger.error(`Pub/Sub publish error on ${channel}: ${err.message}`);
    }
  }

  // ─── Queue Health Diagnostics ──────────────────────────────────────────────
  async getQueueMetrics(): Promise<{ pendingOrders: number; redisConnected: boolean }> {
    try {
      const pendingOrders = await this.client.llen('dailybasket:queue:orders');
      const ping = await this.client.ping();
      return {
        pendingOrders,
        redisConnected: ping === 'PONG',
      };
    } catch {
      return {
        pendingOrders: 0,
        redisConnected: false,
      };
    }
  }
}
