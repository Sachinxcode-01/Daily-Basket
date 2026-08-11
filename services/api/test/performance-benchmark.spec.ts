import { Test, TestingModule } from '@nestjs/testing';
import { AppModule } from '../src/app.module';
import { InventoryService } from '../src/modules/inventory/inventory.service';
import { RedisService } from '../src/modules/redis/redis.service';
import { SearchService } from '../src/modules/search/search.service';
import { EventsGateway } from '../src/modules/events/events.gateway';

describe('Daily Basket Backend Performance & Concurrency Benchmark', () => {
  let appModule: TestingModule;
  let inventoryService: InventoryService;
  let redisService: RedisService;
  let searchService: SearchService;
  let eventsGateway: EventsGateway;

  beforeAll(async () => {
    appModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    inventoryService = appModule.get<InventoryService>(InventoryService);
    redisService = appModule.get<RedisService>(RedisService);
    searchService = appModule.get<SearchService>(SearchService);
    eventsGateway = appModule.get<EventsGateway>(EventsGateway);
  });

  afterAll(async () => {
    if (appModule) {
      await appModule.close();
    }
  });

  describe('1. Performance Targets Verification', () => {
    it('✓ Cached Redis response latency should be < 100 ms', async () => {
      const key = 'test:benchmark:cache:key';
      const val = { id: 'sample_001', name: 'Fresh Milk', price: 32 };
      await redisService.set(key, val, 60);

      const start = Date.now();
      const retrieved = await redisService.get(key);
      const duration = Date.now() - start;

      expect(retrieved).toBeDefined();
      expect(duration).toBeLessThan(100);
    });

    it('✓ Search query execution & cache latency should be < 100 ms (cached)', async () => {
      // First search to populate cache
      await searchService.searchProducts('milk');

      const start = Date.now();
      const result = await searchService.searchProducts('milk');
      const duration = Date.now() - start;

      expect(result.products).toBeDefined();
      expect(duration).toBeLessThan(100);
    });

    it('✓ Real-time event emission should execute under < 100 ms', async () => {
      const start = Date.now();
      eventsGateway.broadcastOrderUpdated({ id: 'ord_bench_01', userId: 'usr_01', status: 'PACKING' });
      const duration = Date.now() - start;

      expect(duration).toBeLessThan(100);
    });
  });

  describe('2. Concurrency & Race Condition Verification', () => {
    it('✓ Concurrent stock reservation requests should avoid race conditions', async () => {
      const storeId = 'store_test_01';
      const variantId = 'var_test_01';

      // Initialize test stock
      await inventoryService.updateStock(storeId, variantId, 20);

      // Execute 25 simultaneous atomic reservation attempts of quantity = 1
      const reservationPromises = Array.from({ length: 25 }).map(() =>
        inventoryService.reserveStockAtomic(storeId, variantId, 1),
      );

      const results = await Promise.all(reservationPromises);
      const successCount = results.filter((res) => res === true).length;
      const failCount = results.filter((res) => res === false).length;

      // Exactly 20 reservations should succeed, 5 should fail due to stock depletion
      expect(successCount).toBe(20);
      expect(failCount).toBe(5);
    });
  });
});
