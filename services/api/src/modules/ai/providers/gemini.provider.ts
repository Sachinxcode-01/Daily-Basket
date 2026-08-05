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
export class GeminiProvider implements AIProvider {
  private readonly logger = new Logger(GeminiProvider.name);
  private readonly apiKey: string;
  private readonly modelName: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('GEMINI_API_KEY') || '';
    this.modelName =
      this.configService.get<string>('GEMINI_MODEL') || 'gemini-1.5-flash';
  }

  getProviderName(): string {
    return 'GEMINI';
  }

  async isHealthy(): Promise<boolean> {
    if (!this.apiKey) return false;
    try {
      const url = `https://generativelanguage.googleapis.com/v1beta/models?key=${this.apiKey}`;
      const res = await fetch(url, { method: 'GET' });
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
      throw new Error('GEMINI_API_KEY is missing or unconfigured');
    }

    const startTime = Date.now();
    return RetryManager.executeWithRetry(async () => {
      const systemMsg = messages.find((m) => m.role === 'system')?.content || '';

      // Build contents with optional multimodal (Vision) support
      const contents = messages
        .filter((m) => m.role !== 'system')
        .map((m) => {
          const parts: any[] = [{ text: m.content }];

          // Inject image inline_data part if this is the user message and image context exists
          if (m.role === 'user' && context?.imageBase64) {
            parts.push({
              inline_data: {
                mime_type: context.mimeType || 'image/jpeg',
                data: context.imageBase64,
              },
            });
          }

          // Inject audio inline_data part for voice transcription context
          if (m.role === 'user' && context?.audioBase64) {
            parts.push({
              inline_data: {
                mime_type: 'audio/wav',
                data: context.audioBase64,
              },
            });
          }

          return {
            role: m.role === 'assistant' ? 'model' : 'user',
            parts,
          };
        });

      // Select vision-capable model if image/audio context is provided
      const activeModel =
        context?.imageBase64 || context?.audioBase64
          ? 'gemini-1.5-pro'
          : this.modelName;

      const body: any = {
        contents,
        generationConfig: {
          temperature: 0.3,
          maxOutputTokens: 1200,
        },
      };

      if (systemMsg) {
        body.systemInstruction = {
          parts: [{ text: systemMsg }],
        };
      }

      if (tools && tools.length > 0) {
        body.tools = [
          {
            functionDeclarations: tools.map((t) => ({
              name: t.name,
              description: t.description,
              parameters: t.parameters,
            })),
          },
        ];
      }

      const url = `https://generativelanguage.googleapis.com/v1beta/models/${activeModel}:generateContent?key=${this.apiKey}`;
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Gemini API error ${response.status}: ${errorText}`);
      }

      const data = await response.json();
      const candidate = data.candidates?.[0];
      const part = candidate?.content?.parts?.[0];
      const latencyMs = Date.now() - startTime;

      if (part?.functionCall) {
        return {
          content: '',
          toolCalls: [
            {
              id: `call_${Date.now()}`,
              name: part.functionCall.name,
              arguments: part.functionCall.args || {},
            },
          ],
          providerUsed: this.getProviderName(),
          tokensUsed: data.usageMetadata?.totalTokenCount || 0,
          latencyMs,
        };
      }

      const text = part?.text || 'I am ready to help you with Daily Basket!';
      return {
        content: text,
        providerUsed: this.getProviderName(),
        tokensUsed: data.usageMetadata?.totalTokenCount || 0,
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
      content: 'Thinking...',
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
        // Stream 1-2 words at a time for smooth typewriter effect
        const words = response.content.split(' ');
        for (let i = 0; i < words.length; i++) {
          const chunkText = words[i] + (i < words.length - 1 ? ' ' : '');
          yield {
            type: 'content',
            content: chunkText,
            providerUsed: this.getProviderName(),
          };
          await new Promise((res) => setTimeout(res, 35));
        }
      }

      yield { type: 'done', providerUsed: this.getProviderName() };
    } catch (err: any) {
      this.logger.error(`Gemini stream error: ${err.message}`);
      throw err;
    }
  }
}
