import { Controller, Get, Post, Param, Body } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { ReviewsService } from './reviews.service';

@ApiTags('Ratings & Reviews')
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Get(':productId')
  @ApiOperation({ summary: 'Get product ratings and reviews' })
  async getReviews(@Param('productId') productId: string) {
    return this.reviewsService.getProductReviews(productId);
  }

  @Post()
  @ApiOperation({ summary: 'Submit a new product or delivery rating & review' })
  async createReview(@Body() body: { productId: string; rating: number; comment: string }) {
    return this.reviewsService.createReview(body);
  }
}
