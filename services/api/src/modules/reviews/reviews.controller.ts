import { Controller, Get, Post, Patch, Delete, Param, Query, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiBearerAuth } from '@nestjs/swagger';
import { ReviewsService, CreateReviewDto } from './reviews.service';
import { OptionalJwtAuthGuard } from '../../common/guards/optional-jwt-auth.guard';
import { ResolvedUserId } from '../../common/decorators/resolved-user-id.decorator';

@ApiTags('Product Reviews & Ratings')
@ApiBearerAuth()
@UseGuards(OptionalJwtAuthGuard)
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Get('admin')
  @ApiOperation({ summary: 'Admin get all reviews for moderation' })
  @ApiQuery({ name: 'status', required: false, enum: ['PENDING', 'APPROVED', 'REJECTED'] })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getAdminReviews(
    @Query('status') status?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.reviewsService.getAdminReviews(status, Number(page) || 1, Number(limit) || 50);
  }

  @Patch('admin/:id/moderate')
  @ApiOperation({ summary: 'Admin moderate review (approve or reject)' })
  async moderateReview(
    @Param('id') reviewId: string,
    @Body() body: { status: 'APPROVED' | 'REJECTED' },
  ) {
    return this.reviewsService.moderateReview(reviewId, body.status);
  }

  @Delete('admin/:id')
  @ApiOperation({ summary: 'Admin delete review' })
  async deleteReview(@Param('id') reviewId: string) {
    return this.reviewsService.deleteReview(reviewId);
  }

  @Get(':productId')
  @ApiOperation({ summary: 'Get product reviews and aggregated 1-5 star ratings summary' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getProductReviews(
    @Param('productId') productId: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.reviewsService.getProductReviews(productId, Number(page) || 1, Number(limit) || 20);
  }

  @Post()
  @ApiOperation({ summary: 'Submit a new product review with 1-5 star rating & verified purchase check' })
  async createReview(
    @ResolvedUserId() userId: string,
    @Body() body: CreateReviewDto,
  ) {
    return this.reviewsService.createReview(userId || 'user-demo-customer-001', body);
  }

  @Post(':id/helpful')
  @ApiOperation({ summary: 'Mark a review as helpful (+1 vote)' })
  async voteHelpful(@Param('id') reviewId: string) {
    return this.reviewsService.voteHelpful(reviewId);
  }
}
