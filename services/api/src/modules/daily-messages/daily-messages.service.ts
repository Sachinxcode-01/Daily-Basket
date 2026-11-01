import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { NotificationsService } from '../notifications/notifications.service';
import { CreateDailyMessageCampaignDto } from './daily-messages.dto';
import * as crypto from 'crypto';

export interface DailyMessageResponse {
  id: string;
  title: string;
  body: string;
  contentHash: string;
  audienceRole: string;
  enabled: boolean;
  createdAt: string;
  isDefaultFallback?: boolean;
}

@Injectable()
export class DailyMessagesService implements OnModuleInit {
  private readonly logger = new Logger(DailyMessagesService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly notificationsService: NotificationsService,
  ) {}

  async onModuleInit() {
    this.logger.log('📢 DailyMessagesService initialized. Registering 08:00 daily message dispatch hook.');
    this.scheduleDailyDispatchLoop();
  }

  /**
   * Schedules or verifies the 08:00 server-time morning marketing loop.
   */
  private scheduleDailyDispatchLoop() {
    const now = new Date();
    const nextEightAm = new Date();
    nextEightAm.setHours(8, 0, 0, 0);

    if (now.getTime() >= nextEightAm.getTime()) {
      nextEightAm.setDate(nextEightAm.getDate() + 1);
    }

    const msUntilEightAm = nextEightAm.getTime() - now.getTime();
    this.logger.log(`⏰ Next scheduled Daily Message job in ${(msUntilEightAm / 1000 / 60).toFixed(1)} minutes`);

    // In-process timer that invokes dispatchDailyMessages daily
    setTimeout(() => {
      this.dispatchDailyMessages().catch((err) =>
        this.logger.error(`Failed to execute scheduled 08:00 daily message: ${err.message}`),
      );
      // Recursively set next 24-hour interval
      setInterval(() => {
        this.dispatchDailyMessages().catch((err) =>
          this.logger.error(`Failed to execute recurring daily message: ${err.message}`),
        );
      }, 24 * 60 * 60 * 1000);
    }, msUntilEightAm);
  }

  /**
   * Computes deterministic SHA-256 content hash for a campaign title and body.
   */
  computeContentHash(title: string, body: string): string {
    return crypto.createHash('sha256').update(`${title.trim()}:${body.trim()}`).digest('hex');
  }

  /**
   * Create a new Daily Message marketing campaign.
   */
  async createCampaign(dto: CreateDailyMessageCampaignDto) {
    const contentHash = this.computeContentHash(dto.title, dto.body);

    const campaign = await (this.prisma as any).dailyMessageCampaign.create({
      data: {
        title: dto.title,
        body: dto.body,
        contentHash,
        audienceRole: dto.audienceRole || 'CUSTOMER',
        enabled: dto.enabled !== undefined ? dto.enabled : true,
        segmentOverrides: dto.segmentOverrides || {},
      },
    });

    this.logger.log(`Created DailyMessageCampaign #${campaign.id} [${contentHash.substring(0, 10)}]`);
    return campaign;
  }

  /**
   * Fetch today's active Daily Message for home-screen banners and cold-start caching.
   */
  async getTodaysDailyMessage(userId?: string): Promise<DailyMessageResponse> {
    try {
      const activeCampaign = await (this.prisma as any).dailyMessageCampaign.findFirst({
        where: { enabled: true },
        orderBy: { createdAt: 'desc' },
      });

      if (activeCampaign) {
        return {
          id: activeCampaign.id,
          title: activeCampaign.title,
          body: activeCampaign.body,
          contentHash: activeCampaign.contentHash || this.computeContentHash(activeCampaign.title, activeCampaign.body),
          audienceRole: activeCampaign.audienceRole,
          enabled: activeCampaign.enabled,
          createdAt: activeCampaign.createdAt.toISOString(),
        };
      }
    } catch (err: any) {
      this.logger.warn(`Could not read daily message campaign from DB: ${err.message}`);
    }

    // Default enterprise fallback campaign
    const defaultTitle = 'Fresh Morning Harvest 🌿';
    const defaultBody = 'Crisp organic greens, farm-fresh milk & bakery essentials delivered in 10 minutes.';
    return {
      id: 'campaign_default',
      title: defaultTitle,
      body: defaultBody,
      contentHash: this.computeContentHash(defaultTitle, defaultBody),
      audienceRole: 'CUSTOMER',
      enabled: true,
      createdAt: new Date().toISOString(),
      isDefaultFallback: true,
    };
  }

  /**
   * List all campaigns with delivery metrics.
   */
  async listCampaigns() {
    try {
      const campaigns = await (this.prisma as any).dailyMessageCampaign.findMany({
        orderBy: { createdAt: 'desc' },
        include: {
          _count: {
            select: { outboxRows: true },
          },
        },
      });
      return campaigns;
    } catch {
      return [];
    }
  }

  /**
   * Dispatches the active Daily Message campaign across target customer cohorts.
   */
  async dispatchDailyMessages(campaignId?: string) {
    this.logger.log(`Initiating daily message cohort dispatch (campaignId: ${campaignId || 'latest'})...`);

    let campaign: any = null;
    try {
      if (campaignId) {
        campaign = await (this.prisma as any).dailyMessageCampaign.findUnique({
          where: { id: campaignId },
        });
      } else {
        campaign = await (this.prisma as any).dailyMessageCampaign.findFirst({
          where: { enabled: true },
          orderBy: { createdAt: 'desc' },
        });
      }
    } catch (e: any) {
      this.logger.warn(`Prisma error fetching campaign: ${e.message}`);
    }

    if (!campaign) {
      const fallback = await this.getTodaysDailyMessage();
      campaign = {
        id: fallback.id,
        title: fallback.title,
        body: fallback.body,
        contentHash: fallback.contentHash,
        audienceRole: 'CUSTOMER',
      };
    }

    // Query target audience
    let recipients: { id: string; email?: string }[] = [];
    try {
      recipients = await this.prisma.user.findMany({
        where: { role: (campaign.audienceRole as any) || 'CUSTOMER' },
        select: { id: true, email: true },
        take: 200, // Safe batch limit per cycle
      });
    } catch {
      recipients = [{ id: 'usr_default_demo' }];
    }

    this.logger.log(`Found ${recipients.length} target recipients for Daily Message: "${campaign.title}"`);

    let deliveredCount = 0;
    for (const recipient of recipients) {
      try {
        // Record outbox row
        if (campaign.id && campaign.id !== 'campaign_default') {
          await (this.prisma as any).dailyMessageOutbox.create({
            data: {
              campaignId: campaign.id,
              userId: recipient.id,
              status: 'SENT',
              deliveredAt: new Date(),
            },
          });
        }

        // Reuse NotificationsService to send push + persist InAppNotification
        await this.notificationsService.sendPushNotification({
          userId: recipient.id,
          title: campaign.title,
          body: campaign.body,
          data: {
            type: 'PROMO',
            category: 'DAILY_MESSAGE',
            campaignId: campaign.id,
            contentHash: campaign.contentHash,
          },
        });
        deliveredCount++;
      } catch (err: any) {
        this.logger.warn(`Failed to dispatch daily message to recipient ${recipient.id}: ${err.message}`);
      }
    }

    return {
      success: true,
      campaignId: campaign.id,
      title: campaign.title,
      totalTargeted: recipients.length,
      deliveredCount,
      dispatchedAt: new Date().toISOString(),
    };
  }
}
