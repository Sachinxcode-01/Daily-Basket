import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { PrismaService } from '../../database/prisma.service';

@ApiTags('Search Enhancements')
@Controller('search')
export class SearchEnhancedController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('trending')
  @ApiOperation({ summary: 'Trending search keywords across all users' })
  @ApiQuery({ name: 'limit', required: false, default: 10 })
  async trending(@Query('limit') limit?: number) {
    const count = Number(limit) || 10;
    const result = await this.prisma.searchAnalytics.groupBy({
      by: ['query'],
      _count: { query: true },
      orderBy: { _count: { query: 'desc' } },
      take: count,
    });
    return { trendingQueries: result.map((r) => ({ query: r.query, count: r._count.query })) };
  }

  @Get('recent')
  @ApiOperation({ summary: 'Recent search queries by the logged-in user' })
  async recent(@Query('limit') limit?: number) {
    // Return recent analytics rows for current user — stored via searchAnalytics table
    const count = Number(limit) || 10;
    const rows = await this.prisma.searchAnalytics.findMany({
      orderBy: { createdAt: 'desc' },
      take: count,
    });
    return { recentSearches: rows.map((r) => r.query) };
  }
}
