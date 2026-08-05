import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AiController } from './ai.controller';
import { AiService } from './ai.service';
import { PrismaService } from '../../database/prisma.service';

// Providers
import { GeminiProvider } from './providers/gemini.provider';
import { OpenRouterProvider } from './providers/openrouter.provider';
import { GrokProvider } from './providers/grok.provider';
import { LocalProvider } from './providers/local.provider';

// Managers
import { ProviderManager } from './managers/provider.manager';
import { FallbackManager } from './managers/fallback.manager';
import { HealthChecker } from './managers/health.checker';

// Tools & Security
import { AiToolsRegistry } from './tools/ai-tools.registry';
import { AiSecurityService } from './security/ai-security.service';

@Module({
  imports: [ConfigModule],
  controllers: [AiController],
  providers: [
    AiService,
    PrismaService,
    GeminiProvider,
    OpenRouterProvider,
    GrokProvider,
    LocalProvider,
    ProviderManager,
    FallbackManager,
    HealthChecker,
    AiToolsRegistry,
    AiSecurityService,
  ],
  exports: [
    AiService,
    ProviderManager,
    FallbackManager,
    HealthChecker,
    AiToolsRegistry,
    AiSecurityService,
  ],
})
export class AiModule {}
