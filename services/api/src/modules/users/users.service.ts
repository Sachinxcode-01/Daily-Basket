import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';

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
  houseNo: string;
  street: string;
  landmark?: string;
  city: string;
  pincode: string;
  latitude: number;
  longitude: number;
  isDefault?: boolean;
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
  private profileStore: Map<string, any> = new Map();
  private addressStore: Map<string, UserAddressDto[]> = new Map();
  private settingsStore: Map<string, NotificationSettingsDto> = new Map();
  private termsConsentStore: Map<string, any> = new Map();

  constructor() {
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

  async getProfile(userId = 'usr_default') {
    const profile = this.profileStore.get(userId) || this.profileStore.get('usr_default');
    return { success: true, data: profile };
  }

  async updateProfile(userId = 'usr_default', dto: Partial<UserProfileDto>) {
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
    const addrs = this.addressStore.get(userId) || this.addressStore.get('usr_default') || [];
    return { success: true, data: addrs };
  }

  async createAddress(userId = 'usr_default', dto: UserAddressDto) {
    const addrs = this.addressStore.get(userId) || [];
    const newAddr = {
      ...dto,
      id: `addr_${Date.now()}`,
      isDefault: addrs.length === 0 || dto.isDefault === true,
    };
    if (newAddr.isDefault) {
      addrs.forEach((a) => (a.isDefault = false));
    }
    addrs.push(newAddr);
    this.addressStore.set(userId, addrs);
    return { success: true, data: newAddr, message: 'Address created successfully' };
  }

  async updateAddress(userId = 'usr_default', id: string, dto: Partial<UserAddressDto>) {
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
