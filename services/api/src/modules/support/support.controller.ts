import { Controller, Get, Post, Body, Param, Request } from '@nestjs/common';
import { SupportService } from './support.service';

@Controller('support')
export class SupportController {
  constructor(private readonly supportService: SupportService) {}

  @Get('tickets')
  async getTickets(@Request() req: any) {
    const userId = req.user?.id || 'demo_user_id';
    return this.supportService.getTickets(userId);
  }

  @Post('tickets')
  async createTicket(
    @Request() req: any,
    @Body() body: { subject: string; initialMessage?: string },
  ) {
    const userId = req.user?.id || 'demo_user_id';
    return this.supportService.createTicket(userId, body.subject, body.initialMessage);
  }

  @Post('tickets/:id/messages')
  async addMessage(
    @Param('id') ticketId: string,
    @Request() req: any,
    @Body() body: { text: string; isAgent?: boolean },
  ) {
    const userId = req.user?.id || 'demo_user_id';
    const senderName = body.isAgent ? 'Sarah J. (Agent)' : 'Customer';
    return this.supportService.addMessage(
      ticketId,
      userId,
      senderName,
      body.text,
      body.isAgent || false,
    );
  }

  @Post('tickets/:id/close')
  async closeTicket(
    @Param('id') ticketId: string,
    @Body() body: { rating?: number },
  ) {
    return this.supportService.closeTicket(ticketId, body.rating);
  }
}
