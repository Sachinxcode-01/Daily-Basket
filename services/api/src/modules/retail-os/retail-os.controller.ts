import { Controller, Get, Post, Body, Req, UseGuards } from '@nestjs/common';
import { RetailOsService } from './retail-os.service';
import { AiCopilotService, CopilotQueryRequest } from './ai-copilot.service';
import { WorkflowAutomationService, CreateWorkflowRuleDto } from './workflow-automation.service';
import { IntegrationHubService } from './integration-hub.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('api/v1/retail-os')
export class RetailOsController {
  constructor(
    private readonly retailOsService: RetailOsService,
    private readonly aiCopilotService: AiCopilotService,
    private readonly workflowService: WorkflowAutomationService,
    private readonly integrationService: IntegrationHubService,
  ) {}

  @Get('dashboard/summary')
  async getExecutiveSummary() {
    return this.retailOsService.getExecutiveDashboardSummary();
  }

  @Post('copilot/query')
  @UseGuards(JwtAuthGuard)
  async queryCopilot(@Req() req: any, @Body() body: CopilotQueryRequest) {
    const userId = req.user?.id || 'admin_user';
    return this.aiCopilotService.processCopilotQuery(userId, body);
  }

  @Get('automation/rules')
  async listWorkflowRules() {
    return this.workflowService.listRules();
  }

  @Post('automation/rules')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.BUSINESS_OWNER, Role.SUPER_ADMIN)
  async createWorkflowRule(@Body() dto: CreateWorkflowRuleDto) {
    return this.workflowService.createRule(dto);
  }

  @Get('integrations')
  async listIntegrations() {
    return this.integrationService.listConnections();
  }

  @Get('master-data')
  async getMasterData() {
    return this.retailOsService.getMasterDataConfigs();
  }
}
