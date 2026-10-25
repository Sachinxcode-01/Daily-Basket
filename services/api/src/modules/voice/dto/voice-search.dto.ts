import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

export class VoiceSearchDto {
  @ApiPropertyOptional({
    description: 'Base64-encoded audio payload if not sending multipart form data',
    example: 'UklGRi4AAABXQVZFZm10IBAAAAABAAEA...',
  })
  @IsOptional()
  @IsString()
  audioBase64?: string;

  @ApiPropertyOptional({
    description: 'Declared MIME type of audio (e.g. audio/wav, audio/webm, audio/m4a)',
    example: 'audio/wav',
  })
  @IsOptional()
  @IsString()
  mimeType?: string;

  @ApiPropertyOptional({
    description: 'Language code hint (e.g. en_IN, hi_IN, kn_IN)',
    example: 'en_IN',
  })
  @IsOptional()
  @IsString()
  languageHint?: string;

  @ApiPropertyOptional({
    description: 'Direct recognized transcription hint from mobile client STT',
    example: 'Find one litre of milk',
  })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  queryHint?: string;

  @ApiPropertyOptional({
    description: 'Current UI route when voice search was initiated',
    example: '/search',
  })
  @IsOptional()
  @IsString()
  currentRoute?: string;
}

export class VoiceSearchResponseData {
  @ApiProperty({ example: 'Find one litre of milk' })
  transcription: string;

  @ApiProperty({ example: 'en_IN' })
  language: string;

  @ApiProperty({ example: 'milk' })
  searchQuery: string;

  @ApiPropertyOptional({ example: 1 })
  extractedQuantity?: number;

  @ApiPropertyOptional({ example: '1L' })
  extractedUnit?: string;

  @ApiPropertyOptional({ example: 100 })
  maxPrice?: number;

  @ApiPropertyOptional({ example: true })
  isOrganic?: boolean;

  @ApiProperty({ type: [Object], description: 'Authoritative Daily Basket product catalogue items' })
  results: any[];

  @ApiProperty({ example: 3 })
  totalCount: number;

  @ApiProperty({
    example: {
      requestId: 'voice_1729876543210',
      processingTimeMs: 240,
      provider: 'voicestudio',
      providerLatencyMs: 160,
      searchLatencyMs: 35,
    },
  })
  meta: {
    requestId: string;
    processingTimeMs: number;
    provider: string;
    providerLatencyMs: number;
    searchLatencyMs: number;
    healthStatus: string;
  };
}

export class VoiceSearchResponseDto {
  @ApiProperty({ example: true })
  success: boolean;

  @ApiProperty({ type: VoiceSearchResponseData })
  data: VoiceSearchResponseData;
}
