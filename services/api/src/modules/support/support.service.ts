import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class SupportService {
  constructor(private readonly prisma: PrismaService) {}

  async getTickets(userId: string) {
    const tickets = await this.prisma.supportTicket.findMany({
      where: { userId },
      include: {
        messages: {
          orderBy: { createdAt: 'asc' },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    return { status: 'success', data: tickets };
  }

  async createTicket(userId: string, subject: string, initialMessage?: string) {
    const ticket = await this.prisma.supportTicket.create({
      data: {
        userId,
        subject,
        messages: initialMessage
          ? {
              create: {
                senderId: userId,
                senderName: 'Customer',
                text: initialMessage,
                isAgent: false,
              },
            }
          : undefined,
      },
      include: { messages: true },
    });

    return { status: 'success', data: ticket };
  }

  async addMessage(ticketId: string, senderId: string, senderName: string, text: string, isAgent: boolean = false, attachmentUrl?: string) {
    const message = await this.prisma.chatMessage.create({
      data: {
        ticketId,
        senderId,
        senderName,
        text,
        isAgent,
        attachmentUrl,
      },
    });

    await this.prisma.supportTicket.update({
      where: { id: ticketId },
      data: { updatedAt: new Date() },
    });

    return { status: 'success', data: message };
  }

  async closeTicket(ticketId: string, rating?: number) {
    const ticket = await this.prisma.supportTicket.update({
      where: { id: ticketId },
      data: {
        status: 'CLOSED',
        rating,
      },
    });

    return { status: 'success', data: ticket };
  }
}
