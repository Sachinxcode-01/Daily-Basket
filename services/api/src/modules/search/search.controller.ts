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
  @ApiOperation({ summary: 'Search product catalog with query string' })
  @ApiQuery({ name: 'query', required: false })
  async search(@Query('query') query?: string) {
    return this.searchService.searchProducts(query || '');
  }

  @Post('barcode')
  @ApiOperation({ summary: 'Lookup catalog products by EAN/UPC/SKU barcode' })
  @ApiBody({ schema: { type: 'object', properties: { barcode: { type: 'string', example: '8901030800012' } } } })
  async searchByBarcode(@Body('barcode') barcode: string) {
    return this.searchService.searchByBarcode(barcode);
  }

  @Post('vision')
  @ApiOperation({ summary: 'AI Visual Product Search using Gemini Vision model' })
  @UseInterceptors(FileInterceptor('image'))
  @ApiConsumes('multipart/form-data', 'application/json')
  async searchByVision(
    @UploadedFile() file?: any,
    @Body('imageBase64') imageBase64?: string,
  ) {
    if (!file && !imageBase64) {
      // Allow fallback sample camera image for developer testing
      return this.searchService.analyzeVisionImage(undefined, 'camera_sample.jpg');
    }

    const buffer = file?.buffer || (imageBase64 ? Buffer.from(imageBase64, 'base64') : undefined);
    return this.searchService.analyzeVisionImage(buffer, file?.originalname || 'camera_frame.jpg');
  }

  @Post('image')
  @ApiOperation({ summary: 'Validate uploaded camera image before AI recognition' })
  @UseInterceptors(FileInterceptor('image'))
  @ApiConsumes('multipart/form-data')
  async validateImage(@UploadedFile() file?: any) {
    if (!file) {
      throw new BadRequestException('Image file is required');
    }

    if (file.size > 10 * 1024 * 1024) {
      throw new BadRequestException('Image file size exceeds maximum limit of 10MB');
    }

    return {
      valid: true,
      sizeBytes: file.size,
      mimeType: file.mimetype || 'image/jpeg',
      message: 'Image validated successfully for AI camera processing.',
    };
  }
}
