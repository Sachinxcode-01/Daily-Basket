import { Controller, Get, Post, Delete, Param, Query, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { RecentlyViewedService } from './recently-viewed.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';

@ApiTags('Recently Viewed')
@ApiBearerAuth()
@UseGuards(OptionalJwtAuthGuard)
@Controller('recently-viewed')
export class RecentlyViewedController {
  constructor(private readonly recentlyViewedService: RecentlyViewedService) {}

  @Get()
  @ApiOperation({ summary: 'Get user recently viewed products' })
  async get(@Query('limit') limit?: number) {
    return this.recentlyViewedService.get(Number(limit) || 12);
  }

  @Post()
  @ApiOperation({ summary: 'Track a product view for the current user' })
  async trackView(@ResolvedUserId() userId: string, @Body() body: { productId: string }) {
    return this.recentlyViewedService.track(userId, body.productId);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Remove a product from recent views' })
  async remove(@Param('id') id: string) {
    return this.recentlyViewedService.remove(id);
  }
}
