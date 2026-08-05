import { Test, TestingModule } from '@nestjs/testing';
import { FavoritesService } from './favorites.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';
import { EventsGateway } from '../events/events.gateway';

describe('FavoritesService', () => {
  let service: FavoritesService;
  let prisma: PrismaService;

  const mockPrisma = {
    favorite: {
      findMany: jest.fn().mockResolvedValue([]),
      count: jest.fn().mockResolvedValue(0),
      findUnique: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockResolvedValue({ id: 'fav-1', userId: 'u1', productId: 'p1' }),
      delete: jest.fn().mockResolvedValue({ id: 'fav-1' }),
      deleteMany: jest.fn().mockResolvedValue({ count: 2 }),
      groupBy: jest.fn().mockResolvedValue([]),
    },
    product: {
      findUnique: jest.fn().mockResolvedValue({ id: 'p1', name: 'Test Product', variants: [] }),
      findMany: jest.fn().mockResolvedValue([]),
    },
  };

  const mockRedis = {
    get: jest.fn().mockResolvedValue(null),
    set: jest.fn().mockResolvedValue(undefined),
    del: jest.fn().mockResolvedValue(undefined),
    delByPattern: jest.fn().mockResolvedValue(undefined),
  };

  const mockEventsGateway = {
    broadcastFavoriteUpdated: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FavoritesService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
        { provide: EventsGateway, useValue: mockEventsGateway },
      ],
    }).compile();

    service = module.get<FavoritesService>(FavoritesService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should fetch user favorites', async () => {
    const res = await service.getFavorites({ userId: 'u1' });
    expect(res).toBeDefined();
    expect(res.data).toEqual([]);
  });

  it('should add a favorite product', async () => {
    const res = await service.addFavorite('u1', 'p1');
    expect(res.status).toBe('ADDED');
    expect(mockEventsGateway.broadcastFavoriteUpdated).toHaveBeenCalledWith('u1', 'p1', true);
  });

  it('should remove a favorite product', async () => {
    mockPrisma.favorite.findUnique.mockResolvedValueOnce({ id: 'fav-1', userId: 'u1', productId: 'p1' });
    const res = await service.removeFavorite('u1', 'p1');
    expect(res.status).toBe('REMOVED');
    expect(mockEventsGateway.broadcastFavoriteUpdated).toHaveBeenCalledWith('u1', 'p1', false);
  });

  it('should clear all favorites for a user', async () => {
    const res = await service.clearFavorites('u1');
    expect(res.status).toBe('CLEARED');
    expect(res.count).toBe(2);
  });
});
