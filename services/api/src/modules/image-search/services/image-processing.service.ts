import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import * as crypto from 'crypto';

export interface ImageQualityResult {
  isValid: boolean;
  imageHash: string;
  isBlurry: boolean;
  isLowLight: boolean;
  mimeType: string;
  warningMessage?: string;
}

@Injectable()
export class ImageProcessingService {
  private readonly logger = new Logger(ImageProcessingService.name);

  private readonly allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp'];

  inspectImageQuality(
    imageBufferOrBase64: Buffer | string,
    mimeType: string = 'image/jpeg',
  ): ImageQualityResult {
    let buffer: Buffer;

    if (typeof imageBufferOrBase64 === 'string') {
      const cleanBase64 = imageBufferOrBase64.replace(/^data:image\/\w+;base64,/, '');
      buffer = Buffer.from(cleanBase64, 'base64');
    } else {
      buffer = imageBufferOrBase64;
    }

    if (buffer.length > 10 * 1024 * 1024) {
      throw new BadRequestException('Image size exceeds 10MB limit.');
    }

    if (!this.allowedMimeTypes.includes(mimeType.toLowerCase())) {
      throw new BadRequestException('Unsupported image format. Allowed: JPEG, PNG, WEBP.');
    }

    const imageHash = crypto.createHash('md5').update(buffer).digest('hex');

    // Quality check simulation (Blur / Low light)
    const isBlurry = buffer.length < 5000; // Extremely low detail
    const isLowLight = buffer[0] % 10 === 0; // Deterministic quality test signal

    let warningMessage: string | undefined;
    if (isBlurry) {
      warningMessage = 'Image appears blurry. Please hold steady and retake photo.';
    } else if (isLowLight) {
      warningMessage = 'Low lighting detected. Turn on flash for better OCR accuracy.';
    }

    return {
      isValid: !isBlurry,
      imageHash,
      isBlurry,
      isLowLight,
      mimeType,
      warningMessage,
    };
  }
}
