import { Controller, Post, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody } from '@nestjs/swagger';
import { ImageSearchService } from './image-search.service';

@ApiTags('Image-Search')
@Controller('image-search')
export class ImageSearchController {
  constructor(private readonly imageSearchService: ImageSearchService) {}

  @Post('analyze')
  @ApiOperation({ summary: 'Analyze Image via Gemini Vision & OCR for Visual Product Discovery' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        userId: { type: 'string' },
        imageBase64: { type: 'string' },
        mimeType: { type: 'string', example: 'image/jpeg' },
      },
    },
  })
  async analyzeProductImage(
    @Body('userId') userId?: string,
    @Body('imageBase64') imageBase64?: string,
    @Body('mimeType') mimeType?: string,
  ) {
    return this.imageSearchService.analyzeProductImage({
      userId: userId || 'user_demo_01',
      imageBufferOrBase64: imageBase64 || 'MOCK_IMAGE_BASE64_PAYLOAD',
      mimeType: mimeType || 'image/jpeg',
    });
  }

  @Post('recipe')
  @ApiOperation({ summary: 'Analyze Food Photo to Detect Dish, Recipe, and Missing Ingredients' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        imageBase64: { type: 'string' },
      },
    },
  })
  async detectRecipeFromFoodPhoto(@Body('imageBase64') imageBase64?: string) {
    return this.imageSearchService.detectRecipe(imageBase64 || 'MOCK_FOOD_IMAGE_BASE64');
  }
}
