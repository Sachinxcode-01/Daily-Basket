import { Injectable, Logger } from '@nestjs/common';
import { AIProvider } from '../interfaces/ai-provider.interface';

@Injectable()
export class HealthChecker {
  private readonly logger = new Logger(HealthChecker.name);
  private healthCache: Map<string, { healthy: boolean; checkedAt: number }> =
    new Map();

  async checkProviderHealth(provider: AIProvider): Promise<boolean> {
    const name = provider.getProviderName();
    const cached = this.healthCache.get(name);
    const now = Date.now();

    // Cache health for 30 seconds
    if (cached && now - cached.checkedAt < 30000) {
      return cached.healthy;
    }

    try {
      const healthy = await provider.isHealthy();
      this.healthCache.set(name, { healthy, checkedAt: now });
      if (!healthy) {
        this.logger.warn(`Provider ${name} reported unhealthy state`);
      }
      return healthy;
    } catch (err: any) {
      this.logger.error(`Health check failed for ${name}: ${err.message}`);
      this.healthCache.set(name, { healthy: false, checkedAt: now });
      return false;
    }
  }

  getHealthSummary(): Record<string, boolean> {
    const summary: Record<string, boolean> = {};
    this.healthCache.forEach((val, key) => {
      summary[key] = val.healthy;
    });
    return summary;
  }
}
