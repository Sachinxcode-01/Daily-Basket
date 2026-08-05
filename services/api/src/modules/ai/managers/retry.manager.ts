import { Logger } from '@nestjs/common';

export interface RetryOptions {
  maxRetries?: number;
  initialDelayMs?: number;
  maxDelayMs?: number;
  backoffFactor?: number;
}

export class RetryManager {
  private static readonly logger = new Logger('RetryManager');

  static async executeWithRetry<T>(
    fn: () => Promise<T>,
    options: RetryOptions = {},
  ): Promise<T> {
    const maxRetries = options.maxRetries ?? 3;
    const initialDelayMs = options.initialDelayMs ?? 500;
    const maxDelayMs = options.maxDelayMs ?? 4000;
    const backoffFactor = options.backoffFactor ?? 2;

    let attempt = 0;
    let delay = initialDelayMs;

    while (attempt < maxRetries) {
      try {
        return await fn();
      } catch (error: any) {
        attempt++;
        if (attempt >= maxRetries) {
          this.logger.error(
            `Operation failed after ${attempt} attempts: ${error?.message || error}`,
          );
          throw error;
        }

        const jitter = Math.random() * 200;
        const currentDelay = Math.min(delay + jitter, maxDelayMs);

        this.logger.warn(
          `Attempt ${attempt} failed: ${error?.message || error}. Retrying in ${Math.round(currentDelay)}ms...`,
        );

        await new Promise((resolve) => setTimeout(resolve, currentDelay));
        delay *= backoffFactor;
      }
    }

    throw new Error('Retry exhausted');
  }
}
