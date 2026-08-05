import { Injectable, Logger } from '@nestjs/common';
import {
  AIProvider,
  ChatMessagePayload,
  ToolDefinition,
  AiResponse,
  AiStreamChunk,
} from '../interfaces/ai-provider.interface';
import { HealthChecker } from './health.checker';

@Injectable()
export class FallbackManager {
  private readonly logger = new Logger(FallbackManager.name);

  constructor(private healthChecker: HealthChecker) {}

  async executeWithFallback(
    providers: AIProvider[],
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): Promise<AiResponse> {
    const errors: string[] = [];

    for (const provider of providers) {
      const name = provider.getProviderName();
      const isHealthy = await this.healthChecker.checkProviderHealth(provider);

      if (!isHealthy) {
        this.logger.warn(`Skipping unhealthy provider: ${name}`);
        continue;
      }

      try {
        this.logger.log(`Executing request with provider: ${name}`);
        return await provider.generateResponse(messages, tools, context);
      } catch (err: any) {
        const msg = `Provider ${name} failed: ${err.message || err}`;
        this.logger.error(msg);
        errors.push(msg);
      }
    }

    throw new Error(
      `All AI providers failed. Summary of errors:\n${errors.join('\n')}`,
    );
  }

  async *streamWithFallback(
    providers: AIProvider[],
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): AsyncIterable<AiStreamChunk> {
    for (const provider of providers) {
      const name = provider.getProviderName();
      const isHealthy = await this.healthChecker.checkProviderHealth(provider);

      if (!isHealthy) {
        this.logger.warn(`Skipping unhealthy provider for stream: ${name}`);
        continue;
      }

      try {
        this.logger.log(`Streaming request with provider: ${name}`);
        yield* provider.generateStream(messages, tools, context);
        return;
      } catch (err: any) {
        this.logger.error(`Provider ${name} stream failed: ${err.message}`);
      }
    }

    // Default static fallback yield if all remote providers fail
    yield {
      type: 'content',
      content:
        'I am Daily Basket Support Assistant. How may I help you with your order, tracking, refunds, or coupons today?',
      providerUsed: 'FALLBACK',
    };
    yield { type: 'done', providerUsed: 'FALLBACK' };
  }
}
