import { Test, TestingModule } from '@nestjs/testing';
import { NotificationsService } from './notifications.service';

describe('NotificationsService', () => {
  let service: NotificationsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [NotificationsService],
    }).compile();

    service = module.get<NotificationsService>(NotificationsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should register a device token and return registered count', async () => {
    const result = await service.registerToken({
      userId: 'usr_test_101',
      token: 'fcm_token_abc123xyz',
      platform: 'android',
    });

    expect(result.success).toBe(true);
    expect(result.userId).toBe('usr_test_101');
    expect(result.registeredTokensCount).toBe(1);
  });

  it('should send FCM push notification payload', async () => {
    const pushResult = await service.sendPushNotification({
      userId: 'usr_test_101',
      title: 'Daily Flash Deal!',
      body: 'Get 50% off fresh organic mangoes 🥭',
    });

    expect(pushResult.success).toBe(true);
    expect(pushResult.status).toBe('DELIVERED');
    expect(pushResult.messageId).toContain('fcm_msg_');
  });

  it('should dispatch SMS gateway payload', async () => {
    const smsResult = await service.sendSms({
      phoneNumber: '+919876543210',
      message: 'Your Daily Basket OTP is 4821',
      type: 'otp',
    });

    expect(smsResult.success).toBe(true);
    expect(smsResult.status).toBe('SENT');
    expect(smsResult.provider).toBe('DAILYBASKET_SMS_GATEWAY_V1');
  });

  it('should send combined order status notification via push and SMS', async () => {
    const combined = await service.sendOrderStatusNotification(
      'usr_test_101',
      '+919876543210',
      'ord_9901',
      'PACKING',
      8,
    );

    expect(combined.pushResult.success).toBe(true);
    expect(combined.smsResult.success).toBe(true);
  });
});
