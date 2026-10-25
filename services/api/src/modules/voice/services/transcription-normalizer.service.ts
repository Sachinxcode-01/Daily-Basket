import { Injectable, Logger } from '@nestjs/common';

export interface NormalizedTranscription {
  rawTranscription: string;
  cleanedText: string;
  searchQuery: string;
  extractedQuantity?: number;
  extractedUnit?: string;
  maxPrice?: number;
  isOrganic?: boolean;
  detectedLanguage?: string;
}

@Injectable()
export class TranscriptionNormalizerService {
  private readonly logger = new Logger(TranscriptionNormalizerService.name);

  // Common conversational prefixes to strip when extracting product search queries
  private static readonly LEADING_FILLER_REGEX = new RegExp(
    '^(?:please\\s+)?(?:can\\s+you\\s+)?(?:could\\s+you\\s+)?(?:i\\s+want\\s+to\\s+)?(?:i\\s+need\\s+)?(?:i\\s+am\\s+looking\\s+for\\s+)?(?:find\\s+(?:me\\s+)?|search\\s+(?:for\\s+)?|show\\s+(?:me\\s+)?|look\\s+for\\s+|get\\s+(?:me\\s+)?|give\\s+(?:me\\s+)?|buy\\s+|order\\s+|check\\s+(?:for\\s+)?|available\\s+)+',
    'i',
  );

  private static readonly TRAILING_FILLER_REGEX = new RegExp(
    '\\s+(?:please|dhundo|dikhao|dikhaiye|chahiye|lao|huduki|beku|kodi)\\s*$',
    'i',
  );

  private static readonly WORD_TO_NUMBER: Record<string, number> = {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    half: 0.5,
    'half a': 0.5,
    ek: 1,
    do: 2,
    teen: 3,
    chaar: 4,
    paanch: 5,
    ondhu: 1,
    eradu: 2,
    mooru: 3,
  };

  /**
   * Normalizes raw spoken transcription into a high-precision product catalogue query.
   */
  normalize(rawText: string, languageHint?: string): NormalizedTranscription {
    if (!rawText || rawText.trim() === '') {
      return {
        rawTranscription: '',
        cleanedText: '',
        searchQuery: '',
      };
    }

    const trimmed = rawText.trim();
    // Normalize excessive whitespace and remove terminal punctuation
    const cleanedText = trimmed.replace(/\s+/g, ' ').replace(/[.?!,;:]+$/g, '').trim();

    let queryCandidate = cleanedText;

    // 1. Extract Price Constraint (e.g. "under 100 rupees", "below 200 rs", "less than 150")
    let maxPrice: number | undefined;
    const priceMatch = queryCandidate.match(
      /(?:under|below|less\s+than|within|underneath)\s+(?:₹\s*|rs\.?\s*|rupees\s*)?(\d{1,5})(?:\s*(?:₹|rs\.?|rupees|bucks))?/i,
    );
    if (priceMatch && priceMatch[1]) {
      maxPrice = parseInt(priceMatch[1], 10);
      // Remove price phrase from queryCandidate
      queryCandidate = queryCandidate.replace(priceMatch[0], ' ');
    }

    // 2. Extract Quantity and Unit (e.g. "one litre of milk", "500g paneer", "2 kg tomatoes")
    let extractedQuantity: number | undefined;
    let extractedUnit: string | undefined;

    // Pattern A: digit + unit (e.g. "1L", "500g", "2kg", "250 ml")
    const numUnitMatch = queryCandidate.match(/(\d+(?:\.\d+)?)\s*(kg|kilogram|g|gram|l|litre|liter|ml|pack|packet|bunch)\b/i);
    if (numUnitMatch) {
      extractedQuantity = parseFloat(numUnitMatch[1]);
      extractedUnit = this.canonicalUnit(numUnitMatch[2]);
    } else {
      // Pattern B: word number + unit + "of" (e.g. "one litre of milk", "half kg of tomatoes")
      const wordUnitMatch = queryCandidate.match(
        /\b(one|two|three|four|five|half|ek|do|ondhu)\s+(litre|liter|kg|kilogram|packet|bottle|pack)\s*(?:of\s+)?/i,
      );
      if (wordUnitMatch) {
        const wordNum = wordUnitMatch[1].toLowerCase();
        extractedQuantity = TranscriptionNormalizerService.WORD_TO_NUMBER[wordNum] || 1;
        extractedUnit = this.canonicalUnit(wordUnitMatch[2]);
        // Remove unit phrase so the product name remains clean
        queryCandidate = queryCandidate.replace(wordUnitMatch[0], ' ');
      }
    }

    // 3. Detect Organic preference
    const isOrganic = /\borganic\b/i.test(queryCandidate);

    // 4. Strip Conversational Leading/Trailing Fillers
    queryCandidate = queryCandidate.replace(TranscriptionNormalizerService.LEADING_FILLER_REGEX, '');
    queryCandidate = queryCandidate.replace(TranscriptionNormalizerService.TRAILING_FILLER_REGEX, '');

    // Remove connector words like "of", "some" at start
    queryCandidate = queryCandidate.replace(/^(?:of\s+|some\s+|the\s+)+/i, '');

    // Handle "and" for multi-word queries: "milk and bread" -> "milk bread"
    queryCandidate = queryCandidate.replace(/\s+and\s+/gi, ' ');

    // Normalize remaining punctuation
    const searchQuery = queryCandidate.replace(/[^\w\s\u0900-\u097F\u0C80-\u0CFF-]/g, '').trim().replace(/\s+/g, ' ');

    return {
      rawTranscription: trimmed,
      cleanedText,
      searchQuery: searchQuery || cleanedText,
      extractedQuantity,
      extractedUnit,
      maxPrice,
      isOrganic: isOrganic ? true : undefined,
      detectedLanguage: languageHint || 'en_IN',
    };
  }

  private canonicalUnit(rawUnit: string): string {
    const u = rawUnit.toLowerCase();
    if (u === 'litre' || u === 'liter' || u === 'l') return '1L';
    if (u === 'kg' || u === 'kilogram') return '1kg';
    if (u === 'g' || u === 'gram') return '500g';
    if (u === 'ml') return 'ml';
    return rawUnit;
  }
}
