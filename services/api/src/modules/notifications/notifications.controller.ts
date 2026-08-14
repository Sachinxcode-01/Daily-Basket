import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { NotificationsService, DeviceTokenDto, PushNotificationPayload, SmsPayload } from './notifications.service';

@ApiTags('Push Notifications & Alerts')
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Post('register-token')
  @ApiOperation({ summary: 'Register FCM device token for push notifications' })
  async registerDeviceToken(@Body() body: DeviceTokenDto) {
    return this.notificationsService.registerToken(body);
  }

  @Post('subscribe-topic')
  @ApiOperation({ summary: 'Subscribe user device to FCM notification topic' })
  async subscribeTopic(@Body() body: { userId: string; topic: string }) {
    return this.notificationsService.subscribeToTopic(body.userId, body.topic);
  }

  @Post('test-push')
  @ApiOperation({ summary: 'Trigger test push notification to registered device' })
  async sendTestPush(@Body() body: PushNotificationPayload) {
    return this.notificationsService.sendPushNotification({
      userId: body.userId,
      title: body.title || 'Daily Basket Instant Updates Enabled! 🛒',
      body: body.body || 'You will now receive live 10-minute order tracking and exclusive discounts.',
      data: body.data,
    });
  }

  @Post('send-sms')
  @ApiOperation({ summary: 'Dispatch SMS message via SMS gateway' })
  async sendSms(@Body() body: SmsPayload) {
    return this.notificationsService.sendSms(body);
  }
}

