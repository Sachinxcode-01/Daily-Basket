import { Controller, Get, Post, Body, UseGuards, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { DailyMessagesService } from './daily-messages.service';
import { CreateDailyMessageCampaignDto, DispatchDailyMessageDto } from './daily-messages.dto';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';
import { Role } from '@prisma/client';

@ApiTags('Daily Marketing & Promotional Messages')
@Controller('messages/daily')
export class DailyMessagesController {
  constructor(private readonly dailyMessagesService: DailyMessagesService) {}

  @Get()
  @UseGuards(OptionalJwtAuthGuard)
  @ApiOperation({
    summary: "Fetch today's active Daily Message",
    description: "Returns the current active daily promotional/marketing campaign for home screen widgets and cold-start caching.",
  })
  @ApiResponse({ status: 200, description: "Today's daily message returned successfully" })
  async getTodaysDailyMessage(@ResolvedUserId() userId?: string) {
    return this.dailyMessagesService.getTodaysDailyMessage(userId);
  }

  @Post('dispatch')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SUPER_ADMIN)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Manually trigger Daily Message cohort dispatch',
    description: 'Dispatches the specified or latest active daily message to all target customer cohorts via push notifications.',
  })
  @ApiResponse({ status: 200, description: 'Dispatch executed successfully' })
  async triggerDispatch(@Body() dto: DispatchDailyMessageDto) {
    return this.dailyMessagesService.dispatchDailyMessages(dto.campaignId);
  }

  @Post('campaigns')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SUPER_ADMIN)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Create a new Daily Message campaign',
    description: 'Registers a new promotional campaign with deterministic content hashing and audience targeting.',
  })
  @ApiResponse({ status: 201, description: 'Campaign created successfully' })
  async createCampaign(@Body() dto: CreateDailyMessageCampaignDto) {
    return this.dailyMessagesService.createCampaign(dto);
  }

  @Get('campaigns')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SUPER_ADMIN)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'List all Daily Message campaigns and delivery metrics',
    description: 'Returns historical campaigns with outbox delivery counts.',
  })
  @ApiResponse({ status: 200, description: 'Campaigns retrieved successfully' })
  async listCampaigns() {
    return this.dailyMessagesService.listCampaigns();
  }
}

