import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PersonalizationService } from './personalization.service';

@ApiTags('Personalization-Admin')
@Controller('personalization/admin')
export class PersonalizationAdminController {
  constructor(private readonly personalizationService: PersonalizationService) {}

  @Get('analytics')
  @ApiOperation({ summary: 'Get Recommendation CTR, Conversion, CLV, and Churn Telemetry' })
  async getPersonalizationAnalytics() {
    return this.personalizationService.getPersonalizationAnalyticsSummary();
  }
}
