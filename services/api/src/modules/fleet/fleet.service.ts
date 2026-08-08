import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';

@Injectable()
export class FleetService {
  constructor(private readonly prisma: PrismaService) {}

  async listVehicles() {
    const vehicles = await this.prisma.fleetVehicle.findMany();

    if (vehicles.length === 0) {
      return [
        {
          id: 'v_01',
          vehicleType: 'EV_SCOOTER',
          registrationNo: 'KA-01-EQ-9821',
          fuelType: 'ELECTRIC',
          batteryPercent: 92,
          status: 'ACTIVE',
          driverName: 'Rohan Kumar',
        },
        {
          id: 'v_02',
          vehicleType: 'EV_SCOOTER',
          registrationNo: 'KA-05-EQ-1142',
          fuelType: 'ELECTRIC',
          batteryPercent: 68,
          status: 'ACTIVE',
          driverName: 'Sunil Gowda',
        },
        {
          id: 'v_03',
          vehicleType: 'VAN',
          registrationNo: 'KA-03-MC-4490',
          fuelType: 'DIESEL',
          batteryPercent: 100,
          status: 'MAINTENANCE',
          driverName: 'Inter-Warehouse Transport',
        },
      ];
    }
    return vehicles;
  }

  async listZones() {
    const zones = await this.prisma.deliveryZone.findMany({
      orderBy: { name: 'asc' },
    });

    if (zones.length === 0) {
      return [
        {
          id: 'zone_01',
          name: 'Bengaluru East Zone (Indiranagar / Whitefield)',
          city: 'Bengaluru',
          pincodes: ['560038', '560066', '560075'],
          minOrderValue: 149.0,
          baseDeliveryFee: 25.0,
          activeRidersCount: 18,
          isActive: true,
        },
        {
          id: 'zone_02',
          name: 'Bengaluru South Zone (Koramangala / HSR)',
          city: 'Bengaluru',
          pincodes: ['560034', '560102', '560095'],
          minOrderValue: 149.0,
          baseDeliveryFee: 25.0,
          activeRidersCount: 24,
          isActive: true,
        },
      ];
    }
    return zones;
  }
}
