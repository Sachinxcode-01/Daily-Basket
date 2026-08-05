import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  AIProvider,
  ChatMessagePayload,
  ToolDefinition,
  AiResponse,
  AiStreamChunk,
} from '../interfaces/ai-provider.interface';

@Injectable()
export class LocalProvider implements AIProvider {
  private readonly logger = new Logger(LocalProvider.name);
  private readonly baseUrl: string;
  private readonly modelName: string;

  constructor(private configService: ConfigService) {
    this.baseUrl =
      this.configService.get<string>('LOCAL_MODEL_URL') ||
      'http://localhost:11434';
    this.modelName =
      this.configService.get<string>('LOCAL_MODEL_NAME') || 'llama3';
  }

  getProviderName(): string {
    return 'LOCAL';
  }

  async isHealthy(): Promise<boolean> {
    try {
      const res = await fetch(`${this.baseUrl}/api/tags`, { method: 'GET' });
      return res.ok;
    } catch {
      return false;
    }
  }

  async generateResponse(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): Promise<AiResponse> {
    const startTime = Date.now();
    try {
      const response = await fetch(`${this.baseUrl}/api/chat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          model: this.modelName,
          messages: messages.map((m) => ({
            role: m.role,
            content: m.content,
          })),
          stream: false,
        }),
      });

      if (!response.ok) {
        throw new Error(`Local model error ${response.status}`);
      }

      const data = await response.json();
      const latencyMs = Date.now() - startTime;

      return {
        content:
          data.message?.content ||
          'Hello! I am your local Daily Basket assistant.',
        providerUsed: this.getProviderName(),
        tokensUsed: data.eval_count || 0,
        latencyMs,
      };
    } catch (err: any) {
      this.logger.warn(`Local model fallback fallback message: ${err.message}`);
      return {
        content:
          'Welcome to Daily Basket priority support! I am available to assist you with order status, tracking, coupons, and account inquiries.',
        providerUsed: this.getProviderName(),
        latencyMs: Date.now() - startTime,
      };
    }
  }

  async *generateStream(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): AsyncIterable<AiStreamChunk> {
    yield {
      type: 'status',
      content: 'Processing locally...',
      providerUsed: this.getProviderName(),
    };

    const response = await this.generateResponse(messages, tools, context);
    const words = response.content.split(' ');
    for (let i = 0; i < words.length; i += 3) {
      yield {
        type: 'content',
        content: words.slice(i, i + 3).join(' ') + ' ',
        providerUsed: this.getProviderName(),
      };
      await new Promise((res) => setTimeout(res, 20));
    }
    yield { type: 'done', providerUsed: this.getProviderName() };
  }
}
