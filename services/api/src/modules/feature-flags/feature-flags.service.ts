import { Injectable, Logger } from '@nestjs/common';
import { RedisService } from '../redis/redis.service';

export interface FeatureFlagDefinition {
  key: string;
  enabled: boolean;
  description: string;
  updatedAt: string;
}

@Injectable()
export class FeatureFlagsService {
  private readonly logger = new Logger(FeatureFlagsService.name);

  private readonly defaultFlags: Record<string, boolean> = {
    MAINTENANCE_MODE: false,
    READ_ONLY_MODE: false,
    ENABLE_AI_COPILOT: true,
    ENABLE_FLASH_SALES: true,
    ENABLE_VOICE_SEARCH: true,
    ENABLE_IMAGE_SEARCH: true,
    STRICT_INVENTORY_LOCKING: true,
  };

  constructor(private readonly redisService: RedisService) {}

  async isFeatureEnabled(flagKey: string): Promise<boolean> {
    const redisKey = `dailybasket:featureflag:${flagKey}`;
    const val = await this.redisService.get<boolean>(redisKey);
    if (val !== null && val !== undefined) {
      return val;
    }
    return this.defaultFlags[flagKey] ?? true;
  }

  async setFeatureFlag(flagKey: string, enabled: boolean): Promise<FeatureFlagDefinition> {
    const redisKey = `dailybasket:featureflag:${flagKey}`;
    await this.redisService.set(redisKey, enabled, 86400 * 30);

    this.logger.log(`🚩 Feature Flag [${flagKey}] updated to: ${enabled}`);

    return {
      key: flagKey,
      enabled,
      description: `Runtime flag for ${flagKey}`,
      updatedAt: new Date().toISOString(),
    };
  }

  async getAllFlags(): Promise<FeatureFlagDefinition[]> {
    const keys = Object.keys(this.defaultFlags);
    const flags: FeatureFlagDefinition[] = [];

    for (const k of keys) {
      const enabled = await this.isFeatureEnabled(k);
      flags.push({
        key: k,
        enabled,
        description: `Runtime flag for ${k}`,
        updatedAt: new Date().toISOString(),
      });
    }

    return flags;
  }
}
