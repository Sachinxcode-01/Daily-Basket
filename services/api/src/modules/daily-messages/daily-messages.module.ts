import { Module } from '@nestjs/common';
import { DailyMessagesController } from './daily-messages.controller';
import { DailyMessagesService } from './daily-messages.service';
import { NotificationsModule } from '../notifications/notifications.module';
import { PrismaService } from '../../database/prisma.service';

@Module({
  imports: [NotificationsModule],
  controllers: [DailyMessagesController],
  providers: [DailyMessagesService, PrismaService],
  exports: [DailyMessagesService],
})
export class DailyMessagesModule {}
