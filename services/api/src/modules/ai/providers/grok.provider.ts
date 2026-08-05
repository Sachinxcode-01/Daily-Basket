import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  AIProvider,
  ChatMessagePayload,
  ToolDefinition,
  AiResponse,
  AiStreamChunk,
} from '../interfaces/ai-provider.interface';
import { RetryManager } from '../managers/retry.manager';

@Injectable()
export class GrokProvider implements AIProvider {
  private readonly logger = new Logger(GrokProvider.name);
  private readonly apiKey: string;
  private readonly modelName: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('GROK_API_KEY') || '';
    this.modelName =
      this.configService.get<string>('GROK_MODEL') || 'grok-beta';
  }

  getProviderName(): string {
    return 'GROK';
  }

  async isHealthy(): Promise<boolean> {
    if (!this.apiKey) return false;
    try {
      const res = await fetch('https://api.x.ai/v1/models', {
        headers: { Authorization: `Bearer ${this.apiKey}` },
      });
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
    if (!this.apiKey) {
      throw new Error('GROK_API_KEY is missing or unconfigured');
    }

    const startTime = Date.now();
    return RetryManager.executeWithRetry(async () => {
      const body: any = {
        model: this.modelName,
        messages: messages.map((m) => ({
          role: m.role,
          content: m.content,
        })),
        temperature: 0.3,
      };

      if (tools && tools.length > 0) {
        body.tools = tools.map((t) => ({
          type: 'function',
          function: {
            name: t.name,
            description: t.description,
            parameters: t.parameters,
          },
        }));
      }

      const response = await fetch('https://api.x.ai/v1/chat/completions', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Grok API error ${response.status}: ${errorText}`);
      }

      const data = await response.json();
      const choice = data.choices?.[0]?.message;
      const latencyMs = Date.now() - startTime;

      if (choice?.tool_calls && choice.tool_calls.length > 0) {
        return {
          content: choice.content || '',
          toolCalls: choice.tool_calls.map((tc: any) => ({
            id: tc.id,
            name: tc.function.name,
            arguments: JSON.parse(tc.function.arguments || '{}'),
          })),
          providerUsed: this.getProviderName(),
          tokensUsed: data.usage?.total_tokens || 0,
          latencyMs,
        };
      }

      return {
        content: choice?.content || 'Hello! How may I assist you with Daily Basket?',
        providerUsed: this.getProviderName(),
        tokensUsed: data.usage?.total_tokens || 0,
        latencyMs,
      };
    });
  }

  async *generateStream(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): AsyncIterable<AiStreamChunk> {
    yield {
      type: 'status',
      content: 'Connecting to Grok...',
      providerUsed: this.getProviderName(),
    };

    try {
      const response = await this.generateResponse(messages, tools, context);

      if (response.toolCalls && response.toolCalls.length > 0) {
        for (const tc of response.toolCalls) {
          yield {
            type: 'tool_call',
            toolCall: tc,
            providerUsed: this.getProviderName(),
          };
        }
      }

      if (response.content) {
        const words = response.content.split(' ');
        for (let i = 0; i < words.length; i += 3) {
          yield {
            type: 'content',
            content: words.slice(i, i + 3).join(' ') + ' ',
            providerUsed: this.getProviderName(),
          };
          await new Promise((res) => setTimeout(res, 30));
        }
      }

      yield { type: 'done', providerUsed: this.getProviderName() };
    } catch (err: any) {
      this.logger.error(`Grok stream error: ${err.message}`);
      throw err;
    }
  }
}
