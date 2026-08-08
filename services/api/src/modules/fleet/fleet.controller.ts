import { Controller, Get } from '@nestjs/common';
import { FleetService } from './fleet.service';

@Controller('api/fleet')
export class FleetController {
  constructor(private readonly fleetService: FleetService) {}

  @Get('vehicles')
  async listVehicles() {
    return this.fleetService.listVehicles();
  }

  @Get('zones')
  async listZones() {
    return this.fleetService.listZones();
  }
}
