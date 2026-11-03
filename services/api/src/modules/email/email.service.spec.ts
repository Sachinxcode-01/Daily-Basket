import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { EmailService } from './email.service';
import { AiService } from '../ai/ai.service';
import { PrismaService } from '../../database/prisma.service';

describe('EmailService - AI Inbound & Outbound Email Responder', () => {
  let service: EmailService;

  const mockConfigService = {
    get: jest.fn((key: string) => {
      if (key === 'USE_GMAIL') return 'true';
      if (key === 'SMTP_HOST') return 'smtp.gmail.com';
      if (key === 'SMTP_PORT') return 465;
      if (key === 'SMTP_FROM') return 'Daily Basket <sachiii8827@gmail.com>';
      return null;
    }),
  };

  const mockAiService = {
    processChat: jest.fn().mockResolvedValue({
      content:
        'Hello Rahul! I looked into express order #DB-9824 and your rider Rahul M. is just 3 minutes away near MG Road Signal. You will receive your fresh groceries momentarily!',
      providerUsed: 'GEMINI',
      cardType: 'order_status',
      cardData: { orderId: '#DB-9824', eta: '3 mins away' },
    }),
  };

  const mockPrismaService = {
    user: {
      findFirst: jest.fn().mockResolvedValue({
        id: 'user_cust_01',
        email: 'rahul.sharma@example.com',
        fullName: 'Rahul Sharma',
      }),
    },
    supportTicket: {
      create: jest.fn().mockResolvedValue({
        id: 'ticket_auto_001',
        userId: 'user_cust_01',
        subject: 'Where is my order #DB-9824?',
      }),
    },
    chatMessage: {
      create: jest.fn().mockResolvedValue({
        id: 'msg_001',
        ticketId: 'ticket_auto_001',
      }),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EmailService,
        { provide: ConfigService, useValue: mockConfigService },
        { provide: AiService, useValue: mockAiService },
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<EmailService>(EmailService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('sendEmail', () => {
    it('should send transactional email using configured SMTP settings', async () => {
      const result = await service.sendEmail({
        to: 'customer@example.com',
        subject: 'Order Confirmation #DB-9824',
        template: 'ORDER_CONFIRMATION',
        data: {
          customerName: 'Rahul',
          orderId: '#DB-9824',
          totalAmount: 499,
        },
      });

      expect(result.success).toBe(true);
      expect(result.to).toBe('customer@example.com');
      expect(result.status).toBe('DELIVERED');
      expect(result.messageId).toBeDefined();
    });
  });

  describe('handleInboundEmail', () => {
    it('should process customer support email and automatically send human-like AI reply', async () => {
      const inboundDto = {
        from: '"Rahul Sharma" <rahul.sharma@example.com>',
        subject: 'Where is my order #DB-9824?',
        body: 'Hello team, I ordered groceries 15 mins ago and wanted to know when it will arrive. Thanks!',
      };

      const result = await service.handleInboundEmail(inboundDto);

      expect(result.status).toBe('success');
      expect(result.data.to).toBe('rahul.sharma@example.com');
      expect(result.data.subject).toContain('Where is my order #DB-9824?');
      expect(result.data.agentName).toBe('Sarah J.');
      expect(result.data.aiContent).toContain('order #DB-9824');

      // Verify AI service was invoked with correct parameters
      expect(mockAiService.processChat).toHaveBeenCalledWith(
        'rahul.sharma@example.com',
        expect.stringContaining('Rahul Sharma'),
        undefined,
        expect.objectContaining({
          channel: 'email',
          activeOrderId: '#DB-9824',
          senderEmail: 'rahul.sharma@example.com',
        }),
      );

      // Verify ticket creation in Prisma
      expect(mockPrismaService.supportTicket.create).toHaveBeenCalled();
    });

    it('should handle AI failures gracefully and provide reassuring human fallback email', async () => {
      mockAiService.processChat.mockRejectedValueOnce(new Error('AI API rate limit'));

      const inboundDto = {
        from: 'newcustomer@example.com',
        subject: 'Need refund for rotten tomatoes',
        body: 'The tomatoes delivered in #DB-1122 were spoilt. Please refund.',
      };

      const result = await service.handleInboundEmail(inboundDto);

      expect(result.status).toBe('success');
      expect(result.data.to).toBe('newcustomer@example.com');
      expect(result.data.aiContent).toContain('Sarah J.');
      expect(result.data.messageId).toBeDefined();
    });
  });
});
