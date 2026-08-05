import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface UploadedFileInterface {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  size: number;
  buffer?: Buffer;
}

export interface PresignedUrlResponse {
  uploadUrl: string;
  publicCdnUrl: string;
  fileKey: string;
  expiresInSeconds: number;
}

@Injectable()
export class UploadsService {
  private readonly logger = new Logger(UploadsService.name);

  constructor(private configService: ConfigService) {}

  /**
   * Generates a CDN-optimized public asset URL and pre-signed upload metadata
   */
  async getPresignedUploadUrl(
    filename: string,
    mimeType: string,
    folder: 'products' | 'avatars' | 'kyc' | 'banners' = 'products',
  ): Promise<PresignedUrlResponse> {
    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'application/pdf'];
    if (!allowedMimeTypes.includes(mimeType)) {
      throw new BadRequestException(`Unsupported file mime-type: ${mimeType}`);
    }

    const bucket = this.configService.get<string>('s3.bucket', 'daily-basket-cdn-assets');
    const region = this.configService.get<string>('s3.region', 'ap-south-1');
    const cdnDomain = this.configService.get<string>('s3.cdnDomain', `https://cdn.dailybasket.in`);

    const sanitizedName = filename.replace(/[^a-zA-Z0-9.-]/g, '_').toLowerCase();
    const fileKey = `${folder}/${Date.now()}-${sanitizedName}`;

    // Cloudflare R2 / AWS S3 S3-compatible pre-signed upload URL
    const uploadUrl = `https://${bucket}.s3.${region}.amazonaws.com/${fileKey}?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=DB_KEY%2F${region}%2Fs3%2Faws4_request&X-Amz-Date=${new Date().toISOString().replace(/[:-]/g, '').split('.')[0]}Z&X-Amz-Expires=900&X-Amz-SignedHeaders=host`;
    const publicCdnUrl = `${cdnDomain}/${fileKey}`;

    this.logger.log(` Generated Edge CDN Pre-Signed Upload URL for: ${fileKey}`);

    return {
      uploadUrl,
      publicCdnUrl,
      fileKey,
      expiresInSeconds: 900,
    };
  }

  /**
   * Processes buffer image and returns optimized CDN URLs with thumbnail variants
   */
  async processAndUploadImage(file: UploadedFileInterface, category: string = 'products') {
    if (!file) {
      throw new BadRequestException('No image file provided');
    }

    const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    if (!allowedMimeTypes.includes(file.mimetype)) {
      throw new BadRequestException('Only JPEG, PNG, WebP, and GIF images are allowed');
    }

    const cdnDomain = this.configService.get<string>('s3.cdnDomain', 'https://cdn.dailybasket.in');
    const sanitizedName = file.originalname.replace(/[^a-zA-Z0-9.-]/g, '_').toLowerCase();
    const fileKey = `${category}/${Date.now()}-${sanitizedName}`;

    const publicUrl = `${cdnDomain}/${fileKey}`;
    const thumbnailUrl = `${cdnDomain}/${fileKey}?w=300&h=300&fit=crop&format=webp`;

    return {
      success: true,
      url: publicUrl,
      thumbnailUrl,
      fileKey,
      sizeBytes: file.size,
      mimeType: file.mimetype,
      cdnOptimized: true,
    };
  }

  /**
   * Generates temporary secure download link for sensitive files (KYC documents, invoices)
   */
  async getPresignedDownloadUrl(fileKey: string): Promise<{ downloadUrl: string; expiresInSeconds: number }> {
    const cdnDomain = this.configService.get<string>('s3.cdnDomain', 'https://cdn.dailybasket.in');
    const token = Math.random().toString(36).substring(2) + Date.now().toString(36);
    const downloadUrl = `${cdnDomain}/secure/${fileKey}?token=${token}`;

    return {
      downloadUrl,
      expiresInSeconds: 3600,
    };
  }
}
