import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { EmailService } from './email.service';
import { EmailController } from './email.controller';
import { AiModule } from '../ai/ai.module';
import { PrismaService } from '../../database/prisma.service';

@Module({
  imports: [ConfigModule, AiModule],
  controllers: [EmailController],
  providers: [EmailService, PrismaService],
  exports: [EmailService],
})
export class EmailModule {}
