import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

export interface CreateWorkflowRuleDto {
  name: string;
  triggerEvent: string;
  conditionJson: any;
  actionType: string;
  actionConfig: any;
}

@Injectable()
export class WorkflowAutomationService {
  constructor(private readonly prisma: PrismaService) {}

  async listRules() {
    const rules = await this.prisma.workflowRule.findMany({
      orderBy: { createdAt: 'desc' },
    });

    if (rules.length === 0) {
      return [
        {
          id: 'rule_01',
          name: 'Auto-Generate PO on Low Stock',
          triggerEvent: 'STOCK_LOW',
          conditionJson: { threshold: 10 },
          actionType: 'CREATE_PO',
          actionConfig: { supplierId: 'sup_01', autoApprove: true },
          isActive: true,
          timesTriggered: 14,
        },
        {
          id: 'rule_02',
          name: 'Auto-Refund Customer Wallet on Approved Return',
          triggerEvent: 'REFUND_APPROVED',
          conditionJson: { maxAmount: 1000 },
          actionType: 'REFUND_WALLET',
          actionConfig: { notifyCustomer: true },
          isActive: true,
          timesTriggered: 28,
        },
        {
          id: 'rule_03',
          name: 'Send Win-Back Coupon to Inactive Customers (14 days)',
          triggerEvent: 'INACTIVE_CUSTOMER',
          conditionJson: { inactiveDays: 14 },
          actionType: 'WINBACK_PUSH',
          actionConfig: { offerCode: 'COMEBACK15' },
          isActive: true,
          timesTriggered: 84,
        },
      ];
    }
    return rules;
  }

  async createRule(dto: CreateWorkflowRuleDto) {
    return this.prisma.workflowRule.create({
      data: {
        name: dto.name,
        triggerEvent: dto.triggerEvent,
        conditionJson: dto.conditionJson,
        actionType: dto.actionType,
        actionConfig: dto.actionConfig,
        isActive: true,
      },
    });
  }
}
