import { Controller, Get, Header } from '@nestjs/common';
import { ObservabilityService } from './observability.service';

@Controller('observability')
export class ObservabilityController {
  constructor(private readonly observabilityService: ObservabilityService) {}

  @Get('health')
  async getSystemHealth() {
    return this.observabilityService.getSystemHealth();
  }

  @Get('liveness')
  async getLivenessProbe() {
    return this.observabilityService.getLivenessProbe();
  }

  @Get('readiness')
  async getReadinessProbe() {
    return this.observabilityService.getReadinessProbe();
  }

  @Get('metrics')
  async getPerformanceMetrics() {
    return this.observabilityService.getPerformanceMetrics();
  }

  @Get('prometheus')
  @Header('Content-Type', 'text/plain; version=0.0.4')
  async getPrometheusMetrics() {
    return this.observabilityService.getPrometheusMetrics();
  }
}
