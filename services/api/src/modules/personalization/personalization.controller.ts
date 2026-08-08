import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBody } from '@nestjs/swagger';
import { PersonalizationService } from './personalization.service';
import { SmartBasketService } from './services/smart-basket.service';

@ApiTags('Personalization')
@Controller('personalization')
export class PersonalizationController {
  constructor(
    private readonly personalizationService: PersonalizationService,
    private readonly smartBasketService: SmartBasketService,
  ) {}

  @Get('home')
  @ApiOperation({ summary: 'Get Dynamic Personalized Home Feed Sections & Greetings' })
  @ApiQuery({ name: 'userId', required: false })
  async getHomeFeed(@Query('userId') userId?: string) {
    return this.personalizationService.getPersonalizedHomeFeed(userId || 'user_demo_01');
  }

  @Get('weekly-basket')
  @ApiOperation({ summary: 'Get Predicted Smart Weekly Basket Staples' })
  @ApiQuery({ name: 'userId', required: false })
  async getSmartWeeklyBasket(@Query('userId') userId?: string) {
    return this.smartBasketService.generateSmartWeeklyBasket(userId || 'user_demo_01');
  }

  @Get('smart-reorder')
  @ApiOperation({ summary: 'Get Predictive Smart Reorder Items Running Low' })
  @ApiQuery({ name: 'userId', required: false })
  async getSmartReorder(@Query('userId') userId?: string) {
    return this.personalizationService.getSmartReorderList(userId || 'user_demo_01');
  }

  @Get('insights')
  @ApiOperation({ summary: 'Get Customer Shopping Insights, Spending Trends & Savings' })
  @ApiQuery({ name: 'userId', required: false })
  async getCustomerInsights(@Query('userId') userId?: string) {
    return this.personalizationService.getCustomerInsights(userId || 'user_demo_01');
  }

  @Get('grocery-lists')
  @ApiOperation({ summary: 'Get Saved & AI Generated Grocery Lists' })
  @ApiQuery({ name: 'userId', required: false })
  async getGroceryLists(@Query('userId') userId?: string) {
    return this.personalizationService.getGroceryLists(userId || 'user_demo_01');
  }

  @Post('grocery-lists')
  @ApiOperation({ summary: 'Create New Grocery Shopping List' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        userId: { type: 'string' },
        name: { type: 'string', example: 'Weekly Staples Plan' },
        items: { type: 'array', items: { type: 'object' } },
      },
    },
  })
  async createGroceryList(
    @Body('userId') userId?: string,
    @Body('name') name?: string,
    @Body('items') items?: any[],
  ) {
    return this.personalizationService.createGroceryList(
      userId || 'user_demo_01',
      name || 'New Grocery List',
      items || [],
    );
  }

  @Get('offers')
  @ApiOperation({ summary: 'Get Personalized Offers & Targeted Discounts' })
  @ApiQuery({ name: 'userId', required: false })
  async getPersonalizedOffers(@Query('userId') userId?: string) {
    return this.personalizationService.getPersonalizedOffers(userId || 'user_demo_01');
  }

  @Post('basket-optimize')
  @ApiOperation({ summary: 'AI Basket Optimization for Bundle Savings & Free Delivery' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        userId: { type: 'string' },
        items: { type: 'array', items: { type: 'object' } },
      },
    },
  })
  async optimizeBasket(
    @Body('userId') userId?: string,
    @Body('items') items?: any[],
  ) {
    return this.smartBasketService.optimizeBasket(userId || 'user_demo_01', items || []);
  }
}
