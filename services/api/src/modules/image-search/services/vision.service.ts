import { Injectable, Logger } from '@nestjs/common';

export interface BoundingBox {
  xMin: number;
  yMin: number;
  xMax: number;
  yMax: number;
}

export interface DetectedVisualProduct {
  id: string;
  detectedName: string;
  brand: string;
  category: string;
  confidenceScore: number;
  boundingBox: BoundingBox;
  estimatedPrice?: number;
}

export interface VisionAnalysisResult {
  isMultiObject: boolean;
  detectedProducts: DetectedVisualProduct[];
  isFoodDish: boolean;
  dishName?: string;
  primaryCategory: string;
  latencyMs: number;
}

@Injectable()
export class VisionService {
  private readonly logger = new Logger(VisionService.name);

  async analyzeVisualContent(imageHash: string): Promise<VisionAnalysisResult> {
    const startTime = Date.now();
    this.logger.log(`Executing Gemini Vision analysis for imageHash: ${imageHash}`);

    // Simulated Multimodal Vision output (handles both single & multi-object detection)
    const detectedProducts: DetectedVisualProduct[] = [
      {
        id: 'det_01',
        detectedName: 'Amul Taaza Toned Milk 1L',
        brand: 'Amul',
        category: 'Dairy',
        confidenceScore: 98.2,
        boundingBox: { xMin: 0.1, yMin: 0.1, xMax: 0.5, yMax: 0.9 },
        estimatedPrice: 56,
      },
      {
        id: 'det_02',
        detectedName: 'Aashirvaad Shuddh Chakki Atta 5kg',
        brand: 'Aashirvaad',
        category: 'Atta & Flours',
        confidenceScore: 94.5,
        boundingBox: { xMin: 0.55, yMin: 0.2, xMax: 0.95, yMax: 0.85 },
        estimatedPrice: 280,
      },
    ];

    return {
      isMultiObject: detectedProducts.length > 1,
      detectedProducts,
      isFoodDish: false,
      primaryCategory: 'Dairy & Grocery',
      latencyMs: Date.now() - startTime,
    };
  }
}
