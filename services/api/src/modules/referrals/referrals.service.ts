import { Injectable, BadRequestException } from '@nestjs/common';

@Injectable()
export class ReferralsService {
  private referralData: Map<string, any> = new Map();

  constructor() {
    this.referralData.set('usr_default', {
      referralCode: 'DB-ALEX2026',
      referralLink: 'https://dailybasket.app/invite/DB-ALEX2026',
      totalInvited: 12,
      successfulReferrals: 8,
      pendingReferrals: 4,
      totalEarnedRewards: 800,
      walletBalance: 250,
      referralBonusPerFriend: 100,
      friendDiscount: 100,
      history: [
        {
          id: 'ref_1',
          friendName: 'Priya Sharma',
          friendPhone: '+91 98*** **321',
          status: 'COMPLETED',
          rewardEarned: 100,
          date: '2026-08-02',
        },
        {
          id: 'ref_2',
          friendName: 'Rahul Verma',
          friendPhone: '+91 97*** **654',
          status: 'COMPLETED',
          rewardEarned: 100,
          date: '2026-08-01',
        },
        {
          id: 'ref_3',
          friendName: 'Sneha Patel',
          friendPhone: '+91 96*** **890',
          status: 'PENDING',
          rewardEarned: 0,
          date: '2026-08-03',
        },
      ],
    });
  }

  async getDashboard(userId = 'usr_default') {
    const data = this.referralData.get(userId) || this.referralData.get('usr_default');
    return { success: true, data };
  }

  async getHistory(userId = 'usr_default') {
    const data = (await this.getDashboard(userId)).data;
    return { success: true, data: data.history };
  }

  async shareReferral(userId = 'usr_default', dto: { platform: string }) {
    const data = (await this.getDashboard(userId)).data;
    return {
      success: true,
      platform: dto.platform,
      code: data.referralCode,
      link: data.referralLink,
      message: `Use code ${data.referralCode} to get ₹100 off your first Daily Basket 10-min grocery order! ${data.referralLink}`,
    };
  }

  async redeemReferralCode(userId = 'usr_default', dto: { code: string }) {
    if (!dto.code) throw new BadRequestException('Referral code required');

    return {
      success: true,
      code: dto.code.toUpperCase(),
      rewardValue: 100,
      message: `Referral code ${dto.code.toUpperCase()} redeemed! ₹100 added to your wallet & first order discount applied.`,
    };
  }
}
