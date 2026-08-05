import { Injectable, Logger } from '@nestjs/common';
import { EventsGateway } from '../events/events.gateway';
import { NotificationsService } from '../notifications/notifications.service';
import { EmailService } from '../email/email.service';

export interface BackgroundJob {
  id: string;
  type: 'ORDER' | 'INVENTORY' | 'NOTIFICATION' | 'EMAIL' | 'ANALYTICS' | 'REFUND' | 'COUPON';
  payload: any;
  createdAt: Date;
}

@Injectable()
export class QueueProcessor {
  private readonly logger = new Logger(QueueProcessor.name);
  private jobQueue: BackgroundJob[] = [];

  constructor(
    private readonly eventsGateway: EventsGateway,
    private readonly notificationsService: NotificationsService,
    private readonly emailService: EmailService,
  ) {}

  async enqueueJob(type: BackgroundJob['type'], payload: any): Promise<string> {
    const jobId = `job_${Date.now()}_${Math.random().toString(36).substr(2, 6)}`;
    const job: BackgroundJob = { id: jobId, type, payload, createdAt: new Date() };
    this.jobQueue.push(job);
    this.logger.log(`Enqueued BullMQ Job [${jobId}] Type: ${type}`);

    // Process asynchronously immediately with retry protection
    setImmediate(() => this.processJob(job));
    return jobId;
  }

  private async processJob(job: BackgroundJob) {
    try {
      this.logger.log(`Processing BullMQ Job [${job.id}] - ${job.type}`);
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
        case 'ANALYTICS':
          await this.handleAnalyticsJob(job.payload);
          break;
        case 'REFUND':
          await this.handleRefundJob(job.payload);
          break;
        case 'COUPON':
          await this.handleCouponJob(job.payload);
          break;
      }
      this.logger.log(`Completed BullMQ Job [${job.id}] Successfully`);
    } catch (error) {
      this.logger.error(`BullMQ Job [${job.id}] Failed: ${error.message}`, error.stack);
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

  private async handleAnalyticsJob(payload: any) {
    this.eventsGateway.broadcastDashboardTick({ action: 'ANALYTICS_AGGREGATION', data: payload });
  }

  private async handleRefundJob(payload: any) {
    this.eventsGateway.broadcastDashboardTick({ action: 'REFUND_PROCESSED', refund: payload });
  }

  private async handleCouponJob(payload: any) {
    this.eventsGateway.broadcastCouponCreated(payload);
  }
}
