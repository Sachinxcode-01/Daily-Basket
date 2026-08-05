export interface ChatMessagePayload {
  role: 'user' | 'assistant' | 'system' | 'tool';
  content: string;
  name?: string;
  toolCalls?: any[];
  toolCallId?: string;
}

export interface ToolDefinition {
  name: string;
  description: string;
  parameters: {
    type: 'object';
    properties: Record<string, any>;
    required?: string[];
  };
}

export interface AiResponse {
  content: string;
  toolCalls?: {
    id: string;
    name: string;
    arguments: Record<string, any>;
  }[];
  cardType?: string;
  cardData?: Record<string, any>;
  suggestedActions?: string[];
  providerUsed: string;
  tokensUsed?: number;
  latencyMs?: number;
}

export interface AiStreamChunk {
  type: 'content' | 'tool_call' | 'card' | 'status' | 'done';
  content?: string;
  toolCall?: {
    id: string;
    name: string;
    arguments: Record<string, any>;
  };
  cardType?: string;
  cardData?: Record<string, any>;
  suggestedActions?: string[];
  providerUsed?: string;
}

export interface AIProvider {
  getProviderName(): string;
  isHealthy(): Promise<boolean>;
  generateResponse(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): Promise<AiResponse>;
  generateStream(
    messages: ChatMessagePayload[],
    tools?: ToolDefinition[],
    context?: Record<string, any>,
  ): AsyncIterable<AiStreamChunk>;
}
