import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { PrismaService } from '../../../database/prisma.service';

export interface PromptTemplateDefinition {
  key: string;
  name: string;
  template: string;
  description: string;
  version: number;
}

@Injectable()
export class PromptManager implements OnModuleInit {
  private readonly logger = new Logger(PromptManager.name);
  private cache: Map<string, string> = new Map();

  private readonly defaultTemplates: Record<string, PromptTemplateDefinition> = {
    SEARCH_INTENT: {
      key: 'SEARCH_INTENT',
      name: 'Search Intent & Entity Extractor',
      description: 'Parses natural language search queries to extract intent, dietary tags, price limits, category, and brand constraints.',
      version: 1,
      template: `You are an AI Search Intent Parser for Daily Basket quick-commerce.
Analyze the customer's search query: "{{query}}"

Identify:
1. Primary product query term (cleaned)
2. Intent classification (HEALTHY, BUDGET, PROTEIN, SNACKS, RECIPE_INGREDIENTS, BRAND_SPECIFIC, GENERAL)
3. Dietary preferences (e.g., Organic, Sugar-Free, High-Protein, Vegan, Gluten-Free)
4. Max price constraint if mentioned in ₹
5. Category constraint if implied
6. Brand constraint if implied

Respond ONLY in valid JSON format:
{
  "cleanedQuery": "<string>",
  "intent": "<intent_enum>",
  "dietaryTags": ["<tag>"],
  "maxPrice": <number_or_null>,
  "suggestedCategory": "<string_or_null>",
  "suggestedBrand": "<string_or_null>",
  "correctedTypo": "<string_or_null>"
}`,
    },
    SHOPPING_ASSISTANT: {
      key: 'SHOPPING_ASSISTANT',
      name: 'Sarah J. AI Assistant System Prompt',
      description: 'System prompt governing Sarah J. Enterprise AI Support & Shopping Assistant.',
      version: 1,
      template: `You are Sarah J., the Daily Basket Enterprise AI Customer Support & Shopping Executive.
You are warm, professional, empathetic, helpful, and speak like a real human support agent — not a bot.
Language Instruction: Respond in {{languageName}}.

=== DAILY BASKET PLATFORM KNOWLEDGE ===
- Daily Basket is India's fastest grocery delivery platform (10-minute express delivery).
- Minimum order: ₹99. Free delivery on orders above ₹299.
- Standard delivery fee: ₹29. Express (10-min): ₹49.
- Operating hours: 6:00 AM – 11:00 PM IST, 7 days a week.
- Freshness Policy: Zero-compromise. Damaged or stale items = instant 100% wallet refund.
- Wallet: Daily Basket Instant Wallet. Refunds credited within 2 minutes.

=== CURRENT SESSION CONTEXT ===
- App Route: {{route}}
- {{activeOrderContext}}
- {{cartContext}}

=== STRICT RULES ===
1. NEVER make up order IDs, refund amounts, wallet balances, or ETAs. Always call tools.
2. If a customer sends a photo of damaged items → apologize sincerely → call claimRefund.
3. If giving grocery or dietary advice, provide helpful nutritional context without giving medical advice.
4. Keep responses concise, warm, and structured with clear bullet points.`,
    },
    RECOMMENDATIONS: {
      key: 'RECOMMENDATIONS',
      name: 'Smart Recommendation Generator',
      description: 'Generates contextually relevant product recommendation rationale.',
      version: 1,
      template: `You are Daily Basket Recommendation Engine.
For user profile {{userProfile}} looking at product {{productName}}, recommend {{recType}} items.
Return rationale in 1 concise sentence highlighting value, health benefit, or pairing tip.`,
    },
    IMAGE_ANALYSIS: {
      key: 'IMAGE_ANALYSIS',
      name: 'Gemini Vision Product Analyzer',
      description: 'Analyzes grocery product images for identification, freshness, damage, and alternative recommendations.',
      version: 1,
      template: `You are a product quality analyst for Daily Basket quick-commerce.
Analyze the provided food/grocery product image and determine:
1. Product name and brand
2. Issue type (DAMAGED, SPOILED, WRONG_ITEM, QUALITY_ISSUE, OK)
3. Confidence score (0-100)
4. Recommended alternatives (Healthy, Budget, Organic)
5. Recipe suggestion using this product

Respond ONLY with valid JSON:
{
  "productDetected": "<name>",
  "brandDetected": "<brand>",
  "category": "<category>",
  "confidenceScore": <number>,
  "issueType": "<issue>",
  "finding": "<description>",
  "recommendation": "<action_message>",
  "suggestRefund": <boolean>,
  "suggestedRecipes": ["<recipe1>", "<recipe2>"]
}`,
    },
    RECIPE_GENERATION: {
      key: 'RECIPE_GENERATION',
      name: 'Recipe-to-Cart Converter',
      description: 'Converts dish names or recipe text into required grocery items.',
      version: 1,
      template: `You are Daily Basket AI Master Chef.
Convert recipe "{{recipeName}}" into exact grocery ingredients available for 10-minute delivery.
Respond ONLY with valid JSON listing ingredients, estimated quantities, and prep advice.`,
    },
    PRODUCT_COMPARISON: {
      key: 'PRODUCT_COMPARISON',
      name: 'Product AI Insight & Comparison',
      description: 'Generates product benefits, usage, storage, healthy choice ratings, and comparisons.',
      version: 1,
      template: `Analyze product "{{productName}}" (Category: {{categoryName}}, Price: ₹{{price}}).
Generate structured AI product insights in JSON:
{
  "benefits": ["<benefit1>", "<benefit2>"],
  "usage": "<usage instructions>",
  "storage": "<storage advice>",
  "healthyChoice": <boolean>,
  "healthScore": <number_1_to_10>,
  "bestFor": ["<use_case1>", "<use_case2>"],
  "servingSuggestions": "<serving suggestion>",
  "suitableAge": "<age group>",
  "nutritionalSummary": {"calories": "<val>", "protein": "<val>", "fat": "<val>", "carbs": "<val>"}
}`,
    },
  };

