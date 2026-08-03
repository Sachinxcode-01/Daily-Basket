import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { PrismaService } from '../../database/prisma.service';

describe('ProductsService Unit Tests', () => {
  let service: ProductsService;

  const mockPrismaService = {
    product: {
      findMany: jest.fn().mockResolvedValue([
        { id: 'prod_1', name: 'Fresh Organic Milk', categoryId: 'cat_dairy' },
      ]),
      findUnique: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
  });

  it('should fetch products catalog', async () => {
    const result = await service.findAll();
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Fresh Organic Milk');
  });
});
