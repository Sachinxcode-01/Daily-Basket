import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { VoiceService } from './voice.service';

@ApiTags('Voice-Admin')
@Controller('voice/admin')
export class VoiceAdminController {
  constructor(private readonly voiceService: VoiceService) {}

  @Get('analytics')
  @ApiOperation({ summary: 'Get Voice AI Analytics, Language Distribution, and Latency Telemetry' })
  async getVoiceAnalytics() {
    return this.voiceService.getVoiceAnalyticsSummary();
  }
}
