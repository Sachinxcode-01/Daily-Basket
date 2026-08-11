import { Test, TestingModule } from '@nestjs/testing';
import { EventsGateway } from './events.gateway';

describe('EventsGateway Real-Time Unit Tests', () => {
  let gateway: EventsGateway;

  const mockSocketServer = {
    emit: jest.fn(),
    to: jest.fn().mockReturnThis(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [EventsGateway],
    }).compile();

    gateway = module.get<EventsGateway>(EventsGateway);
    gateway.server = mockSocketServer as any;
  });

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
