import { Controller, Get, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { ImageSearchService } from './image-search.service';

@ApiTags('Image-Search-Admin')
@Controller('image-search/admin')
export class ImageSearchAdminController {
  constructor(private readonly imageSearchService: ImageSearchService) {}

  @Get('analytics')
  @ApiOperation({ summary: 'Get Visual AI Analytics Telemetry and Latency Metrics' })
  async getVisualAnalytics() {
    return this.imageSearchService.getVisualAnalyticsSummary();
  }

  @Get('unmatched')
  @ApiOperation({ summary: 'Get Unmatched Visual Queries Log for AI Fine-Tuning' })
  async getUnmatchedReports() {
    return this.imageSearchService.getUnmatchedQueryLogs();
  }

  @Post('reference-images')
  @ApiOperation({ summary: 'Upload Reference Product Training Image' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        productId: { type: 'string' },
        imageUrl: { type: 'string' },
        angle: { type: 'string', example: 'FRONT' },
      },
    },
  })
  async addReferenceImage(
    @Body('productId') productId: string,
    @Body('imageUrl') imageUrl: string,
    @Body('angle') angle?: string,
  ) {
    return this.imageSearchService.addReferenceImage(productId, imageUrl, angle);
  }
}
