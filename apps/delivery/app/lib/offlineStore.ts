export interface QueuedOfflineAction {
  id: string;
  type: 'STATUS_UPDATE' | 'OTP_VERIFICATION' | 'TELEMETRY';
  orderId: string;
  payload: Record<string, any>;
  timestamp: string;
}

const OFFLINE_QUEUE_KEY = 'daily_basket_delivery_offline_queue';

export class OfflineSyncEngine {
  /**
   * Retrieve all pending queued offline actions
   */
  static getQueue(): QueuedOfflineAction[] {
    if (typeof window === 'undefined') return [];
    try {
      const raw = localStorage.getItem(OFFLINE_QUEUE_KEY);
      return raw ? JSON.parse(raw) : [];
    } catch {
      return [];
    }
  }

  /**
   * Enqueue a new offline action when network is disconnected
   */
  static enqueueAction(
    type: 'STATUS_UPDATE' | 'OTP_VERIFICATION' | 'TELEMETRY',
    orderId: string,
    payload: Record<string, any>,
  ): QueuedOfflineAction {
    const action: QueuedOfflineAction = {
      id: `act_${Date.now()}_${Math.random().toString(36).substring(7)}`,
      type,
      orderId,
      payload,
      timestamp: new Date().toISOString(),
    };

    const queue = this.getQueue();
    queue.push(action);
    if (typeof window !== 'undefined') {
      localStorage.setItem(OFFLINE_QUEUE_KEY, JSON.stringify(queue));
    }
    return action;
  }

  /**
   * Clear or filter processed actions from queue
   */
  static clearQueue(processedIds?: string[]) {
    if (typeof window === 'undefined') return;
    if (!processedIds || processedIds.length === 0) {
      localStorage.removeItem(OFFLINE_QUEUE_KEY);
      return;
    }

    const currentQueue = this.getQueue();
    const remaining = currentQueue.filter((item) => !processedIds.includes(item.id));
    localStorage.setItem(OFFLINE_QUEUE_KEY, JSON.stringify(remaining));
  }

  /**
   * Flush and sync queued offline actions to backend NestJS API
   */
  static async flushQueue(
    apiBaseUrl: string = (typeof process !== 'undefined' && (process.env?.NEXT_PUBLIC_API_URL || process.env?.API_BASE_URL)) || 'http://localhost:4000',
  ): Promise<{
    syncedCount: number;
    failedCount: number;
  }> {
    const queue = this.getQueue();
    if (queue.length === 0) return { syncedCount: 0, failedCount: 0 };

    const cleanBase = apiBaseUrl.replace(/\/$/, '');
    const endpoint = cleanBase.includes('/api/v1')
      ? `${cleanBase}/delivery/sync-offline-queue`
      : `${cleanBase}/api/v1/delivery/sync-offline-queue`;

    try {
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ actions: queue }),
      });

      if (response.ok) {
        const data = await response.json();
        const processedIds = data.processedActionIds || queue.map((q) => q.id);
        this.clearQueue(processedIds);
        return { syncedCount: processedIds.length, failedCount: 0 };
      }
    } catch (error) {
      console.warn('⚠️ [OfflineSyncEngine] Failed to connect to server during sync flush:', error);
    }

    return { syncedCount: 0, failedCount: queue.length };
  }
}
