import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { PrismaService } from '../../database/prisma.service';

describe('ProductsService Enterprise Unit Tests', () => {
  let service: ProductsService;

  const mockProduct = {
    id: 'prod_1',
    name: 'Fresh Organic Farm Milk',
    slug: 'fresh-organic-farm-milk',
    description: 'Fresh pasteurized farm milk 1L',
    categoryId: 'cat_dairy',
    brand: 'Daily Basket Farms',
    isOrganic: true,
    variants: [
      { id: 'var_1', unitName: '1 L', price: 64, mrp: 70, isAvailable: true },
    ],
  };

  const mockPrismaService = {
    product: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      findFirst: jest.fn(),
    },
    category: {
      findMany: jest.fn().mockResolvedValue([]),
    },
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
  });

  it('should fetch products catalog', async () => {
    mockPrismaService.product.findMany.mockResolvedValue([mockProduct]);

    const result = await service.findAll();
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Fresh Organic Farm Milk');
    expect(result[0].isOrganic).toBe(true);
  });

  it('should fetch product by ID using findOne', async () => {
    mockPrismaService.product.findFirst.mockResolvedValue(mockProduct);

    const product = await service.findOne('prod_1');
    expect(product).toBeDefined();
    expect(product.id).toBe('prod_1');
    expect(mockPrismaService.product.findFirst).toHaveBeenCalledWith({
      where: {
        OR: [
          { id: 'prod_1' },
          { slug: 'prod_1' },
          { slug: { contains: 'prod_1', mode: 'insensitive' } },
          { barcode: 'prod_1' },
          { variants: { some: { sku: { contains: 'prod_1', mode: 'insensitive' } } } },
        ],
      },
      include: { category: true, variants: true, reviews: true, aiInsight: true },
    });
  });

  it('should fetch home feed data', async () => {
    const feed = await service.getHomeFeed();
    expect(feed.etaMins).toBe(10);
    expect(Array.isArray(feed.banners)).toBe(true);
    expect(Array.isArray(feed.flashDeals)).toBe(true);
  });
});
