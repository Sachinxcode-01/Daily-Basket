import { Module } from '@nestjs/common';
import { RetailOsService } from './retail-os.service';
import { AiCopilotService } from './ai-copilot.service';
import { WorkflowAutomationService } from './workflow-automation.service';
import { IntegrationHubService } from './integration-hub.service';
import { RetailOsController } from './retail-os.controller';
import { PrismaModule } from '../../database/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [
    RetailOsService,
    AiCopilotService,
    WorkflowAutomationService,
    IntegrationHubService,
  ],
  controllers: [RetailOsController],
  exports: [
    RetailOsService,
    AiCopilotService,
    WorkflowAutomationService,
    IntegrationHubService,
  ],
})
export class RetailOsModule {}
