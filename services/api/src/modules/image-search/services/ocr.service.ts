import { Injectable, Logger } from '@nestjs/common';

export interface OcrExtractedMetadata {
  rawText: string;
  brand?: string;
  mrp?: number;
  weight?: string;
  expiryDate?: string;
  manufacturingInfo?: string;
  ingredients?: string[];
  nutritionTable?: Record<string, string>;
  confidenceScore: number;
}

@Injectable()
export class OcrService {
  private readonly logger = new Logger(OcrService.name);

  async extractTextFromPackage(imageHash: string): Promise<OcrExtractedMetadata> {
    this.logger.log(`Performing package OCR text extraction for imageHash: ${imageHash}`);

    // Simulated OCR extraction
    return {
      rawText: 'AMUL TAAZA TONED MILK 1L NET VOL 1000ml MRP Rs 56 MFG 08/26 EXP 08/26 FAT 3.0% SNF 8.5%',
      brand: 'Amul',
      mrp: 56,
      weight: '1L',
      expiryDate: '2026-08-10',
      manufacturingInfo: 'Amul Dairy Anand, Gujarat',
      ingredients: ['Toned Milk', 'Vitamin A', 'Vitamin D'],
      nutritionTable: {
        Energy: '58 kcal',
        Protein: '3.1g',
        Fat: '3.0g',
        Carbohydrates: '4.7g',
        Calcium: '120mg',
      },
      confidenceScore: 97.4,
    };
  }
}
