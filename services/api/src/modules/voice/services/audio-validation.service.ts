import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface AudioValidationOptions {
  maxBytes?: number;
  allowedMimeTypes?: string[];
  maxDurationSeconds?: number;
}

export interface ValidatedAudio {
  buffer: Buffer;
  mimeType: string;
  sizeBytes: number;
  detectedFormat: string;
}

@Injectable()
export class AudioValidationService {
  private readonly logger = new Logger(AudioValidationService.name);

  private readonly defaultMaxBytes: number;
  private readonly defaultMaxDurationSec: number;

  private static readonly SUPPORTED_MIME_TYPES = new Set([
    'audio/wav',
    'audio/x-wav',
    'audio/wave',
    'audio/webm',
    'audio/ogg',
    'audio/opus',
    'audio/mpeg',
    'audio/mp3',
    'audio/m4a',
    'audio/x-m4a',
    'audio/mp4',
    'audio/aac',
    'audio/flac',
  ]);

  constructor(private configService: ConfigService) {
    this.defaultMaxBytes =
      parseInt(this.configService.get<string>('VOICE_MAX_AUDIO_BYTES') || '', 10) ||
      10 * 1024 * 1024; // 10MB default
    this.defaultMaxDurationSec =
      parseInt(this.configService.get<string>('VOICE_MAX_AUDIO_DURATION_SECONDS') || '', 10) ||
      30; // 30s default
  }

  /**
   * Validates raw audio buffer against size limits, MIME type, and magic bytes signature.
   */
  validateAudio(
    buffer: Buffer | null | undefined,
    declaredMimeType?: string,
    options?: AudioValidationOptions,
  ): ValidatedAudio {
    if (!buffer || buffer.length === 0) {
      throw new BadRequestException('Empty audio recording: buffer contains 0 bytes.');
    }

    const minBytes = 64;
    if (buffer.length < minBytes) {
      throw new BadRequestException(
        `Audio recording is too short or empty (${buffer.length} bytes). Minimum required is ${minBytes} bytes.`,
      );
    }

    const maxBytes = options?.maxBytes || this.defaultMaxBytes;
    if (buffer.length > maxBytes) {
      throw new BadRequestException(
        `Audio recording exceeds maximum permitted size of ${Math.round(maxBytes / (1024 * 1024))}MB (received ${buffer.length} bytes).`,
      );
    }

    // Inspect magic bytes header signature
    const detectedFormat = this.detectAudioFormatFromMagicBytes(buffer);

    // If client supplied declared MIME type, check allowlist
    const normalizedDeclaredMime = declaredMimeType?.toLowerCase().split(';')[0].trim();
    if (normalizedDeclaredMime && !AudioValidationService.SUPPORTED_MIME_TYPES.has(normalizedDeclaredMime)) {
      throw new BadRequestException(
        `Unsupported audio MIME type: "${declaredMimeType}". Supported formats: WAV, WebM, OGG, MP3, M4A, FLAC.`,
      );
    }

    // Verify magic bytes detection aligns with audio requirements
    if (detectedFormat === 'UNKNOWN') {
      // If declared mime is valid but signature is unknown, log warning or reject if obviously non-audio
      if (!normalizedDeclaredMime) {
        throw new BadRequestException(
          'Could not verify audio format. The provided file does not match any recognized audio signature.',
        );
      }
      this.logger.warn(
        `Unrecognized audio magic bytes for declared MIME "${declaredMimeType}". Proceeding with declared MIME.`,
      );
    }

    const resolvedMime =
      this.formatToMime(detectedFormat) || normalizedDeclaredMime || 'audio/wav';

    return {
      buffer,
      mimeType: resolvedMime,
      sizeBytes: buffer.length,
      detectedFormat,
    };
  }

  /**
   * Inspects binary header signature (magic bytes) to prevent malicious or malformed files.
   */
  detectAudioFormatFromMagicBytes(buf: Buffer): string {
    if (buf.length < 4) return 'UNKNOWN';

    // RIFF .... WAVE
    if (
      buf[0] === 0x52 &&
      buf[1] === 0x49 &&
      buf[2] === 0x46 &&
      buf[3] === 0x46 &&
      buf.length >= 12 &&
      buf[8] === 0x57 &&
      buf[9] === 0x41 &&
      buf[10] === 0x56 &&
      buf[11] === 0x45
    ) {
      return 'WAV';
    }

    // OggS (Ogg / Opus / Vorbis)
    if (buf[0] === 0x4f && buf[1] === 0x67 && buf[2] === 0x67 && buf[3] === 0x53) {
      return 'OGG';
    }

    // EBML (Matroska / WebM) -> 1A 45 DF A3
    if (buf[0] === 0x1a && buf[1] === 0x45 && buf[2] === 0xdf && buf[3] === 0xa3) {
      return 'WEBM';
    }

    // ID3 (MP3 tag header) -> 49 44 33
    if (buf[0] === 0x49 && buf[1] === 0x44 && buf[2] === 0x33) {
      return 'MP3';
    }

    // MPEG Audio frame sync: 11 bits set (0xFF followed by 0xE0..0xFF)
    if (buf[0] === 0xff && (buf[1] & 0xe0) === 0xe0) {
      return 'MP3';
    }

    // MP4 / M4A: check for "ftyp" box at offset 4
    if (
      buf.length >= 12 &&
      buf[4] === 0x66 && // 'f'
      buf[5] === 0x74 && // 't'
      buf[6] === 0x79 && // 'y'
      buf[7] === 0x70    // 'p'
    ) {
      return 'M4A';
    }

    // FLAC -> 66 4C 61 43 ("fLaC")
    if (buf[0] === 0x66 && buf[1] === 0x4c && buf[2] === 0x61 && buf[3] === 0x43) {
      return 'FLAC';
    }

    return 'UNKNOWN';
  }

  private formatToMime(format: string): string | null {
    switch (format) {
      case 'WAV':
        return 'audio/wav';
      case 'OGG':
        return 'audio/ogg';
      case 'WEBM':
        return 'audio/webm';
      case 'MP3':
        return 'audio/mpeg';
      case 'M4A':
        return 'audio/m4a';
      case 'FLAC':
        return 'audio/flac';
      default:
        return null;
    }
  }
}
