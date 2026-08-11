import { Test, TestingModule } from '@nestjs/testing';
import { FeatureFlagsService } from './feature-flags.service';
import { RedisService } from '../redis/redis.service';

describe('FeatureFlagsService Unit Tests', () => {
  let service: FeatureFlagsService;

  const mockRedisService = {
    get: jest.fn(),
    set: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FeatureFlagsService,
        { provide: RedisService, useValue: mockRedisService },
      ],
    }).compile();

    service = module.get<FeatureFlagsService>(FeatureFlagsService);
  });

  it('should return default flag value if Redis entry does not exist', async () => {
    mockRedisService.get.mockResolvedValue(null);

    const isEnabled = await service.isFeatureEnabled('MAINTENANCE_MODE');
    expect(isEnabled).toBe(false);
  });

  it('should update feature flag in Redis', async () => {
    const updated = await service.setFeatureFlag('MAINTENANCE_MODE', true);

    expect(updated.enabled).toBe(true);
    expect(mockRedisService.set).toHaveBeenCalledWith(
      'dailybasket:featureflag:MAINTENANCE_MODE',
      true,
      expect.any(Number),
    );
  });
});
