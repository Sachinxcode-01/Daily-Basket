import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

export interface PersonalRecipeCard {
  id: string;
  title: string;
  category: 'BREAKFAST' | 'LUNCH' | 'DINNER' | 'FESTIVAL' | 'HIGH_PROTEIN';
  imageUrl: string;
  prepTimeMins: number;
  calories: number;
  missingIngredientsCount: number;
}

@Injectable()
export class RecipeRecommendationService {
  private readonly logger = new Logger(RecipeRecommendationService.name);

  constructor(private prisma: PrismaService) {}

  async getPersonalizedRecipes(userId: string): Promise<PersonalRecipeCard[]> {
    this.logger.log(`Fetching personalized recipes for user: ${userId}`);

    return [
      {
        id: 'rec_01',
        title: 'High Protein Oats Smoothie Bowl',
        category: 'BREAKFAST',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        prepTimeMins: 10,
        calories: 340,
        missingIngredientsCount: 2,
      },
      {
        id: 'rec_02',
        title: 'Organic Vegetable Quinoa Khichdi',
        category: 'LUNCH',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        prepTimeMins: 20,
        calories: 410,
        missingIngredientsCount: 1,
      },
      {
        id: 'rec_03',
        title: 'Paneer Tikka Protein Platter',
        category: 'HIGH_PROTEIN',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
        prepTimeMins: 25,
        calories: 520,
        missingIngredientsCount: 3,
      },
    ];
  }
}
