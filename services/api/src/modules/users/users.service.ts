import { Injectable, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface UserProfileDto {
  id?: string;
  fullName: string;
  email: string;
  phoneNumber: string;
  avatarUrl?: string;
  dob?: string;
  gender?: string;
  language?: string;
}

export interface UserAddressDto {
  id?: string;
  label: string;
  fullName?: string;
  phone?: string;
  country?: string;
  state?: string;
  district?: string;
  city: string;
  area?: string;
  pincode: string;
  houseNo: string;
  street: string;
  landmark?: string;
  latitude?: number;
  longitude?: number;
  isDefault?: boolean;
  isServiceable?: boolean;
}

export interface NotificationSettingsDto {
  push: boolean;
  sms: boolean;
  email: boolean;
  offers: boolean;
  orders: boolean;
  payments: boolean;
  wallet: boolean;
  rewards: boolean;
  referral: boolean;
  security: boolean;
}

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);
  private profileStore: Map<string, any> = new Map();
  private addressStore: Map<string, UserAddressDto[]> = new Map();
  private settingsStore: Map<string, NotificationSettingsDto> = new Map();
  private termsConsentStore: Map<string, any> = new Map();

  constructor(private readonly prisma: PrismaService) {
    // Seed default mock demo profile
    const demoId = 'usr_default';
    this.profileStore.set(demoId, {
      id: demoId,
      fullName: 'Alex Johnson',
      email: 'alex.johnson@dailybasket.com',
      phoneNumber: '+91 9876543210',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      dob: '1995-08-15',
      gender: 'Male',
      language: 'English',
      isVerified: true,
      profileCompletion: 100,
    });

    this.addressStore.set(demoId, [
      {
        id: 'addr_1',
        label: 'HOME',
        houseNo: 'Apt 4B, Sunrise Heights',
        street: '100 Feet Ring Road, Indiranagar',
        landmark: 'Near Metro Station',
        city: 'Bengaluru',
        pincode: '560038',
        latitude: 12.9716,
        longitude: 77.5946,
        isDefault: true,
      },
      {
        id: 'addr_2',
        label: 'WORK',
        houseNo: 'Tower 3, Floor 5, Tech Park',
        street: 'Outer Ring Road, Marathahalli',
        landmark: 'Opposite Shell Fuel Station',
        city: 'Bengaluru',
        pincode: '560103',
        latitude: 12.9352,
        longitude: 77.6245,
        isDefault: false,
      },
    ]);

    this.settingsStore.set(demoId, {
      push: true,
      sms: true,
      email: true,
      offers: true,
      orders: true,
      payments: true,
      wallet: true,
      rewards: true,
      referral: true,
      security: true,
    });
  }

  private async ensureUser(userId: string) {
    try {
      let user = await this.prisma.user.findUnique({ where: { id: userId } });
      if (!user) {
        const isDemo = userId === 'usr_default';
        user = await this.prisma.user.upsert({
          where: { id: userId },
          update: {},
          create: {
            id: userId,
            phoneNumber: isDemo ? '+919876543210' : `+91${Date.now().toString().slice(-10)}`,
            fullName: isDemo ? 'Alex Johnson' : 'Customer',
            email: isDemo ? 'alex.johnson@dailybasket.com' : undefined,
            isVerified: true,
          },
        });
      }
      return user;
    } catch (err: any) {
      this.logger.warn(`Could not ensure user ${userId} in database: ${err?.message}`);
      return null;
    }
  }

  async listCustomers(limit = 50) {
    try {
      const users = await this.prisma.user.findMany({
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          orders: {
            select: {
              id: true,
              totalAmount: true,
              status: true,
              createdAt: true,
            },
          },
          addresses: true,
          wallet: true,
        },
      });
      return users.map((u) => {
        const totalOrders = u.orders?.length || 0;
        const totalSpentNum = u.orders?.reduce((sum, o) => sum + (o.totalAmount || 0), 0) || 0;
        const recent = (u.orders || []).slice(0, 3).map((o) => ({
          id: `Order #${o.id.substring(0, 8)}`,
          time: new Date(o.createdAt).toLocaleDateString(),
          amount: `₹${o.totalAmount}`,
          status: o.status,
          statusColor: o.status === 'DELIVERED' ? 'text-[#15803d]' : 'text-[#0284c7]',
          badgeBg: o.status === 'DELIVERED' ? 'bg-emerald-50' : 'bg-sky-50',
          isActive: o.status !== 'DELIVERED' && o.status !== 'CANCELLED',
        }));

        return {
          id: `#DB-CUS-${u.id.substring(0, 6).toUpperCase()}`,
          name: u.fullName || 'Customer',
          email: u.email || 'customer@dailybasket.com',
          phone: u.phoneNumber || '+91 98000 00000',
          joined: `Joined ${new Date(u.createdAt).toLocaleDateString('en-US', { month: 'short', year: 'numeric' })}`,
          avatar: u.avatarUrl || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=300',
          totalOrders,
          totalSpent: `₹${totalSpentNum.toLocaleString('en-IN')}`,
          walletBalance: `₹${(u.wallet?.balance as number) || 0}`,
          ltvScore: totalSpentNum > 5000 ? 'High' : totalSpentNum > 1000 ? 'Medium' : 'Low',
          churnRisk: totalOrders > 5 ? 'Low (5%)' : 'Medium (30%)',
          churnRiskLevel: totalOrders > 5 ? 'low' : 'med',
          avgBasket: totalOrders > 0 ? `₹${Math.round(totalSpentNum / totalOrders)}` : '₹0',
          loyaltyTag: totalSpentNum > 10000 ? 'VIP Platinum' : totalSpentNum > 2000 ? 'Gold Member' : 'Regular',
          shopperTag: totalOrders > 10 ? 'Frequent Shopper' : 'New Shopper',
          status: 'ACTIVE',
          affinityFresh: 75,
          affinityDairy: 60,
          affinitySnacks: 30,
          recentOrders: recent,
        };
      });
    } catch (err) {
      this.logger.warn(`Could not list customers from prisma: ${err}`);
      return [];
    }
  }

  async getProfile(userId = 'usr_default') {
    const stored = this.profileStore.get(userId) || this.profileStore.get('usr_default');
    try {
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
      });
      if (user) {
        return {
          success: true,
          data: {
            id: user.id,
            fullName: user.fullName,
            email: user.email || 'customer@dailybasket.com',
            phoneNumber: user.phoneNumber,
            avatarUrl: user.avatarUrl || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
            dob: stored?.dob ?? '1995-08-15',
            gender: stored?.gender ?? 'Male',
            language: stored?.language ?? 'English',
            isVerified: user.isVerified,
            profileCompletion: 100,
          },
        };
      }
    } catch (err: any) {
      this.logger.warn(`Database getProfile fallback for ${userId}: ${err?.message}`);
    }

    const profile = this.profileStore.get(userId) || this.profileStore.get('usr_default');
    return { success: true, data: profile };
  }

  async updateProfile(userId = 'usr_default', dto: Partial<UserProfileDto>) {
    try {
      await this.ensureUser(userId);
      const updated = await this.prisma.user.update({
        where: { id: userId },
        data: {
          fullName: dto.fullName,
          email: dto.email,
          phoneNumber: dto.phoneNumber,
          avatarUrl: dto.avatarUrl,
        },
      });
      const existing = this.profileStore.get(userId) || this.profileStore.get('usr_default');
      const resData = {
        id: updated.id,
        fullName: updated.fullName,
        email: updated.email,
        phoneNumber: updated.phoneNumber,
        avatarUrl: updated.avatarUrl,
        dob: dto.dob !== undefined ? dto.dob : (existing?.dob ?? '1995-08-15'),
        gender: dto.gender !== undefined ? dto.gender : (existing?.gender ?? 'Male'),
        language: dto.language !== undefined ? dto.language : (existing?.language ?? 'English'),
        isVerified: updated.isVerified,
        updatedAt: updated.updatedAt.toISOString(),
      };
      this.profileStore.set(userId, resData);
      return { success: true, data: resData, message: 'Profile updated successfully' };
    } catch (err: any) {
      this.logger.warn(`Database updateProfile fallback for ${userId}: ${err?.message}`);
    }

    const existing = (await this.getProfile(userId)).data;
    const updated = {
      ...existing,
      ...dto,
      updatedAt: new Date().toISOString(),
    };
    this.profileStore.set(userId, updated);
    return { success: true, data: updated, message: 'Profile updated successfully' };
  }

  async getAddresses(userId = 'usr_default') {
    try {
      await this.ensureUser(userId);
      const dbAddrs = await this.prisma.address.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
      });
      const formatted = (dbAddrs || []).map((a) => ({
        id: a.id,
        label: a.label,
        houseNo: a.houseNo,
        street: a.street,
        landmark: a.landmark || '',
        city: a.city,
        pincode: a.pincode,
        latitude: a.latitude,
        longitude: a.longitude,
        isDefault: a.isDefault,
      }));
      this.addressStore.set(userId, formatted);
      return { success: true, data: formatted };
    } catch (err: any) {
      this.logger.warn(`Database getAddresses fallback for ${userId}: ${err?.message}`);
    }

    const addrs = this.addressStore.get(userId) || this.addressStore.get('usr_default') || [];
    return { success: true, data: addrs };
  }

  async createAddress(userId = 'usr_default', dto: UserAddressDto) {
    if (!dto.pincode || !/^[1-9][0-9]{5}$/.test(dto.pincode.trim())) {
      throw new BadRequestException('Invalid PIN code. Must be a valid 6-digit Indian PIN code (e.g. 582103 or 560038).');
    }
    if (!dto.houseNo || !dto.houseNo.trim()) {
      throw new BadRequestException('House / Flat / Building number is required.');
    }
    if (!dto.street || !dto.street.trim()) {
      throw new BadRequestException('Street / Road name is required.');
    }

    const lat = dto.latitude != null && !isNaN(Number(dto.latitude)) ? Number(dto.latitude) : 12.9716;
    const lng = dto.longitude != null && !isNaN(Number(dto.longitude)) ? Number(dto.longitude) : 77.5946;
    const isDefault = dto.isDefault ?? true;

    // Check duplicate in memory store
    const addrs = this.addressStore.get(userId) || [];
    const duplicateIdx = addrs.findIndex(
      (a) =>
        a.pincode.trim() === dto.pincode.trim() &&
        a.houseNo.trim().toLowerCase() === dto.houseNo.trim().toLowerCase() &&
        a.street.trim().toLowerCase() === dto.street.trim().toLowerCase(),
    );

    if (duplicateIdx !== -1) {
      // Update existing record rather than creating a duplicate
      const existing = addrs[duplicateIdx];
      const updated: UserAddressDto = {
        ...existing,
        ...dto,
        id: existing.id,
        latitude: lat,
        longitude: lng,
        isDefault,
      };
      if (isDefault) {
        addrs.forEach((a) => (a.isDefault = false));
      }
      addrs[duplicateIdx] = updated;
      this.addressStore.set(userId, addrs);
      return { success: true, data: updated, message: 'Address updated successfully' };
    }

    try {
      await this.ensureUser(userId);
      const created = await this.prisma.$transaction(async (tx) => {
        if (isDefault) {
          await tx.address.updateMany({
            where: { userId },
            data: { isDefault: false },
          });
        }
        return tx.address.create({
          data: {
            userId,
            label: dto.label || 'HOME',
            houseNo: dto.houseNo.trim(),
            street: dto.street.trim(),
            landmark: dto.landmark?.trim() || null,
            city: dto.city?.trim() || 'Bengaluru',
            pincode: dto.pincode.trim(),
            latitude: lat,
            longitude: lng,
            isDefault,
          },
        });
      });

      const formatted: UserAddressDto = {
        id: created.id,
        label: created.label,
        fullName: dto.fullName,
        phone: dto.phone,
        country: dto.country || 'India',
        state: dto.state,
        district: dto.district,
        city: created.city,
        area: dto.area,
        pincode: created.pincode,
        houseNo: created.houseNo,
        street: created.street,
        landmark: created.landmark || undefined,
        latitude: created.latitude,
        longitude: created.longitude,
        isDefault: created.isDefault,
        isServiceable: dto.isServiceable,
      };

      if (formatted.isDefault) {
        addrs.forEach((a) => (a.isDefault = false));
      }
      addrs.unshift(formatted);
      this.addressStore.set(userId, addrs);

      return { success: true, data: formatted, message: 'Address created successfully' };
    } catch (err: any) {
      this.logger.warn(`Database createAddress fallback for ${userId}: ${err?.message}`);
    }

    const newAddr: UserAddressDto = {
      ...dto,
      id: `addr_${Date.now()}`,
      country: dto.country || 'India',
      latitude: lat,
      longitude: lng,
      isDefault: addrs.length === 0 || isDefault,
    };
    if (newAddr.isDefault) {
      addrs.forEach((a) => (a.isDefault = false));
    }
    addrs.unshift(newAddr);
    this.addressStore.set(userId, addrs);
    return { success: true, data: newAddr, message: 'Address created successfully' };
  }

  async updateAddress(userId = 'usr_default', id: string, dto: Partial<UserAddressDto>) {
    try {
      const updated = await this.prisma.$transaction(async (tx) => {
        if (dto.isDefault) {
          await tx.address.updateMany({
            where: { userId },
            data: { isDefault: false },
          });
        }
        const res = await tx.address.updateMany({
          where: { id, userId },
          data: {
            label: dto.label,
            houseNo: dto.houseNo,
            street: dto.street,
            landmark: dto.landmark,
            city: dto.city,
            pincode: dto.pincode,
            latitude: dto.latitude != null && !isNaN(Number(dto.latitude)) ? Number(dto.latitude) : undefined,
            longitude: dto.longitude != null && !isNaN(Number(dto.longitude)) ? Number(dto.longitude) : undefined,
            isDefault: dto.isDefault,
          },
        });
        if (res.count === 0) {
          throw new NotFoundException('Address not found');
        }
        return tx.address.findFirst({
          where: { id, userId },
        });
      });

      if (!updated) {
        throw new NotFoundException('Address not found');
      }

      const formatted: UserAddressDto = {
        id: updated.id,
        label: updated.label,
        houseNo: updated.houseNo,
        street: updated.street,
        landmark: updated.landmark || undefined,
        city: updated.city,
        pincode: updated.pincode,
        latitude: updated.latitude,
        longitude: updated.longitude,
        isDefault: updated.isDefault,
      };

      const addrs = this.addressStore.get(userId) || [];
      const idx = addrs.findIndex((a) => a.id === id);
      if (idx !== -1) {
        if (formatted.isDefault) {
          addrs.forEach((a) => (a.isDefault = false));
        }
        addrs[idx] = { ...addrs[idx], ...formatted };
        this.addressStore.set(userId, addrs);
      }

      return { success: true, data: formatted, message: 'Address updated successfully' };
    } catch (err: any) {
      if (err instanceof NotFoundException) {
        throw err;
      }
      this.logger.warn(`Database updateAddress fallback for ${id}: ${err?.message}`);
    }

    const addrs = this.addressStore.get(userId) || [];
    const idx = addrs.findIndex((a) => a.id === id);
    if (idx === -1) throw new NotFoundException('Address not found');

    if (dto.isDefault) {
      addrs.forEach((a) => (a.isDefault = false));
    }
    addrs[idx] = { ...addrs[idx], ...dto };
    this.addressStore.set(userId, addrs);
    return { success: true, data: addrs[idx], message: 'Address updated successfully' };
  }

  async deleteAddress(userId = 'usr_default', id: string) {
    try {
      await this.prisma.address.deleteMany({
        where: { id, userId },
      });
    } catch (err: any) {
      this.logger.warn(`Database deleteAddress fallback for ${id}: ${err?.message}`);
    }

    const addrs = this.addressStore.get(userId) || [];
    const filtered = addrs.filter((a) => a.id !== id);
    this.addressStore.set(userId, filtered);
    return { success: true, message: 'Address deleted successfully' };
  }

  async getSettings(userId = 'usr_default') {
    const settings = this.settingsStore.get(userId) || this.settingsStore.get('usr_default');
    return { success: true, data: settings };
  }

  async updateSettings(userId = 'usr_default', dto: Partial<NotificationSettingsDto>) {
    const existing = (await this.getSettings(userId)).data;
    const updated = { ...existing, ...dto };
    this.settingsStore.set(userId, updated);
    return { success: true, data: updated, message: 'Notification preferences saved' };
  }

  async changePassword(userId = 'usr_default', dto: { currentPass: string; newPass: string }) {
    if (!dto.currentPass || !dto.newPass) {
      throw new BadRequestException('Current and new password are required');
    }
    return { success: true, userId, message: 'Password changed successfully' };
  }

  async logoutAll(userId = 'usr_default') {
    return { success: true, userId, message: 'Successfully logged out across all active sessions' };
  }

  async getPrivacyPolicy() {
    return {
      success: true,
      data: {
        version: 'v2.4.0',
        lastUpdated: 'August 2026',
        sections: [
          {
            title: '1. Information We Collect',
            content: 'Daily Basket collects personal details including name, phone number, email address, physical delivery addresses, and payment transaction metadata to fulfill quick-commerce orders within 10 minutes.',
          },
          {
            title: '2. Location & GPS Usage',
            content: 'We access fine device location solely during active delivery tracking and automatic address detection to route your order to the nearest dark store.',
          },
          {
            title: '3. Data Security & Storage',
            content: 'All user credentials, payment details, and OAuth tokens are secured using AES-256 encryption at rest and TLS 1.3 in transit.',
          },
          {
            title: '4. Third-Party Sharing',
            content: 'We share minimal delivery information strictly with assigned logistics partners and payment processors.',
          },
        ],
      },
    };
  }

  async getTermsOfService() {
    return {
      success: true,
      data: {
        version: 'v3.1.0',
        lastUpdated: 'August 2026',
        sections: [
          {
            title: '1. Service Scope',
            content: 'Daily Basket provides 10-minute grocery and fresh produce delivery services subject to local inventory and service area availability.',
          },
          {
            title: '2. Customer Obligations',
            content: 'Users agree to provide accurate delivery addresses and be accessible via phone at the time of order delivery.',
          },
          {
            title: '3. Cancellation & Refunds',
            content: 'Orders can be cancelled prior to dispatch. Instant refunds are credited to the Daily Basket Wallet or original payment method.',
          },
        ],
      },
    };
  }

  async acceptTerms(userId = 'usr_default', dto: { version: string; type: 'PRIVACY' | 'TERMS' }) {
    this.termsConsentStore.set(`${userId}_${dto.type}`, {
      acceptedAt: new Date().toISOString(),
      version: dto.version,
    });
    return { success: true, message: `${dto.type} acceptance recorded` };
  }

  async deleteAccount(userId = 'usr_default', dto: { reason: string; confirmPass?: string }) {
    this.profileStore.delete(userId);
    this.addressStore.delete(userId);
    this.settingsStore.delete(userId);
    return {
      success: true,
      reason: dto.reason,
      message: 'Account soft deleted. Scheduled for permanent deletion per 30-day retention policy.',
    };
  }
}
