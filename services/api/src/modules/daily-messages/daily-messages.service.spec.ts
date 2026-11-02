import { Test, TestingModule } from '@nestjs/testing';
import { DailyMessagesService } from './daily-messages.service';
import { PrismaService } from '../../database/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';

describe('DailyMessagesService', () => {
  let service: DailyMessagesService;
  let notificationsService: NotificationsService;

  const mockPrisma = {
    dailyMessageCampaign: {
      create: jest.fn().mockImplementation((args) =>
        Promise.resolve({
          id: 'camp_123',
          ...args.data,
          createdAt: new Date(),
          updatedAt: new Date(),
        }),
      ),
      findFirst: jest.fn().mockResolvedValue({
        id: 'camp_123',
        title: 'Morning Flash Deals ⚡',
        body: 'Up to 30% off farm vegetables until 11 AM!',
        contentHash: 'hash_123',
        audienceRole: 'CUSTOMER',
        enabled: true,
        createdAt: new Date(),
      }),
      findUnique: jest.fn().mockResolvedValue({
        id: 'camp_123',
        title: 'Morning Flash Deals ⚡',
        body: 'Up to 30% off farm vegetables until 11 AM!',
        contentHash: 'hash_123',
        audienceRole: 'CUSTOMER',
        enabled: true,
      }),
      findMany: jest.fn().mockResolvedValue([
        {
          id: 'camp_123',
          title: 'Morning Flash Deals ⚡',
          body: 'Up to 30% off farm vegetables until 11 AM!',
          _count: { outboxRows: 5 },
        },
      ]),
    },
    dailyMessageOutbox: {
      create: jest.fn().mockResolvedValue({ id: 'outbox_1' }),
    },
    user: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'usr_1', email: 'user1@example.com' },
        { id: 'usr_2', email: 'user2@example.com' },
      ]),
    },
  };

  const mockNotificationsService = {
    sendPushNotification: jest.fn().mockResolvedValue({ success: true, messageId: 'msg_123' }),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DailyMessagesService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: NotificationsService, useValue: mockNotificationsService },
      ],
    }).compile();

    service = module.get<DailyMessagesService>(DailyMessagesService);
    notificationsService = module.get<NotificationsService>(NotificationsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('computeContentHash', () => {
    it('should compute deterministic sha256 hash', () => {
      const hash1 = service.computeContentHash('Morning Special', 'Get 20% off milk');
      const hash2 = service.computeContentHash('Morning Special', 'Get 20% off milk');
      const hash3 = service.computeContentHash('Evening Special', 'Get 20% off milk');

      expect(hash1).toEqual(hash2);
      expect(hash1).not.toEqual(hash3);
      expect(hash1.length).toBe(64);
    });
  });

  describe('createCampaign', () => {
    it('should create and return a campaign with contentHash', async () => {
      const result = await service.createCampaign({
        title: 'Fresh Bread & Eggs 🥖',
        body: 'Start your breakfast with warm artisanal bakes delivered in 10 mins.',
        audienceRole: 'CUSTOMER',
        enabled: true,
      });

      expect(result).toHaveProperty('id', 'camp_123');
      expect(result).toHaveProperty('contentHash');
      expect(mockPrisma.dailyMessageCampaign.create).toHaveBeenCalled();
    });
  });

  describe('getTodaysDailyMessage', () => {
    it('should return the active campaign from database', async () => {
      const result = await service.getTodaysDailyMessage();

      expect(result).toHaveProperty('id', 'camp_123');
      expect(result.title).toBe('Morning Flash Deals ⚡');
      expect(result.body).toContain('30% off');
    });

    it('should return enterprise default fallback if no campaigns in DB', async () => {
      (mockPrisma.dailyMessageCampaign.findFirst as jest.Mock).mockResolvedValueOnce(null);

      const result = await service.getTodaysDailyMessage();

      expect(result.id).toBe('campaign_default');
      expect(result.title).toBe('Fresh Morning Harvest 🌿');
      expect(result.isDefaultFallback).toBe(true);
    });
  });

  describe('dispatchDailyMessages', () => {
    it('should query target users, create outbox rows, and dispatch push notifications', async () => {
      const result = await service.dispatchDailyMessages('camp_123');

      expect(result.success).toBe(true);
      expect(result.deliveredCount).toBe(2);
      expect(mockNotificationsService.sendPushNotification).toHaveBeenCalledTimes(2);
      expect(mockPrisma.dailyMessageOutbox.create).toHaveBeenCalledTimes(2);
    });
  });

  describe('listCampaigns', () => {
    it('should list campaigns with delivery metrics', async () => {
      const result = await service.listCampaigns();

      expect(Array.isArray(result)).toBe(true);
      expect(result.length).toBe(1);
      expect(result[0]._count.outboxRows).toBe(5);
    });
  });
});

