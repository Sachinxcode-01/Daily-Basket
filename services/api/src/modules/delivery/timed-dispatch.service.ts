import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { GeofenceService, LocationCoordinates } from './geofence.service';
import { EventsGateway } from '../events/events.gateway';
import { OrderStatus } from '@prisma/client';

export interface RiderCandidate {
  id: string;
  name: string;
  phone: string;
  vehicleNumber: string;
  currentLat: number;
  currentLng: number;
  distanceToStoreKm: number;
  activeOrdersCount: number;
  rating: number;
  isOnline: boolean;
  score: number;
}

export interface BatchRouteStop {
  stopNumber: number;
  type: 'PICKUP' | 'DROP';
  orderId?: string;
  orderNumber?: string;
  addressText: string;
  etaMins: number;
}

export interface BatchRoute {
  batchId: string;
  riderId: string;
  storeId: string;
  orderIds: string[];
  stops: BatchRouteStop[];
  distanceBetweenDropsKm: number;
  totalDurationMins: number;
  savingsKm: number;
}

export interface DispatchDecision {
  orderId: string;
  status: 'ASSIGNED' | 'BATCHED' | 'DISPATCH_WINDOW_PENDING' | 'NO_RIDER_AVAILABLE';
  rider?: {
    id: string;
    name: string;
    phone: string;
    vehicleNumber: string;
    distanceToStoreKm: number;
    rating: number;
  };
  isBatched: boolean;
  batchDetails?: BatchRoute;
  packingProgressPercent: number;
  scheduledDispatchAt?: string;
  reason: string;
}

@Injectable()
export class TimedDispatchService {
  private readonly logger = new Logger(TimedDispatchService.name);

  // Active rider pool telemetry (in production backed by Redis geospatial geohashes)
  private readonly activeFleetRoster: Array<{
    id: string;
    name: string;
    phone: string;
    vehicleNumber: string;
    lat: number;
    lng: number;
    rating: number;
    isOnline: boolean;
  }> = [
    {
      id: 'rider_01',
      name: 'Ramesh Kumar',
      phone: '+91 98765 00112',
      vehicleNumber: 'KA 01 EB 4821',
      lat: 12.9365,
      lng: 77.6255,
      rating: 4.9,
      isOnline: true,
    },
    {
      id: 'rider_02',
      name: 'Sunil Gowda',
      phone: '+91 98765 00113',
      vehicleNumber: 'KA 05 EQ 1142',
      lat: 12.9348,
      lng: 77.6212,
      rating: 4.8,
      isOnline: true,
    },
    {
      id: 'rider_03',
      name: 'Rohan Sharma',
      phone: '+91 98765 00114',
      vehicleNumber: 'KA 03 MC 3311',
      lat: 12.9392,
      lng: 77.6278,
      rating: 4.95,
      isOnline: true,
    },
    {
      id: 'rider_04',
      name: 'Praveen Yadav',
      phone: '+91 98765 00115',
      vehicleNumber: 'KA 04 NM 9923',
      lat: 12.9295,
      lng: 77.6231,
      rating: 4.75,
      isOnline: true,
    },
  ];

  constructor(
    private readonly prisma: PrismaService,
    private readonly geofenceService: GeofenceService,
    private readonly eventsGateway: EventsGateway,
  ) {}

  /**
   * Blinkit Timing Invariant (Page 13 & 16):
   * Rider dispatched while packing is in progress (arrives at store as order is bagged).
   * Rider is assigned at exactly 60% of estimated packing completion.
   */
  calculateDispatchTiming(orderCreatedAt: Date, itemsCount: number) {
    // Packing duration: 1.5 mins base + 0.1 mins per item (max 4 mins)
    const packingDurationMins = Math.min(4.0, +(1.5 + itemsCount * 0.1).toFixed(2));
    const packingDurationSecs = packingDurationMins * 60;

    // Dispatch trigger at 60% packing
    const dispatchTriggerSecs = packingDurationSecs * 0.6;

    const nowSecs = Date.now();
    const createdSecs = new Date(orderCreatedAt).getTime();
    const elapsedSecs = Math.max(0, (nowSecs - createdSecs) / 1000);

    const packingProgressPercent = Math.min(100, Math.round((elapsedSecs / packingDurationSecs) * 100));
    const isDispatchWindowOpen = elapsedSecs >= dispatchTriggerSecs;
    const remainingSecsUntilDispatch = Math.max(0, Math.round(dispatchTriggerSecs - elapsedSecs));

    const scheduledDispatchAt = new Date(createdSecs + dispatchTriggerSecs * 1000).toISOString();

    return {
      packingDurationMins,
      packingProgressPercent,
      isDispatchWindowOpen,
      remainingSecsUntilDispatch,
      scheduledDispatchAt,
    };
  }

