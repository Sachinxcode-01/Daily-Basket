import { Controller, Get } from '@nestjs/common';
import { ObservabilityService } from './observability.service';

@Controller('api/observability')
export class ObservabilityController {
  constructor(private readonly observabilityService: ObservabilityService) {}

  @Get('health')
  async getSystemHealth() {
    return this.observabilityService.getSystemHealth();
  }
}
