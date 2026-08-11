import { Test, TestingModule } from '@nestjs/testing';
import { QueueProcessor } from './queue.processor';
import { ConfigService } from '@nestjs/config';
import { EventsGateway } from '../events/events.gateway';
import { NotificationsService } from '../notifications/notifications.service';
import { EmailService } from '../email/email.service';

describe('QueueProcessor BullMQ Unit Tests', () => {
  let processor: QueueProcessor;

  const mockConfigService = {
    get: jest.fn().mockReturnValue('localhost'),
  };

  const mockEventsGateway = {
    broadcastOrderCreated: jest.fn(),
    broadcastOrderPacking: jest.fn(),
    broadcastInventoryUpdate: jest.fn(),
    broadcastDashboardTick: jest.fn(),
  };

  const mockNotificationsService = {
    sendPushNotification: jest.fn().mockResolvedValue(true),
  };

  const mockEmailService = {
    sendEmail: jest.fn().mockResolvedValue(true),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        QueueProcessor,
        { provide: ConfigService, useValue: mockConfigService },
        { provide: EventsGateway, useValue: mockEventsGateway },
        { provide: NotificationsService, useValue: mockNotificationsService },
        { provide: EmailService, useValue: mockEmailService },
      ],
    }).compile();

    processor = module.get<QueueProcessor>(QueueProcessor);
  });

  it('should enqueue job and return generated jobId string', async () => {
    const jobId = await processor.enqueueJob('ORDER', { id: 'ord_1001' });
    expect(jobId).toBeDefined();
    expect(jobId).toContain('job_');
  });

  it('should maintain DLQ metrics tracking', () => {
    const dlq = processor.getDlqMetrics();
    expect(dlq.count).toBe(0);
    expect(Array.isArray(dlq.jobs)).toBe(true);
  });
});
