import { Test, TestingModule } from '@nestjs/testing';
import { SearchService } from './search.service';
import { PrismaService } from '../../database/prisma.service';

describe('SearchService', () => {
  let service: SearchService;
  let prisma: PrismaService;

  const mockPrismaService = {
    product: {
      findMany: jest.fn().mockResolvedValue([
        {
          id: 'p1',
          name: 'Organic Tomatoes',
          brand: 'Daily Basket Farms',
          images: ['https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500'],
          category: { name: 'Fresh Fruits & Vegetables' },
          variants: [{ price: 32, mrp: 45, unitName: '500g', isAvailable: true }],
        },
      ]),
      findFirst: jest.fn().mockResolvedValue({
        id: 'p1',
        name: 'Amul Taaza Milk',
        brand: 'Amul',
        images: ['https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500'],
        category: { name: 'Dairy, Bread & Eggs' },
        variants: [{ price: 54, mrp: 56, unitName: '1 L', isAvailable: true }],
      }),
    },
    productVariant: {
      findFirst: jest.fn().mockResolvedValue(null),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SearchService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<SearchService>(SearchService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should return empty products when query is empty', async () => {
    const res = await service.searchProducts('');
    expect(res.products).toEqual([]);
    expect(res.suggestions).toBeDefined();
  });

  it('should search products by text query', async () => {
    const res = await service.searchProducts('tomatoes');
    expect(res.products.length).toBeGreaterThan(0);
    expect(res.totalCount).toBe(1);
  });

  it('should lookup product by barcode string', async () => {
    const res = await service.searchByBarcode('8901030800012');
    expect(res.found).toBe(true);
    expect(res.matchedProduct?.name).toBe('Amul Taaza Milk');
  });

  it('should analyze vision image and return AI extracted metadata and matched products', async () => {
    const res = await service.analyzeVisionImage();
    expect(res.extractedMetadata).toBeDefined();
    expect(res.matchedProducts.length).toBeGreaterThan(0);
    expect(res.noMatchFound).toBe(false);
  });
});
