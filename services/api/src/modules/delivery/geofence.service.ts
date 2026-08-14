import { Injectable, Logger } from '@nestjs/common';

export interface LocationCoordinates {
  lat: number;
  lng: number;
}

export interface DarkStoreInfo {
  id: string;
  name: string;
  coordinates: LocationCoordinates;
  maxServiceRadiusKm: number;
  activeOrderCount: number;
  maxCapacity: number;
  isOpen: boolean;
}

export interface GeofenceCheckResult {
  serviceable: boolean;
  darkStore?: {
    id: string;
    name: string;
    distanceKm: number;
    estimatedDeliveryMins: number;
    isOpen: boolean;
  };
  reason?: string;
  surgePricing: {
    isSurgeActive: boolean;
    surgeMultiplier: number;
    baseDeliveryFee: number;
    distanceFee: number;
    totalDeliveryFee: number;
    surgeReason?: string;
  };
}

@Injectable()
export class GeofenceService {
  private readonly logger = new Logger(GeofenceService.name);

  // Registered Dark Stores (e.g. Koramangala Hub, Indiranagar Hub, HSR Hub)
  private readonly darkStores: DarkStoreInfo[] = [
    {
      id: 'ds_koramangala_01',
      name: 'Daily Basket Hub — Koramangala 4th Block',
      coordinates: { lat: 12.9352, lng: 77.6245 },
      maxServiceRadiusKm: 5.0,
      activeOrderCount: 42,
      maxCapacity: 50,
      isOpen: true,
    },
    {
      id: 'ds_indiranagar_02',
      name: 'Daily Basket Hub — Indiranagar 100ft Rd',
      coordinates: { lat: 12.9719, lng: 77.6412 },
      maxServiceRadiusKm: 5.0,
      activeOrderCount: 15,
      maxCapacity: 50,
      isOpen: true,
    },
    {
      id: 'ds_hsr_03',
      name: 'Daily Basket Hub — HSR Layout Sector 1',
      coordinates: { lat: 12.9121, lng: 77.6446 },
      maxServiceRadiusKm: 4.5,
      activeOrderCount: 28,
      maxCapacity: 50,
      isOpen: true,
    },
  ];

  /**
   * Calculate distance between two lat/lng points using Haversine Formula (returns km)
   */
  calculateHaversineDistance(loc1: LocationCoordinates, loc2: LocationCoordinates): number {
    const R = 6371; // Earth's radius in kilometers
    const dLat = this.toRadians(loc2.lat - loc1.lat);
    const dLon = this.toRadians(loc2.lng - loc1.lng);
    const lat1 = this.toRadians(loc1.lat);
    const lat2 = this.toRadians(loc2.lat);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    const distance = R * c;
    return +distance.toFixed(2);
  }

  private toRadians(degrees: number): number {
    return (degrees * Math.PI) / 180;
  }

  /**
   * Evaluate geofence coverage & calculate dynamic surge delivery pricing
   */
  evaluateGeofence(userLocation: LocationCoordinates, itemTotal: number = 0): GeofenceCheckResult {
    let nearestStore: DarkStoreInfo | null = null;
    let minDistance = Infinity;

    for (const store of this.darkStores) {
      if (!store.isOpen) continue;
      const distance = this.calculateHaversineDistance(userLocation, store.coordinates);
      if (distance < minDistance) {
        minDistance = distance;
        nearestStore = store;
      }
    }

    if (!nearestStore || minDistance > nearestStore.maxServiceRadiusKm) {
      this.logger.warn(
        `📍 [Geofence] User at (${userLocation.lat}, ${userLocation.lng}) is outside all dark store radiuses (Nearest: ${minDistance}km)`,
      );
      return {
        serviceable: false,
        reason: `Delivery location is outside dark store ${nearestStore ? nearestStore.maxServiceRadiusKm : 5}km coverage zone.`,
        surgePricing: {
          isSurgeActive: false,
          surgeMultiplier: 1.0,
          baseDeliveryFee: 0,
          distanceFee: 0,
          totalDeliveryFee: 0,
        },
      };
    }

    // ETA Calculation: Base 6 mins + 3 mins per km
    const estimatedDeliveryMins = Math.min(25, Math.max(8, Math.round(6 + minDistance * 3)));

    // Calculate Dynamic Surge Pricing
    const loadFactor = nearestStore.activeOrderCount / nearestStore.maxCapacity;
    const isHighDemand = loadFactor > 0.8; // >80% dark store capacity
    const surgeMultiplier = isHighDemand ? 1.5 : 1.0;

    // Free delivery threshold: ₹199 (unless high surge active)
    const isFreeEligible = itemTotal >= 199 && !isHighDemand;
    const baseDeliveryFee = isFreeEligible ? 0 : 25;
    
    // Distance Fee: ₹5 per km for distance > 2km
    const distanceFee = minDistance > 2 ? Math.round((minDistance - 2) * 5) : 0;
    const totalDeliveryFee = isFreeEligible ? 0 : Math.round((baseDeliveryFee + distanceFee) * surgeMultiplier);

    return {
      serviceable: true,
      darkStore: {
        id: nearestStore.id,
        name: nearestStore.name,
        distanceKm: minDistance,
        estimatedDeliveryMins,
        isOpen: nearestStore.isOpen,
      },
      surgePricing: {
        isSurgeActive: isHighDemand,
        surgeMultiplier,
        baseDeliveryFee,
        distanceFee,
        totalDeliveryFee,
        surgeReason: isHighDemand ? '🔥 High order demand in your area' : undefined,
      },
    };
  }
}
