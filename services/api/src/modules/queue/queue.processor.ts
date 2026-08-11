import { Injectable, Logger, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Queue, Worker, Job } from 'bullmq';
import { EventsGateway } from '../events/events.gateway';
import { NotificationsService } from '../notifications/notifications.service';
import { EmailService } from '../email/email.service';

export interface QueueJobPayload {
  id: string;
  type:
    | 'ORDER'
    | 'INVENTORY'
    | 'NOTIFICATION'
    | 'EMAIL'
    | 'AI'
    | 'REPORTS'
    | 'ANALYTICS'
    | 'MEDIA'
    | 'REFUND'
    | 'COUPON';
  payload: any;
  priority?: number; // 1 (high) to 10 (low)
  delayMs?: number;
  attempts?: number;
  createdAt: Date;
}

@Injectable()
export class QueueProcessor implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(QueueProcessor.name);
  private bullQueue: Queue;
  private worker: Worker;

  private readonly dlqJobs: any[] = [];

  constructor(
    private readonly configService: ConfigService,
    private readonly eventsGateway: EventsGateway,
    private readonly notificationsService: NotificationsService,
    private readonly emailService: EmailService,
  ) {}

  async onModuleInit() {
    const host = this.configService.get<string>('redis.host', 'localhost');
    const port = this.configService.get<number>('redis.port', 6379);

    const connection = { host, port };

    // Initialize BullMQ Queue
    this.bullQueue = new Queue('dailybasket-core-queue', {
      connection,
      defaultJobOptions: {
        attempts: 3,
        backoff: {
          type: 'exponential',
          delay: 1000,
        },
        removeOnComplete: 100,
        removeOnFail: 500,
      },
    });

    // Initialize BullMQ Worker
    this.worker = new Worker(
      'dailybasket-core-queue',
      async (job: Job<QueueJobPayload>) => {
        this.logger.log(`⚙️ [BullMQ Worker] Processing Job #${job.id} (${job.data.type})`);
        await this.executeJob(job.data);
      },
      {
        connection,
        concurrency: 10, // Worker auto-scaling concurrency setting
      },
    );

    this.worker.on('failed', (job, err) => {
      this.logger.error(`❌ [BullMQ Job Failed] Job #${job?.id} (${job?.data?.type}): ${err.message}`);
      if (job && job.attemptsMade >= (job.opts.attempts || 3)) {
        this.logger.warn(`💀 [Dead Letter Queue] Pushing job #${job.id} to DLQ storage`);
        this.dlqJobs.push({ job: job.data, error: err.message, failedAt: new Date() });
      }
    });

    this.logger.log(`⚡ BullMQ Queue & Worker initialized at ${host}:${port} with concurrency=10`);
  }

  async onModuleDestroy() {
    if (this.worker) await this.worker.close();
    if (this.bullQueue) await this.bullQueue.close();
  }

  async enqueueJob(
    type: QueueJobPayload['type'],
    payload: any,
    options?: { priority?: number; delayMs?: number },
  ): Promise<string> {
    const jobId = `job_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`;
    const data: QueueJobPayload = {
      id: jobId,
      type,
      payload,
      priority: options?.priority || 5,
      delayMs: options?.delayMs || 0,
      createdAt: new Date(),
    };

    if (this.bullQueue) {
      await this.bullQueue.add(type, data, {
        priority: data.priority,
        delay: data.delayMs,
      });
      this.logger.log(`📥 [BullMQ Enqueued] Job [${jobId}] Type: ${type}`);
    } else {
      // Fallback in-process execution
      setImmediate(() => this.executeJob(data));
    }
    return jobId;
  }

  private async executeJob(job: QueueJobPayload) {
    switch (job.type) {
      case 'ORDER':
        await this.handleOrderJob(job.payload);
        break;
      case 'INVENTORY':
        await this.handleInventoryJob(job.payload);
        break;
      case 'NOTIFICATION':
        await this.handleNotificationJob(job.payload);
        break;
      case 'EMAIL':
        await this.handleEmailJob(job.payload);
        break;
      case 'AI':
        await this.handleAiJob(job.payload);
        break;
      case 'REPORTS':
        await this.handleReportsJob(job.payload);
        break;
      case 'ANALYTICS':
        await this.handleAnalyticsJob(job.payload);
        break;
      case 'MEDIA':
        await this.handleMediaJob(job.payload);
        break;
      case 'REFUND':
        await this.handleRefundJob(job.payload);
        break;
      case 'COUPON':
        await this.handleCouponJob(job.payload);
        break;
    }
  }

  private async handleOrderJob(payload: any) {
    this.eventsGateway.broadcastOrderCreated(payload);
    this.eventsGateway.broadcastOrderPacking(payload);
  }

  private async handleInventoryJob(payload: any) {
    this.eventsGateway.broadcastInventoryUpdate(payload.productId, payload.newStock, payload.isAvailable);
  }

  private async handleNotificationJob(payload: any) {
    if (payload.userId && payload.title && payload.body) {
      await this.notificationsService.sendPushNotification({
        userId: payload.userId,
        title: payload.title,
        body: payload.body,
        data: payload.data,
      });
    }
  }

  private async handleEmailJob(payload: any) {
    if (payload.to && payload.subject) {
      await this.emailService.sendEmail({
        to: payload.to,
        subject: payload.subject,
        template: payload.template || 'ORDER_CONFIRMATION',
        data: payload.data || {},
      });
    }
  }

  private async handleAiJob(payload: any) {
    this.logger.log(`AI background embedding & insight processing for product ${payload.productId}`);
  }

  private async handleReportsJob(payload: any) {
    this.eventsGateway.broadcastDashboardTick({ action: 'DAILY_REPORT_GENERATED', report: payload });
  }

  private async handleAnalyticsJob(payload: any) {
    this.eventsGateway.broadcastDashboardTick({ action: 'ANALYTICS_AGGREGATION', data: payload });
  }

  private async handleMediaJob(payload: any) {
    this.logger.log(`Async image optimization worker processing image: ${payload.imageUrl}`);
  }

  private async handleRefundJob(payload: any) {
    this.eventsGateway.broadcastDashboardTick({ action: 'REFUND_PROCESSED', refund: payload });
  }

  private async handleCouponJob(payload: any) {
    this.eventsGateway.broadcastCouponCreated(payload);
  }

  public getDlqMetrics(): { count: number; jobs: any[] } {
    return {
      count: this.dlqJobs.length,
      jobs: this.dlqJobs.slice(-20),
    };
  }
}
