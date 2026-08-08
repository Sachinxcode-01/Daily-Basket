import { Controller, Get, Post, Put, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PromptManager } from './managers/prompt.manager';
import { PrismaService } from '../../database/prisma.service';

@ApiTags('ai-admin')
@Controller('ai/admin')
export class AiAdminController {
  constructor(
    private promptManager: PromptManager,
    private prisma: PrismaService,
  ) {}

  @Get('prompts')
  @ApiOperation({ summary: 'List all centralized AI prompt templates' })
  async getPrompts() {
    return this.promptManager.getAllTemplates();
  }

  @Put('prompts/:key')
  @ApiOperation({ summary: 'Update or create an AI prompt template' })
  async updatePrompt(
    @Param('key') key: string,
    @Body() body: { template: string; name?: string; description?: string },
  ) {
    return this.promptManager.updateTemplate(
      key,
      body.template,
      body.name,
      body.description,
    );
  }

  @Get('trending-searches')
  @ApiOperation({ summary: 'Get all managed trending search keywords' })
  async getTrendingSearches() {
    return this.prisma.trendingSearch.findMany({
      orderBy: [{ sortOrder: 'asc' }, { searchCount: 'desc' }],
    });
  }

  @Post('trending-searches')
  @ApiOperation({ summary: 'Add a new trending search keyword' })
  async addTrendingSearch(
    @Body() body: { keyword: string; category?: string; isFeatured?: boolean },
  ) {
    return this.prisma.trendingSearch.upsert({
      where: { keyword: body.keyword },
      update: {
        category: body.category,
        isFeatured: body.isFeatured ?? true,
        isActive: true,
      },
      create: {
        keyword: body.keyword,
        category: body.category,
        isFeatured: body.isFeatured ?? true,
      },
    });
  }

  @Get('blocked-queries')
  @ApiOperation({ summary: 'Get all prompt injection & blocked search patterns' })
  async getBlockedQueries() {
    return this.prisma.blockedQuery.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  @Post('blocked-queries')
  @ApiOperation({ summary: 'Add blocked search pattern for security moderation' })
  async addBlockedQuery(
    @Body() body: { pattern: string; reason?: string },
  ) {
    return this.prisma.blockedQuery.upsert({
      where: { pattern: body.pattern },
      update: { reason: body.reason, isActive: true },
      create: { pattern: body.pattern, reason: body.reason },
    });
  }
}
