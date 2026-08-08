import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class LanguageDetectionService {
  private readonly logger = new Logger(LanguageDetectionService.name);

  private readonly scriptRegexes: Array<{ code: string; name: string; regex: RegExp }> = [
    { code: 'hi_IN', name: 'Hindi', regex: /[\u0900-\u097F]/ }, // Devanagari (Hindi/Marathi)
    { code: 'kn_IN', name: 'Kannada', regex: /[\u0C80-\u0CFF]/ }, // Kannada
    { code: 'ta_IN', name: 'Tamil', regex: /[\u0B80-\u0BFF]/ }, // Tamil
    { code: 'te_IN', name: 'Telugu', regex: /[\u0C00-\u0C7F]/ }, // Telugu
    { code: 'ml_IN', name: 'Malayalam', regex: /[\u0D00-\u0D7F]/ }, // Malayalam
  ];

  detectLanguage(text: string, requestedLocale?: string): { code: string; name: string } {
    if (!text || text.trim() === '') {
      return { code: requestedLocale || 'en_IN', name: 'English' };
    }

    // Script matching
    for (const item of this.scriptRegexes) {
      if (item.regex.test(text)) {
        this.logger.debug(`Language detected via script: ${item.name} (${item.code}) for text: "${text}"`);
        return { code: item.code, name: item.name };
      }
    }

    // Hinglish / Romani keywords
    const lower = text.toLowerCase();
    if (lower.includes('doodh') || lower.includes('chai') || lower.includes('chahiye') || lower.includes('kilo')) {
      return { code: 'hi_IN', name: 'Hindi' };
    }
    if (lower.includes('beku') || lower.includes('haalu') || lower.includes('kodu')) {
      return { code: 'kn_IN', name: 'Kannada' };
    }
    if (lower.includes('vaangavu') || lower.includes('paal')) {
      return { code: 'ta_IN', name: 'Tamil' };
    }

    return { code: requestedLocale || 'en_IN', name: 'English' };
  }
}
