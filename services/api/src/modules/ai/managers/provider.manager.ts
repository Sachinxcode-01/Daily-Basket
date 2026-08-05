import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  AIProvider,
  ChatMessagePayload,
  ToolDefinition,
  AiResponse,
  AiStreamChunk,
} from '../interfaces/ai-provider.interface';
import { GeminiProvider } from '../providers/gemini.provider';
import { OpenRouterProvider } from '../providers/openrouter.provider';
import { GrokProvider } from '../providers/grok.provider';
import { LocalProvider } from '../providers/local.provider';
import { FallbackManager } from './fallback.manager';
import { HealthChecker } from './health.checker';

@Injectable()
export class ProviderManager implements OnModuleInit {
  private readonly logger = new Logger(ProviderManager.name);
  private providersInPriorityOrder: AIProvider[] = [];

  constructor(
    private configService: ConfigService,
    private geminiProvider: GeminiProvider,
    private openRouterProvider: OpenRouterProvider,
    private grokProvider: GrokProvider,
    private localProvider: LocalProvider,
    private fallbackManager: FallbackManager,
    private healthChecker: HealthChecker,
  ) {}

  onModuleInit() {
    // Register in exact priority order: 1. Gemini, 2. OpenRouter, 3. Grok, 4. Local
    this.providersInPriorityOrder = [
      this.geminiProvider,
      this.openRouterProvider,
      this.grokProvider,
      this.localProvider,
    ];

    this.logger.log(
      `AI Provider Priority Stack initialized: ${this.providersInPriorityOrder
        .map((p) => p.getProviderName())
        .join(' -> ')}`,
    );
  }

  getProviders(): AIProvider[] {
    return this.providersInPriorityOrder;
  }

  async generateResponse(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): Promise<AiResponse> {
    return this.fallbackManager.executeWithFallback(
      this.providersInPriorityOrder,
      messages,
      tools,
      context,
    );
  }

  async *generateStream(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): AsyncIterable<AiStreamChunk> {
    yield* this.fallbackManager.streamWithFallback(
      this.providersInPriorityOrder,
      messages,
      tools,
      context,
    );
  }

  async getHealthStatus(): Promise<Record<string, boolean>> {
    for (const provider of this.providersInPriorityOrder) {
      await this.healthChecker.checkProviderHealth(provider);
    }
    return this.healthChecker.getHealthSummary();
  }
}
