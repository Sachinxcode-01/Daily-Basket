import { Test, TestingModule } from '@nestjs/testing';
import { PincodeLookupService } from './pincode-lookup.service';
import { PrismaService } from '../../database/prisma.service';

describe('PincodeLookupService', () => {
  let service: PincodeLookupService;

  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PincodeLookupService,
        {
          provide: PrismaService,
          useValue: {
            deliveryZone: {
              findFirst: jest.fn().mockResolvedValue(null),
            },
          },
        },
      ],
    }).compile();

    service = module.get<PincodeLookupService>(PincodeLookupService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('isValidIndianPincode', () => {
    it('should validate standard 6-digit Indian PIN codes', () => {
      expect(service.isValidIndianPincode('582103')).toBe(true);
      expect(service.isValidIndianPincode('560038')).toBe(true);
      expect(service.isValidIndianPincode('110001')).toBe(true);
      expect(service.isValidIndianPincode('400001')).toBe(true);
    });

    it('should reject invalid PIN codes', () => {
      expect(service.isValidIndianPincode('')).toBe(false);
      expect(service.isValidIndianPincode('12345')).toBe(false);
      expect(service.isValidIndianPincode('1234567')).toBe(false);
      expect(service.isValidIndianPincode('012345')).toBe(false); // Indian PIN cannot start with 0
      expect(service.isValidIndianPincode('abc123')).toBe(false);
    });
  });

  describe('lookupPincode - 582103 (Gadag, Karnataka)', () => {
    it('should correctly fetch postal details for Gadag, Karnataka', async () => {
      const result = await service.lookupPincode('582103');

      expect(result.isValid).toBe(true);
      if (result.success) {
        expect(result.country).toBe('India');
        expect(result.state).toBe('Karnataka');
        expect(result.district).toBe('Gadag');
        expect(result.localities.length).toBeGreaterThan(1);
        expect(result.localities).toContain('Gadag City');
        // Serviceability check: Gadag is not in the Bengaluru dark store zone
        expect(result.isServiceable).toBe(false);
        expect(result.serviceabilityBadge).toBe('OUT_OF_RANGE');
      }
    }, 15000);
  });

  describe('lookupPincode - 560038 (Indiranagar, Bengaluru)', () => {
    it('should fetch Bengaluru and mark as serviceable (IN_RANGE)', async () => {
      const result = await service.lookupPincode('560038');

      expect(result.isValid).toBe(true);
      if (result.success) {
        expect(result.state).toBe('Karnataka');
        expect(result.district.toLowerCase()).toMatch(/bangalore|bengaluru/);
        expect(result.isServiceable).toBe(true);
        expect(result.serviceabilityBadge).toBe('IN_RANGE');
        expect(result.darkStore).toBeDefined();
      }
    }, 15000);
  });

  describe('lookupPincode - 110001 (New Delhi)', () => {
    it('should fetch Delhi and NOT Gadag', async () => {
      const result = await service.lookupPincode('110001');

      expect(result.isValid).toBe(true);
      if (result.success) {
        expect(result.state).toBe('Delhi');
        expect(result.district).not.toBe('Gadag');
        expect(result.isServiceable).toBe(false);
      }
    }, 15000);
  });

  describe('lookupPincode - Invalid & non-existent PINs', () => {
    it('should return error without crashing for invalid format', async () => {
      const result = await service.lookupPincode('00000');
      expect(result.success).toBe(false);
      expect(result.isValid).toBe(false);
      expect(result.error).toBeDefined();
    });

    it('should handle non-existent 6-digit PIN gracefully', async () => {
      const result = await service.lookupPincode('999999');
      expect(result.success).toBe(false);
      expect(result.isServiceable).toBe(false);
    }, 15000);
  });

  describe('Caching mechanism', () => {
    it('should serve repeated requests quickly from cache', async () => {
      const start = Date.now();
      const res1 = await service.lookupPincode('582103');
      const firstDuration = Date.now() - start;

      const cachedStart = Date.now();
      const res2 = await service.lookupPincode('582103');
      const cachedDuration = Date.now() - cachedStart;

      expect(res1.pincode).toBe(res2.pincode);
      expect(cachedDuration).toBeLessThanOrEqual(firstDuration);
    });
  });
});

