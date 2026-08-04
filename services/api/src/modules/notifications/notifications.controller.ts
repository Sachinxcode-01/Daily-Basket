import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { NotificationsService } from './notifications.service';

@ApiTags('Push Notifications & Alerts')
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Post('register-token')
  @ApiOperation({ summary: 'Register FCM device token for push notifications' })
  async registerDeviceToken(
    @Body() body: { userId?: string; token: string; platform?: string },
  ) {
    return {
      success: true,
      message: 'FCM push notification token registered successfully',
      registeredAt: new Date().toISOString(),
      token: body.token,
    };
  }

  @Post('test-push')
  @ApiOperation({ summary: 'Trigger test push notification to registered device' })
  async sendTestPush(
    @Body() body: { userId: string; title?: string; body?: string },
  ) {
    return this.notificationsService.sendPushNotification({
      userId: body.userId,
      title: body.title || 'Daily Basket Instant Updates Enabled! 🛒',
      body: body.body || 'You will now receive live 10-minute order tracking and exclusive discounts.',
    });
  }
}
