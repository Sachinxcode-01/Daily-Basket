import { Test, TestingModule } from '@nestjs/testing';
import { RetailOsService } from './retail-os.service';
import { AiCopilotService } from './ai-copilot.service';
import { WorkflowAutomationService } from './workflow-automation.service';
import { IntegrationHubService } from './integration-hub.service';
import { PrismaService } from '../../database/prisma.service';

describe('RetailOsModule Services', () => {
  let retailOsService: RetailOsService;
  let copilotService: AiCopilotService;
  let workflowService: WorkflowAutomationService;
  let integrationService: IntegrationHubService;

  const mockPrismaService = {
    aiCopilotQueryLog: {
      create: jest.fn().mockResolvedValue({ id: 'log_01', query: 'sales', resolvedIntent: 'SALES_QUERY' }),
      findMany: jest.fn().mockResolvedValue([]),
    },
    workflowRule: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'rule_01', name: 'Auto-Generate PO on Low Stock', triggerEvent: 'STOCK_LOW' },
      ]),
      create: jest.fn().mockResolvedValue({ id: 'rule_02', name: 'Wallet refund' }),
    },
    integrationConnection: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'int_01', providerName: 'RAZORPAY', status: 'CONNECTED' },
      ]),
    },
    masterDataConfig: {
      findMany: jest.fn().mockResolvedValue([]),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RetailOsService,
        AiCopilotService,
        WorkflowAutomationService,
        IntegrationHubService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    retailOsService = module.get<RetailOsService>(RetailOsService);
    copilotService = module.get<AiCopilotService>(AiCopilotService);
    workflowService = module.get<WorkflowAutomationService>(WorkflowAutomationService);
    integrationService = module.get<IntegrationHubService>(IntegrationHubService);
  });

  it('should be defined', () => {
    expect(retailOsService).toBeDefined();
    expect(copilotService).toBeDefined();
    expect(workflowService).toBeDefined();
    expect(integrationService).toBeDefined();
  });

  it('should process AI Copilot natural language sales query', async () => {
    const res = await copilotService.processCopilotQuery('u1', { query: 'What were today sales?' });
    expect(res).toBeDefined();
    expect(res.resolvedIntent).toBe('SALES_QUERY');
    expect(res.responseSummary).toContain('sales');
  });

  it('should list automation workflow rules', async () => {
    const rules = await workflowService.listRules();
    expect(rules).toBeDefined();
    expect(rules.length).toBeGreaterThan(0);
  });

  it('should list active third-party integration connections', async () => {
    const integrations = await integrationService.listConnections();
    expect(integrations).toBeDefined();
    expect(integrations.length).toBeGreaterThan(0);
  });
});