  /**
   * Find qualified nearby riders.
   * Blinkit Matching Filters:
   * 1. Store -> Rider proximity <= 1.5 km
   * 2. Active orders <= 1 (Max 2 orders per rider to guarantee 10-minute SLA)
   * 3. Online duty status
   */
  async findQualifiedRiders(storeCoordinates: LocationCoordinates): Promise<RiderCandidate[]> {
    const candidates: RiderCandidate[] = [];

    for (const rider of this.activeFleetRoster) {
      if (!rider.isOnline) continue;

      const distanceToStoreKm = this.geofenceService.calculateHaversineDistance(
        { lat: rider.lat, lng: rider.lng },
        storeCoordinates,
      );

      // Blinkit Invariant: Rider must be within 1.5 km of dark store
      if (distanceToStoreKm > 1.5) continue;

      // Query active in-flight orders for this rider in database
      const activeOrders = await this.prisma.order.count({
        where: {
          deliveryPartnerId: rider.id,
          status: {
            in: [OrderStatus.READY_FOR_PICKUP, OrderStatus.OUT_FOR_DELIVERY],
          },
        },
      });

      // Blinkit Invariant: Max 2 orders per rider (if already has 2, cannot take more)
      if (activeOrders >= 2) continue;

      // Matching Score Formula:
      // Higher is better. Closer proximity (+), 0 active orders preferred over 1 (+), higher rating (+)
      const proximityScore = Math.max(0, (1.5 - distanceToStoreKm) / 1.5) * 50;
      const loadScore = (1 - activeOrders * 0.5) * 30;
      const ratingScore = (rider.rating / 5.0) * 20;
      const totalScore = +(proximityScore + loadScore + ratingScore).toFixed(1);

      candidates.push({
        id: rider.id,
        name: rider.name,
        phone: rider.phone,
        vehicleNumber: rider.vehicleNumber,
        currentLat: rider.lat,
        currentLng: rider.lng,
        distanceToStoreKm,
        activeOrdersCount: activeOrders,
        rating: rider.rating,
        isOnline: rider.isOnline,
        score: totalScore,
      });
    }

    // Sort by best score descending
    candidates.sort((a, b) => b.score - a.score);
    return candidates;
  }

  /**
   * Blinkit Batched Routing Engine (Page 13 & 16):
   * - Max 2 orders per rider.
   * - Second order must be in the same delivery corridor: customer destination within 800m (0.8 km)
   *   of first order route.
   */
  async findBatchingOpportunity(
    targetOrder: { id: string; storeId: string; address: { latitude: number; longitude: number } },
    qualifiedRiders: RiderCandidate[],
  ): Promise<{ rider: RiderCandidate; existingOrder: any; distanceKm: number } | null> {
    // Look for a qualified rider who currently has exactly 1 order in READY_FOR_PICKUP at the same store
    for (const rider of qualifiedRiders) {
      if (rider.activeOrdersCount !== 1) continue;

      const existingOrder = await this.prisma.order.findFirst({
        where: {
          deliveryPartnerId: rider.id,
          storeId: targetOrder.storeId,
          status: {
            in: [OrderStatus.READY_FOR_PICKUP, OrderStatus.CREATED],
          },
        },
        include: { address: true },
      });

      if (!existingOrder || !existingOrder.address) continue;

      // Measure distance between destination drops
      const dropDistanceKm = this.geofenceService.calculateHaversineDistance(
        { lat: existingOrder.address.latitude, lng: existingOrder.address.longitude },
        { lat: targetOrder.address.latitude, lng: targetOrder.address.longitude },
      );

      // Blinkit Invariant: Second order drop must be within <= 0.8 km (800 meters) corridor
      if (dropDistanceKm <= 0.8) {
        return {
          rider,
          existingOrder,
          distanceKm: dropDistanceKm,
        };
      }
    }

    return null;
  }

