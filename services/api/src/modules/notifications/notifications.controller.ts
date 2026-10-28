import { Controller, Post, Get, Patch, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { NotificationsService, DeviceTokenDto, PushNotificationPayload } from './notifications.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';

@ApiTags('Notifications')
@ApiBearerAuth()
@UseGuards(OptionalJwtAuthGuard)
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Get()
  @ApiOperation({ summary: 'Get in-app notifications inbox for user' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getUserNotifications(
    @ResolvedUserId() userId: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.notificationsService.getUserNotifications(
      userId || 'user-demo-customer-001',
      Number(page) || 1,
      Number(limit) || 20,
    );
  }

  @Patch(':id/read')
  @ApiOperation({ summary: 'Mark specific notification as read' })
  async markAsRead(
    @ResolvedUserId() userId: string,
    @Param('id') notificationId: string,
  ) {
    return this.notificationsService.markAsRead(notificationId, userId || 'user-demo-customer-001');
  }

  @Post('mark-all-read')
  @ApiOperation({ summary: 'Mark all notifications as read for current user' })
  async markAllAsRead(@ResolvedUserId() userId: string) {
    return this.notificationsService.markAllAsRead(userId || 'user-demo-customer-001');
  }

  @Post('register-token')
  @ApiOperation({ summary: 'Register user FCM device push notification token' })
  async registerToken(@ResolvedUserId() userId: string, @Body() body: { token: string; platform?: 'android' | 'ios' | 'web'; deviceModel?: string }) {
    return this.notificationsService.registerToken({
      userId: userId || 'user-demo-customer-001',
      token: body.token,
      platform: body.platform,
      deviceModel: body.deviceModel,
    });
  }

  @Post('unregister-token')
  @ApiOperation({ summary: 'Unregister / remove device push token' })
  async unregisterToken(@ResolvedUserId() userId: string, @Body() body: { token: string }) {
    return this.notificationsService.unregisterToken(userId || 'user-demo-customer-001', body.token);
  }

  @Post('test-push')
  @ApiOperation({ summary: 'Trigger simulated push notification' })
  async testPushNotification(@ResolvedUserId() userId: string, @Body() body: { title: string; body: string }) {
    return this.notificationsService.sendPushNotification({
      userId: userId || 'user-demo-customer-001',
      title: body.title || 'Daily Basket Test Push',
      body: body.body || 'Your 10-minute grocery delivery is active! 🚀',
    });
  }
}
