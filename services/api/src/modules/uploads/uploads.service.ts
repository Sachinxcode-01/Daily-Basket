import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface UploadedFileInterface {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  size: number;
  buffer?: Buffer;
}

@Injectable()
export class UploadsService {
  constructor(private configService: ConfigService) {}

  async processAndUploadImage(file: UploadedFileInterface, category: string = 'products') {
    if (!file) {
      throw new BadRequestException('No image file provided');
    }

    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp'];
    if (!allowedMimeTypes.includes(file.mimetype)) {
      throw new BadRequestException('Only JPEG, PNG, and WebP images are allowed');
    }

    const bucket = this.configService.get<string>('s3.bucket', 'daily-basket-assets-dev');
    const region = this.configService.get<string>('s3.region', 'ap-south-1');
    const filename = `${category}/${Date.now()}-${file.originalname.replace(/\s+/g, '-')}`;
    
    const mockUrl = `https://${bucket}.s3.${region}.amazonaws.com/${filename}`;

    return {
      success: true,
      url: mockUrl,
      filename,
      sizeBytes: file.size,
      mimeType: file.mimetype,
    };
  }
}
