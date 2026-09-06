import { API_ROUTES } from '@daily-basket/constants';
import { Product, Category, Order, CartItem } from '@daily-basket/shared-types';

export class ApiClient {
  private baseUrl: string;
  private token: string | null = null;

  constructor(baseUrl?: string) {
    // Prefer an explicit argument, then the public runtime env var, then a local dev default.
    const envUrl =
      typeof process !== 'undefined' && process.env
        ? process.env.NEXT_PUBLIC_API_URL || process.env.API_BASE_URL
        : undefined;
    this.baseUrl = (baseUrl || envUrl || 'http://localhost:4000').replace(/\/$/, '');
  }

  public setAuthToken(token: string | null) {
    this.token = token;
  }

  private async fetcher<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...(options.headers as Record<string, string>),
    };

    if (this.token) {
      headers['Authorization'] = `Bearer ${this.token}`;
    }

    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      ...options,
      headers,
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
    }

    const payload = await response.json();
    // The API wraps successful responses in { success, statusCode, data, timestamp }.
    // Unwrap to the inner `data` so callers receive the domain object directly.
    if (
      payload &&
      typeof payload === 'object' &&
      'data' in payload &&
      'success' in payload
    ) {
      return (payload as { data: T }).data;
    }
    return payload as T;
  }

  // Auth Methods
  public async requestOtp(phoneNumber: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher(API_ROUTES.AUTH.LOGIN_OTP, {
      method: 'POST',
      body: JSON.stringify({ phoneNumber }),
    });
  }

  public async verifyOtp(phoneNumber: string, code: string): Promise<{ token: string; accessToken?: string; user: any }> {
    return this.fetcher(API_ROUTES.AUTH.VERIFY_OTP, {
      method: 'POST',
      body: JSON.stringify({ phoneNumber, code }),
    });
  }

  public async loginEmail(data: { email: string; pass: string }): Promise<{ token: string; accessToken: string; user: any }> {
    return this.fetcher('/api/v1/auth/login-email', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  public async registerEmail(data: { email: string; pass: string; name: string }): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/api/v1/auth/register-email', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  public async googleOAuthLogin(idToken: string): Promise<{ token: string; accessToken: string; user: any }> {
    return this.fetcher('/api/v1/auth/google-login', {
      method: 'POST',
      body: JSON.stringify({ idToken }),
    });
  }

  public async forgotPassword(email: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/api/v1/auth/forgot-password', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  }

  public async resetPassword(token: string, newPass: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/api/v1/auth/reset-password', {
      method: 'POST',
      body: JSON.stringify({ token, newPass }),
    });
  }

  public async verifyEmailToken(token: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/api/v1/auth/verify-email', {
      method: 'POST',
      body: JSON.stringify({ token }),
    });
  }


  // Catalog Methods
  public async getCategories(): Promise<Category[]> {
    return this.fetcher(API_ROUTES.PRODUCTS.CATEGORIES);
  }

  public async getProducts(categoryId?: string, query?: string): Promise<Product[]> {
    const params = new URLSearchParams();
    if (categoryId) params.append('categoryId', categoryId);
    if (query) params.append('query', query);
    const queryString = params.toString() ? `?${params.toString()}` : '';
    return this.fetcher(`${API_ROUTES.PRODUCTS.LIST}${queryString}`);
  }

  public async getProductDetails(id: string): Promise<Product> {
    return this.fetcher(API_ROUTES.PRODUCTS.DETAILS(id));
  }

  // Order Methods
  public async createOrder(orderPayload: {
    items: CartItem[];
    addressId: string;
    paymentMethod: string;
  }): Promise<Order> {
    return this.fetcher(API_ROUTES.ORDERS.CREATE, {
      method: 'POST',
      body: JSON.stringify(orderPayload),
    });
  }

  public async getOrderTracking(orderId: string): Promise<{
    order: Order;
    stepStatus: 'PACKING' | 'DISPATCHED' | 'OUT_FOR_DELIVERY' | 'DELIVERED';
    driverLocation?: { lat: number; lng: number };
    estimatedEtaMins: number;
  }> {
    return this.fetcher(API_ROUTES.ORDERS.TRACKING(orderId));
  }

  // Notifications & FCM Methods

  public async registerFcmToken(userId: string, token: string, platform?: string): Promise<{ success: boolean; registeredTokensCount: number }> {
    return this.fetcher('/api/v1/notifications/register-token', {
      method: 'POST',
      body: JSON.stringify({ userId, token, platform }),
    });
  }

  public async sendTestPushNotification(userId: string, title?: string, body?: string): Promise<{ success: boolean; messageId: string }> {
    return this.fetcher('/api/v1/notifications/test-push', {
      method: 'POST',
      body: JSON.stringify({ userId, title, body }),
    });
  }

  // Geofence & Delivery Methods
  public async evaluateGeofence(lat: number, lng: number, itemTotal?: number): Promise<any> {
    return this.fetcher('/api/v1/delivery/geofence-check', {
      method: 'POST',
      body: JSON.stringify({ lat, lng, itemTotal }),
    });
  }

  public async calculateSurgePricing(lat: number, lng: number, itemTotal?: number): Promise<any> {
    return this.fetcher('/api/v1/delivery/surge-pricing', {
      method: 'POST',
      body: JSON.stringify({ lat, lng, itemTotal }),
    });
  }

  public async syncOfflineDeliveryQueue(actions: any[]): Promise<{ success: boolean; syncedCount: number; processedActionIds: string[] }> {
    return this.fetcher('/api/v1/delivery/sync-offline-queue', {
      method: 'POST',
      body: JSON.stringify({ actions }),
    });
  }

  // Cart Methods (persistent, backend-validated totals)
  public async getCart(userId = 'usr_default'): Promise<any> {
    return this.fetcher(`/api/v1/cart?userId=${encodeURIComponent(userId)}`);
  }

  public async addToCart(
    item: { variantId: string; productName: string; unitName: string; price: number; quantity?: number },
    userId = 'usr_default',
  ): Promise<any> {
    return this.fetcher('/api/v1/cart/add', {
      method: 'POST',
      body: JSON.stringify({ ...item, userId }),
    });
  }

  public async updateCartItem(itemId: string, quantity: number, userId = 'usr_default'): Promise<any> {
    return this.fetcher(`/api/v1/cart/item/${itemId}`, {
      method: 'PATCH',
      body: JSON.stringify({ quantity, userId }),
    });
  }

  public async removeCartItem(itemId: string, userId = 'usr_default'): Promise<any> {
    return this.fetcher(`/api/v1/cart/item/${itemId}?userId=${encodeURIComponent(userId)}`, {
      method: 'DELETE',
    });
  }

  public async clearCart(userId = 'usr_default'): Promise<any> {
    return this.fetcher(`/api/v1/cart/clear?userId=${encodeURIComponent(userId)}`, {
      method: 'DELETE',
    });
  }

  // Coupon Methods
  public async getCoupons(): Promise<any> {
    return this.fetcher('/api/v1/coupons');
  }

  public async applyCoupon(
    code: string,
    cartSubtotal: number,
    userId = 'usr_default',
  ): Promise<{ success: boolean; valid: boolean; code: string; discountType: string; discountAmount: number; message: string }> {
    return this.fetcher('/api/v1/coupons/apply', {
      method: 'POST',
      body: JSON.stringify({ code, cartSubtotal, userId }),
    });
  }
}

export const apiClient = new ApiClient();

