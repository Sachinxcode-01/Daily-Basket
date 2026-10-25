import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { EventsGateway } from './events.gateway';

describe('EventsGateway Real-Time Unit Tests', () => {
  let gateway: EventsGateway;
  let mockJwtService: { verify: jest.Mock };

  const mockSocketServer = {
    emit: jest.fn(),
    to: jest.fn().mockReturnThis(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    mockJwtService = {
      verify: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EventsGateway,
        { provide: JwtService, useValue: mockJwtService },
      ],
    }).compile();

    gateway = module.get<EventsGateway>(EventsGateway);
    gateway.server = mockSocketServer as any;
  });

  describe('Event Broadcasting', () => {
    it('should broadcast order created event to admin and store room', () => {
      const mockOrder = { id: 'ord_99', storeId: 'store_01', totalAmount: 450 };

      gateway.broadcastOrderCreated(mockOrder);

      expect(mockSocketServer.emit).toHaveBeenCalledWith('order.created', mockOrder);
      expect(mockSocketServer.to).toHaveBeenCalledWith('admin');
    });

    it('should broadcast live rider location tick', () => {
      gateway.broadcastLiveLocation('ord_99', 'rider_01', 12.9716, 77.5946);

      expect(mockSocketServer.emit).toHaveBeenCalledWith('delivery.location', expect.anything());
      expect(mockSocketServer.to).toHaveBeenCalledWith('order_ord_99');
    });
  });

  describe('Socket Authentication & Room Authorization', () => {
    it('should authenticate client with valid JWT token and auto-join user rooms', () => {
      mockJwtService.verify.mockReturnValue({
        sub: 'usr_101',
        role: 'CUSTOMER',
        email: 'user@dailybasket.com',
      });

      const mockClient: any = {
        id: 'sock_101',
        handshake: {
          auth: { token: 'valid_jwt_token' },
          headers: {},
          query: {},
        },
        data: {},
        join: jest.fn(),
      };

      gateway.handleConnection(mockClient);

      expect(mockJwtService.verify).toHaveBeenCalledWith('valid_jwt_token');
      expect(mockClient.data.user).toEqual({
        id: 'usr_101',
        role: 'CUSTOMER',
        email: 'user@dailybasket.com',
      });
      expect(mockClient.join).toHaveBeenCalledWith('user_usr_101');
      expect(mockClient.join).toHaveBeenCalledWith('customer_usr_101');
    });

    it('should auto-join admin room if authenticated user has ADMIN role', () => {
      mockJwtService.verify.mockReturnValue({
        sub: 'adm_01',
        role: 'ADMIN',
      });

      const mockClient: any = {
        id: 'sock_admin',
        handshake: {
          auth: { token: 'admin_jwt_token' },
          headers: {},
          query: {},
        },
        data: {},
        join: jest.fn(),
      };

      gateway.handleConnection(mockClient);

      expect(mockClient.join).toHaveBeenCalledWith('admin');
    });

    it('should block anonymous socket from joining admin room', () => {
      const mockClient: any = {
        id: 'sock_anon',
        data: { user: null },
        join: jest.fn(),
      };

      const result = gateway.handleJoinRoom(mockClient, 'admin');

      expect(result).toEqual({
        status: 'error',
        code: 'UNAUTHORIZED',
        message: 'Access denied to room admin',
      });
      expect(mockClient.join).not.toHaveBeenCalled();
    });

    it('should allow customer to join own room but block joining another customer room', () => {
      const mockClient: any = {
        id: 'sock_cust',
        data: {
          user: { id: 'usr_101', role: 'CUSTOMER' },
        },
        join: jest.fn(),
      };

      // Allowed: own room
      const ownResult = gateway.handleJoinRoom(mockClient, 'user_usr_101');
      expect(ownResult).toEqual({ status: 'joined', room: 'user_usr_101' });
      expect(mockClient.join).toHaveBeenCalledWith('user_usr_101');

      // Blocked: another user's room
      const otherResult = gateway.handleJoinRoom(mockClient, 'user_usr_999');
      expect(otherResult).toEqual({
        status: 'error',
        code: 'UNAUTHORIZED',
        message: 'Access denied to room user_usr_999',
      });
    });

    it('should allow any client to join public catalog room', () => {
      const mockClient: any = {
        id: 'sock_anon',
        data: { user: null },
        join: jest.fn(),
      };

      const result = gateway.handleJoinRoom(mockClient, 'catalog');

      expect(result).toEqual({ status: 'joined', room: 'catalog' });
      expect(mockClient.join).toHaveBeenCalledWith('catalog');
    });
  });
});

