import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { SearchService } from './search.service';

@ApiTags('Search')
@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Get()
  @ApiOperation({ summary: 'Search product catalog with debounced suggestions' })
  @ApiQuery({ name: 'query', required: false })
  async search(@Query('query') query?: string) {
    return this.searchService.searchProducts(query || '');
  }
}