  constructor(private prisma: PrismaService) {}

  async onModuleInit() {
    await this.seedDefaultTemplates();
    await this.refreshCache();
  }

  private async seedDefaultTemplates() {
    try {
      for (const key of Object.keys(this.defaultTemplates)) {
        const def = this.defaultTemplates[key];
        await this.prisma.promptTemplate.upsert({
          where: { key },
          update: {},
          create: {
            key: def.key,
            name: def.name,
            template: def.template,
            description: def.description,
            version: def.version,
            isActive: true,
          },
        });
      }
      this.logger.log('Default prompt templates verified & seeded.');
    } catch (e) {
      this.logger.warn(`Prompt template seeding skipped or non-critical error: ${e.message}`);
    }
  }

  async refreshCache() {
    try {
      const templates = await this.prisma.promptTemplate.findMany({
        where: { isActive: true },
      });
      this.cache.clear();
      for (const t of templates) {
        this.cache.set(t.key, t.template);
      }
      this.logger.log(`Prompt cache refreshed with ${templates.length} templates.`);
    } catch (e) {
      this.logger.error(`Error refreshing prompt cache: ${e.message}`);
    }
  }

  async getTemplate(key: string): Promise<string> {
    if (this.cache.has(key)) {
      return this.cache.get(key)!;
    }
    const dbTemplate = await this.prisma.promptTemplate.findUnique({
      where: { key },
    });
    if (dbTemplate && dbTemplate.isActive) {
      this.cache.set(key, dbTemplate.template);
      return dbTemplate.template;
    }
    if (this.defaultTemplates[key]) {
      return this.defaultTemplates[key].template;
    }
    return '';
  }

  renderPrompt(templateString: string, variables: Record<string, any>): string {
    let result = templateString;
    for (const [k, v] of Object.entries(variables)) {
      const valStr = typeof v === 'object' ? JSON.stringify(v) : String(v ?? '');
      result = result.replace(new RegExp(`\\{\\{${k}\\}\\}`, 'g'), valStr);
    }
    return result;
  }

  async getAllTemplates() {
    return this.prisma.promptTemplate.findMany({
      orderBy: { updatedAt: 'desc' },
    });
  }

  async updateTemplate(key: string, template: string, name?: string, description?: string) {
    const updated = await this.prisma.promptTemplate.upsert({
      where: { key },
      update: {
        template,
        name: name || undefined,
        description: description || undefined,
        version: { increment: 1 },
        updatedAt: new Date(),
      },
      create: {
        key,
        name: name || key,
        template,
        description: description || '',
        version: 1,
        isActive: true,
      },
    });
    this.cache.set(key, template);
    return updated;
  }
}