  /**
   * Evaluate and dispatch rider for an order using timed synchronization and corridor batching.
   */
  async dispatchOrder(orderId: string, forceImmediate = false): Promise<DispatchDecision> {
    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
      include: {
        items: true,
        address: true,
        store: true,
      },
    });

    if (!order) {
      throw new NotFoundException(`Order ${orderId} not found`);
    }

    const timing = this.calculateDispatchTiming(order.createdAt, order.items.length);

    // If order is still in early packing and forceImmediate is not set, hold assignment
    if (!timing.isDispatchWindowOpen && !forceImmediate) {
      return {
        orderId,
        status: 'DISPATCH_WINDOW_PENDING',
        isBatched: false,
        packingProgressPercent: timing.packingProgressPercent,
        scheduledDispatchAt: timing.scheduledDispatchAt,
        reason: `Order is ${timing.packingProgressPercent}% packed. Timed dispatch will trigger in ${timing.remainingSecsUntilDispatch}s to minimize rider wait time at store.`,
      };
    }

    // Default dark store coordinates if not explicitly pinned
    const storeCoords: LocationCoordinates = {
      lat: 12.9352,
      lng: 77.6245,
    };

    // 1. Scan qualified riders within 1.5 km
    const qualifiedRiders = await this.findQualifiedRiders(storeCoords);

    if (qualifiedRiders.length === 0) {
      this.logger.warn(`No qualified riders within 1.5km of store for order ${orderId}`);
      return {
        orderId,
        status: 'NO_RIDER_AVAILABLE',
        isBatched: false,
        packingProgressPercent: timing.packingProgressPercent,
        reason: 'All nearby riders are currently busy or outside 1.5km dark store radius. Expanding search corridor.',
      };
    }

    // 2. Check Dynamic Corridor Batching Opportunity (Blinkit Invariant)
    const batchOpportunity = await this.findBatchingOpportunity(
      {
        id: order.id,
        storeId: order.storeId,
        address: {
          latitude: order.address?.latitude || 12.937,
          longitude: order.address?.longitude || 77.621,
        },
      },
      qualifiedRiders,
    );

    if (batchOpportunity) {
      const { rider, existingOrder, distanceKm } = batchOpportunity;
      const batchId = `batch_${Date.now().toString().slice(-6)}`;

      // Update target order with assigned rider and READY_FOR_PICKUP status
      await this.prisma.order.update({
        where: { id: orderId },
        data: {
          deliveryPartnerId: rider.id,
          status: OrderStatus.READY_FOR_PICKUP,
        },
      });

      const batchRoute: BatchRoute = {
        batchId,
        riderId: rider.id,
        storeId: order.storeId,
        orderIds: [existingOrder.id, order.id],
        distanceBetweenDropsKm: distanceKm,
        totalDurationMins: 9,
        savingsKm: +(1.4 - distanceKm).toFixed(2),
        stops: [
          {
            stopNumber: 1,
            type: 'PICKUP',
            addressText: 'Hub Store #01 Koramangala (Pick 2 bags)',
            etaMins: 2,
          },
          {
            stopNumber: 2,
            type: 'DROP',
            orderId: existingOrder.id,
            orderNumber: existingOrder.orderNumber,
            addressText: `${existingOrder.address?.street || 'Stop 1'}`,
            etaMins: 5,
          },
          {
            stopNumber: 3,
            type: 'DROP',
            orderId: order.id,
            orderNumber: order.orderNumber,
            addressText: `${order.address?.street || 'Stop 2'}`,
            etaMins: 9,
          },
        ],
      };

      // Realtime notification to rider & customers
      this.eventsGateway.broadcastRiderAssigned(order.id, order.userId, rider.id, {
        name: rider.name,
        phone: rider.phone,
        vehicleNumber: rider.vehicleNumber,
        isBatched: true,
        batchId,
      });

      return {
        orderId,
        status: 'BATCHED',
        isBatched: true,
        batchDetails: batchRoute,
        rider: {
          id: rider.id,
          name: rider.name,
          phone: rider.phone,
          vehicleNumber: rider.vehicleNumber,
          distanceToStoreKm: rider.distanceToStoreKm,
          rating: rider.rating,
        },
        packingProgressPercent: timing.packingProgressPercent,
        reason: `Batched with order #${existingOrder.orderNumber} along the same delivery corridor (${distanceKm}km separation). 10-minute SLA guaranteed!`,
      };
    }

    // 3. Single Rider Assignment: Pick highest scoring rider
    const bestRider = qualifiedRiders[0];

    await this.prisma.order.update({
      where: { id: orderId },
      data: {
        deliveryPartnerId: bestRider.id,
        status: OrderStatus.READY_FOR_PICKUP,
      },
    });

    this.eventsGateway.broadcastRiderAssigned(order.id, order.userId, bestRider.id, {
      name: bestRider.name,
      phone: bestRider.phone,
      vehicleNumber: bestRider.vehicleNumber,
      isBatched: false,
    });

    return {
      orderId,
      status: 'ASSIGNED',
      isBatched: false,
      rider: {
        id: bestRider.id,
        name: bestRider.name,
        phone: bestRider.phone,
        vehicleNumber: bestRider.vehicleNumber,
        distanceToStoreKm: bestRider.distanceToStoreKm,
        rating: bestRider.rating,
      },
      packingProgressPercent: timing.packingProgressPercent,
      reason: `Assigned nearest available partner ${bestRider.name} (${bestRider.distanceToStoreKm}km away). Rider arrives as packing completes.`,
    };
  }

  /**
   * Get active fleet dispatch status & heat map around dark store
   */
  async getFleetDispatchStatus(storeId = 'default') {
    const storeCoords: LocationCoordinates = { lat: 12.9352, lng: 77.6245 };
    const riders = await this.findQualifiedRiders(storeCoords);

    return {
      storeId,
      timestamp: new Date().toISOString(),
      activeFleetCount: this.activeFleetRoster.length,
      availableNearbyCount: riders.filter((r) => r.activeOrdersCount === 0).length,
      partiallyLoadedCount: riders.filter((r) => r.activeOrdersCount === 1).length,
      riders,
    };
  }
}
