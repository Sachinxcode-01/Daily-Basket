import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

describe('CategoriesService', () => {
  let service: CategoriesService;

  const mockPrisma = {
    category: {
      findMany: jest.fn().mockResolvedValue([]),
      findFirst: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((args) => Promise.resolve({ id: 'cat-new', ...args.data })),
      update: jest.fn().mockImplementation((args) => Promise.resolve({ id: args.where.id, ...args.data })),
      delete: jest.fn().mockResolvedValue({ id: 'cat-del' }),
    },
    product: {
      findMany: jest.fn().mockResolvedValue([]),
      count: jest.fn().mockResolvedValue(0),
    },
  };

  const mockRedis = {
    get: jest.fn().mockResolvedValue(null),
    set: jest.fn().mockResolvedValue(undefined),
    delByPattern: jest.fn().mockResolvedValue(undefined),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: RedisService, useValue: mockRedis },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should return initial categories when database is empty', async () => {
    const categories = await service.findAll();
    expect(categories).toBeDefined();
    expect(categories.length).toBe(18);
    expect(categories[0].name).toBe('Fresh Fruits & Vegetables');
  });

  it('should find one category by id or slug', async () => {
    const cat = await service.findOne('fresh-fruits-vegetables');
    expect(cat).toBeDefined();
    expect(cat.name).toBe('Fresh Fruits & Vegetables');
  });

  it('should fetch category products', async () => {
    const res = await service.getCategoryProducts('fresh-fruits-vegetables');
    expect(res).toBeDefined();
    expect(res.category).toBeDefined();
    expect(res.data).toEqual([]);
  });

  it('should create a new category', async () => {
    const res = await service.createCategory({
      name: 'Exotic Organic Snacks',
      description: 'Healthy dried fruits',
    });
    expect(res.name).toBe('Exotic Organic Snacks');
    expect(mockRedis.delByPattern).toHaveBeenCalled();
  });
});
