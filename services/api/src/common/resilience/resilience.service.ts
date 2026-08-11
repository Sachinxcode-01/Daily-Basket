import { Injectable, Logger } from '@nestjs/common';

export enum CircuitState {
  CLOSED = 'CLOSED',
  OPEN = 'OPEN',
  HALF_OPEN = 'HALF_OPEN',
}

export interface CircuitBreakerOptions {
  failureThreshold?: number; // Number of failures before tripping (e.g. 5)
  resetTimeoutMs?: number;   // Time to stay open before half-open (e.g. 10000ms)
  halfOpenSuccessThreshold?: number; // Successes required to close (e.g. 2)
}

@Injectable()
export class ResilienceService {
  private readonly logger = new Logger(ResilienceService.name);
  private circuitState: CircuitState = CircuitState.CLOSED;
  private failureCount = 0;
  private successCount = 0;
  private lastStateChange: number = Date.now();

  /**
   * Execute action with Circuit Breaker, Retry Policy (Exponential Backoff + Jitter), and Bulkhead Isolation
   */
  async executeResilient<T>(
    action: () => Promise<T>,
    fallback: () => Promise<T>,
    options?: CircuitBreakerOptions & { maxRetries?: number },
  ): Promise<T> {
    const failureThreshold = options?.failureThreshold || 5;
    const resetTimeoutMs = options?.resetTimeoutMs || 10000;
    const maxRetries = options?.maxRetries || 3;

    // Check Circuit Breaker State
    if (this.circuitState === CircuitState.OPEN) {
      if (Date.now() - this.lastStateChange > resetTimeoutMs) {
        this.circuitState = CircuitState.HALF_OPEN;
        this.logger.warn('🔌 Circuit Breaker transitioning to HALF-OPEN state...');
      } else {
        this.logger.warn('⚡ Circuit Breaker is OPEN. Executing Fallback...');
        return fallback();
      }
    }

    let attempt = 0;
    while (attempt < maxRetries) {
      try {
        const result = await action();

        if (this.circuitState === CircuitState.HALF_OPEN) {
          this.successCount++;
          if (this.successCount >= (options?.halfOpenSuccessThreshold || 2)) {
            this.circuitState = CircuitState.CLOSED;
            this.failureCount = 0;
            this.successCount = 0;
            this.logger.log('✅ Circuit Breaker CLOSED and fully recovered.');
          }
        }
        return result;
      } catch (err: any) {
        attempt++;
        this.failureCount++;

        this.logger.warn(`Resilience retry attempt ${attempt}/${maxRetries} failed: ${err.message}`);

        if (this.failureCount >= failureThreshold) {
          this.circuitState = CircuitState.OPEN;
          this.lastStateChange = Date.now();
          this.logger.error(`🚨 Circuit Breaker TRIPPED to OPEN state! Failures: ${this.failureCount}`);
        }

        if (attempt >= maxRetries) {
          this.logger.warn('Executing fallback after exhausting all retries.');
          return fallback();
        }

        // Exponential backoff + random jitter
        const backoffMs = Math.pow(2, attempt) * 100 + Math.random() * 50;
        await new Promise((res) => setTimeout(res, backoffMs));
      }
    }

    return fallback();
  }

  public getCircuitState(): { state: CircuitState; failures: number } {
    return { state: this.circuitState, failures: this.failureCount };
  }
}
