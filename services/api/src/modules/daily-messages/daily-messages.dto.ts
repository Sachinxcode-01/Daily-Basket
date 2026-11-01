import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, IsBoolean } from 'class-validator';

export class CreateDailyMessageCampaignDto {
  @ApiProperty({ description: 'Campaign title for the daily message', example: 'Fresh Morning Harvest 🌿' })
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty({
    description: 'Campaign message body',
    example: 'Crisp organic greens, farm-fresh milk & seasonal berries delivered in 10 minutes!',
  })
  @IsString()
  @IsNotEmpty()
  body: string;

  @ApiPropertyOptional({ description: 'Target audience role', example: 'CUSTOMER', default: 'CUSTOMER' })
  @IsString()
  @IsOptional()
  audienceRole?: string;

  @ApiPropertyOptional({ description: 'Whether the campaign is active', default: true })
  @IsBoolean()
  @IsOptional()
  enabled?: boolean;

  @ApiPropertyOptional({ description: 'Custom segment overrides (e.g. location, tag)' })
  @IsOptional()
  segmentOverrides?: Record<string, any>;
}

export class DispatchDailyMessageDto {
  @ApiPropertyOptional({ description: 'Specific campaign ID to dispatch (defaults to latest active)' })
  @IsString()
  @IsOptional()
  campaignId?: string;
}
