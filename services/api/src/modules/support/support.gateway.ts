import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { SupportService } from './support.service';

@WebSocketGateway({
  cors: { origin: '*' },
  namespace: 'support-chat',
})
export class SupportGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(private readonly supportService: SupportService) {}

  handleConnection(client: Socket) {
    console.log(`[SupportGateway] Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    console.log(`[SupportGateway] Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('join_ticket')
  handleJoinTicket(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { ticketId: string },
  ) {
    client.join(data.ticketId);
    return { status: 'joined', ticketId: data.ticketId };
  }

  @SubscribeMessage('send_message')
  async handleSendMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: {
      ticketId: string;
      senderId: string;
      senderName: string;
      text: string;
      isAgent?: boolean;
    },
  ) {
    const result = await this.supportService.addMessage(
      data.ticketId,
      data.senderId,
      data.senderName,
      data.text,
      data.isAgent ?? false,
    );
    this.server.to(data.ticketId).emit('new_message', result.data);
    return result;
  }

  @SubscribeMessage('typing_status')
  handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: { ticketId: string; isTyping: boolean; senderName: string },
  ) {
    client.to(data.ticketId).emit('typing_status', data);
  }
}
