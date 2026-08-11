import { IsOptional, IsString, IsInt, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

export class CursorPaginationDto {
  @IsOptional()
  @IsString()
  cursor?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;
}

export interface CursorPaginatedResult<T> {
  data: T[];
  nextCursor: string | null;
  hasMore: boolean;
  totalCount?: number;
}

export function encodeCursor(id: string, timestamp: Date | number): string {
  const ts = typeof timestamp === 'number' ? timestamp : timestamp.getTime();
  return Buffer.from(`${ts}_${id}`).toString('base64');
}

export function decodeCursor(cursor: string): { timestamp: number; id: string } | null {
  try {
    const decoded = Buffer.from(cursor, 'base64').toString('utf8');
    const [tsStr, id] = decoded.split('_');
    const timestamp = parseInt(tsStr, 10);
    if (isNaN(timestamp) || !id) return null;
    return { timestamp, id };
  } catch {
    return null;
  }
}
