import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { FeatureFlagsService } from './feature-flags.service';

@Controller('feature-flags')
export class FeatureFlagsController {
  constructor(private readonly featureFlagsService: FeatureFlagsService) {}

  @Get()
  async getAllFlags() {
    return this.featureFlagsService.getAllFlags();
  }

  @Post(':key')
  async setFlag(@Param('key') key: string, @Body('enabled') enabled: boolean) {
    return this.featureFlagsService.setFeatureFlag(key, enabled);
  }
}
