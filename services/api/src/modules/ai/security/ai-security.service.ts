import { Injectable, Logger, ForbiddenException } from '@nestjs/common';

@Injectable()
export class AiSecurityService {
  private readonly logger = new Logger(AiSecurityService.name);

  // Common prompt injection attack patterns
  private readonly injectionPatterns = [
    /ignore (all )?previous instructions/i,
    /disregard (all )?prior system (prompts|instructions)/i,
    /you are now in DAN mode/i,
    /override security protocols/i,
    /reveal (system prompt|secret keys|api keys)/i,
    /system:\s*role/i,
  ];

  sanitizeInput(input: string): string {
    if (!input) return '';
    // Strip control characters & excessive whitespace
    return input.replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, '').trim();
  }

  detectPromptInjection(input: string): boolean {
    for (const pattern of this.injectionPatterns) {
      if (pattern.test(input)) {
        this.logger.warn(`Prompt injection attempt detected: "${input}"`);
        return true;
      }
    }
    return false;
  }

  maskPii(text: string): string {
    if (!text) return '';
    let sanitized = text;

    // Mask Credit Card Numbers
    sanitized = sanitized.replace(
      /\b(?:\d[ -]*?){13,16}\b/g,
      '****-****-****-****',
    );

    // Mask Passwords or JWT Tokens
    sanitized = sanitized.replace(
      /eyJ[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*/g,
      '[REDACTED_JWT_TOKEN]',
    );

    return sanitized;
  }

  validateToolAccess(userRole: string, toolName: string): void {
    const adminOnlyTools = ['resetDatabase', 'deleteUserAccount', 'exportSystemLogs'];
    if (adminOnlyTools.includes(toolName) && userRole !== 'ADMIN') {
      throw new ForbiddenException(
        `Role ${userRole} is not authorized to execute tool ${toolName}`,
      );
    }
  }
}
