import { Test, TestingModule } from '@nestjs/testing';
import { GeofenceService } from './geofence.service';

describe('GeofenceService', () => {
  let service: GeofenceService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [GeofenceService],
    }).compile();

    service = module.get<GeofenceService>(GeofenceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should accurately calculate Haversine distance between two coordinates', () => {
    // Koramangala Hub to Indiranagar Hub (~4.5 km)
    const loc1 = { lat: 12.9352, lng: 77.6245 };
    const loc2 = { lat: 12.9719, lng: 77.6412 };

    const distance = service.calculateHaversineDistance(loc1, loc2);
    expect(distance).toBeGreaterThan(3.5);
    expect(distance).toBeLessThan(5.5);
  });

  it('should return serviceable true for location inside Koramangala dark store radius', () => {
    // User at Koramangala 5th Block (~0.6 km from Koramangala Hub)
    const userLoc = { lat: 12.934, lng: 77.622 };
    const result = service.evaluateGeofence(userLoc, 250);

    expect(result.serviceable).toBe(true);
    expect(result.darkStore?.id).toBe('ds_koramangala_01');
    expect(result.darkStore?.distanceKm).toBeLessThan(2.0);
    expect(result.darkStore?.estimatedDeliveryMins).toBeLessThanOrEqual(12);
  });

  it('should return serviceable false when user location is outside coverage radius (>5km)', () => {
    // Far off location outside Bangalore hubs (e.g. 50km away)
    const farUserLoc = { lat: 13.500, lng: 78.100 };
    const result = service.evaluateGeofence(farUserLoc);

    expect(result.serviceable).toBe(false);
    expect(result.reason).toContain('outside dark store');
  });

  it('should apply surge pricing correctly during high demand', () => {
    const userLoc = { lat: 12.934, lng: 77.622 };
    const result = service.evaluateGeofence(userLoc, 100);

    expect(result.surgePricing).toBeDefined();
    expect(result.surgePricing.totalDeliveryFee).toBeGreaterThanOrEqual(0);
  });
});
