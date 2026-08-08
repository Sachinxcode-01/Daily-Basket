import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiQuery, ApiBody, ApiConsumes } from '@nestjs/swagger';
import { SearchService } from './search.service';

@ApiTags('Search')
@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Get()
  @ApiOperation({ summary: 'AI Text & Hybrid Search with Synonym & Typo Correction' })
  @ApiQuery({ name: 'query', required: false })
  @ApiQuery({ name: 'userId', required: false })
  async search(
    @Query('query') query?: string,
    @Query('userId') userId?: string,
  ) {
    return this.searchService.searchProducts(query || '', userId);
  }

  @Post('ai')
  @ApiOperation({ summary: 'AI Natural Language Intent-Aware Search' })
  @ApiBody({ schema: { type: 'object', properties: { query: { type: 'string', example: 'Healthy breakfast below ₹300' }, userId: { type: 'string' } } } })
  async aiSearch(
    @Body('query') query: string,
    @Body('userId') userId?: string,
  ) {
    return this.searchService.searchProducts(query, userId);
  }

  @Get('suggestions')
  @ApiOperation({ summary: 'Get Categorized Search Suggestions & Trending Keywords' })
  @ApiQuery({ name: 'query', required: false })
  @ApiQuery({ name: 'userId', required: false })
  async getSuggestions(
    @Query('query') query?: string,
    @Query('userId') userId?: string,
  ) {
    return this.searchService.getSuggestions(query || '', userId);
  }

  @Post('voice')
  @ApiOperation({ summary: 'Process Voice Search Audio Transcription & Execute Search' })
  @ApiBody({ schema: { type: 'object', properties: { userId: { type: 'string' }, transcription: { type: 'string' } } } })
  async processVoiceSearch(
    @Body('userId') userId: string,
    @Body('transcription') transcription: string,
  ) {
    return this.searchService.processVoiceSearch(userId || 'anon', transcription || 'Fresh organic milk');
  }

  @Get('analytics')
  @ApiOperation({ summary: 'Get Search Analytics & Conversion Metrics' })
  async getSearchAnalytics() {
    return this.searchService.getSearchAnalyticsSummary();
  }

  @Post('barcode')
  @ApiOperation({ summary: 'Lookup catalog products by EAN/UPC/SKU barcode' })
  @ApiBody({ schema: { type: 'object', properties: { barcode: { type: 'string', example: '8901030800012' } } } })
  async searchByBarcode(@Body('barcode') barcode: string) {
    return this.searchService.searchProducts(barcode);
  }
}
