import { Controller, Get, Post, Delete, Put, Param, Query, Body, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { BannerService } from './banner.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';
import { RedisService } from '../redis/redis.service';
import { PrismaService } from '../../database/prisma.service';

@ApiTags('Banners & Home Feed')
@Controller('banners')
export class BannerController {
  constructor(
    private readonly bannerService: BannerService,
    private readonly redis: RedisService,
    private readonly prisma: PrismaService,
  ) {}

  @Get('home-feed')
  @ApiOperation({ summary: 'Dynamic home hero slider — active banners by position' })
  async getHomeFeed(@Res() res: Response) {
    const banners = await this.bannerService.getActiveBanners();
    res.json({ banners, type: 'HOME_FEED' });
  }

  @Get('admin')
  @ApiOperation({ summary: 'Admin: List all banners with position sort' })
  @UseGuards(JwtAuthGuard)
  async listBanners() {
    return this.prisma.banner.findMany({ orderBy: { position: 'asc' } });
  }

  @Post('admin')
  @ApiOperation({ summary: 'Admin: Create banner' })
  @UseGuards(JwtAuthGuard)
  async createBanner(@Body() body: any) {
    return this.prisma.banner.create({ data: body });
  }

  @Put('admin/:id')
  @ApiOperation({ summary: 'Admin: Update banner' })
  @UseGuards(JwtAuthGuard)
  async updateBanner(@Param('id') id: string, @Body() body: any) {
    return this.prisma.banner.update({ where: { id }, data: body });
  }

  @Delete('admin/:id')
  @ApiOperation({ summary: 'Admin: Delete banner' })
  @UseGuards(JwtAuthGuard)
  async deleteBanner(@Param('id') id: string) {
    await this.prisma.banner.delete({ where: { id } });
    return { status: 'DELETED', id };
  }

  @Post('refresh')
  @ApiOperation({ summary: 'Admin: Force refresh banners cache' })
  @UseGuards(JwtAuthGuard)
  async refreshCache() {
    await this.redis.del('banners:active');
    return { success: true };
  }
}
