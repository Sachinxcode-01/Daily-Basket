import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

export interface RecipeIngredient {
  name: string;
  quantityNeeded: string;
  inStock: boolean;
  matchedProductId?: string;
  price?: number;
}

export interface RecipeAnalysisResult {
  dishName: string;
  cuisine: string;
  prepTimeMins: number;
  ingredients: RecipeIngredient[];
  missingIngredientsCount: number;
  totalMissingCost: number;
  stepByStepRecipe: string[];
}

@Injectable()
export class RecipeService {
  private readonly logger = new Logger(RecipeService.name);

  constructor(private prisma: PrismaService) {}

  async detectRecipeFromFoodPhoto(imageHash: string): Promise<RecipeAnalysisResult> {
    this.logger.log(`Analyzing food dish photo for recipe detection [hash: ${imageHash}]`);

    // Fetch database products to match ingredients
    const dbProducts = await this.prisma.product.findMany({
      take: 10,
      include: { variants: true },
    });

    const paneerProd = dbProducts.find((p) => p.name.toLowerCase().includes('paneer')) || dbProducts[0];
    const butterProd = dbProducts.find((p) => p.name.toLowerCase().includes('butter')) || dbProducts[1];
    const tomatoProd = dbProducts.find((p) => p.name.toLowerCase().includes('tomato')) || dbProducts[2];

    const ingredients: RecipeIngredient[] = [
      {
        name: 'Fresh Cottage Cheese (Paneer)',
        quantityNeeded: '200g',
        inStock: true,
        matchedProductId: paneerProd?.id,
        price: paneerProd?.variants[0]?.price || 110,
      },
      {
        name: 'Amul Butter',
        quantityNeeded: '100g',
        inStock: true,
        matchedProductId: butterProd?.id,
        price: butterProd?.variants[0]?.price || 56,
      },
      {
        name: 'Organic Tomatoes',
        quantityNeeded: '500g',
        inStock: true,
        matchedProductId: tomatoProd?.id,
        price: tomatoProd?.variants[0]?.price || 40,
      },
      {
        name: 'Garam Masala Spices',
        quantityNeeded: '50g',
        inStock: false,
      },
    ];

    const totalMissingCost = ingredients
      .filter((i) => i.inStock && i.price)
      .reduce((sum, i) => sum + (i.price || 0), 0);

    return {
      dishName: 'Paneer Butter Masala',
      cuisine: 'North Indian',
      prepTimeMins: 25,
      ingredients,
      missingIngredientsCount: ingredients.length,
      totalMissingCost,
      stepByStepRecipe: [
        'Saute tomatoes, ginger, and cashew nuts in butter until soft.',
        'Blend into smooth gravy puree.',
        'Add paneer cubes, Garam Masala, and cream. Simmer for 8 minutes.',
        'Serve piping hot with Butter Naan or Jeera Rice.',
      ],
    };
  }
}
