import { Module } from '@nestjs/common';
import { DocumentManagementService } from './document-management.service';
import { DocumentManagementController } from './document-management.controller';
import { PrismaModule } from '../../database/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [DocumentManagementService],
  controllers: [DocumentManagementController],
  exports: [DocumentManagementService],
})
export class DocumentManagementModule {}
