import { Controller, Post, Get, UseInterceptors, UploadedFile, Query } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiConsumes, ApiBody, ApiQuery } from '@nestjs/swagger';
import { UploadsService, UploadedFileInterface } from './uploads.service';

@ApiTags('Uploads')
@Controller('uploads')
export class UploadsController {
  constructor(private readonly uploadsService: UploadsService) {}

  @Post('image')
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({ summary: 'Upload and optimize product/category image to Edge CDN' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
      },
    },
  })
  async uploadImage(
    @UploadedFile() file: UploadedFileInterface,
    @Query('category') category?: string,
  ) {
    return this.uploadsService.processAndUploadImage(file, category);
  }

  @Get('presigned-url')
  @ApiOperation({ summary: 'Generate AWS S3 / Cloudflare R2 pre-signed upload URL' })
  @ApiQuery({ name: 'filename', required: true })
  @ApiQuery({ name: 'mimeType', required: true })
  @ApiQuery({ name: 'folder', required: false, enum: ['products', 'avatars', 'kyc', 'banners'] })
  async getPresignedUploadUrl(
    @Query('filename') filename: string,
    @Query('mimeType') mimeType: string,
    @Query('folder') folder: 'products' | 'avatars' | 'kyc' | 'banners' = 'products',
  ) {
    return this.uploadsService.getPresignedUploadUrl(filename, mimeType, folder);
  }

  @Get('secure-url')
  @ApiOperation({ summary: 'Generate temporary secure download link for sensitive files' })
  @ApiQuery({ name: 'fileKey', required: true })
  async getPresignedDownloadUrl(@Query('fileKey') fileKey: string) {
    return this.uploadsService.getPresignedDownloadUrl(fileKey);
  }
}
