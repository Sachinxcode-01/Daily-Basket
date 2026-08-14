import { API_ROUTES } from '@daily-basket/constants';
import { Product, Category, Order, CartItem } from '@daily-basket/shared-types';

export class ApiClient {
  private baseUrl: string;
  private token: string | null = null;

  constructor(baseUrl = 'http://localhost:4000') {
    this.baseUrl = baseUrl;
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

    return response.json();
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
    return this.fetcher('/auth/login-email', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  public async registerEmail(data: { email: string; pass: string; name: string }): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/auth/register-email', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  public async googleOAuthLogin(idToken: string): Promise<{ token: string; accessToken: string; user: any }> {
    return this.fetcher('/auth/google-login', {
      method: 'POST',
      body: JSON.stringify({ idToken }),
    });
  }

  public async forgotPassword(email: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/auth/forgot-password', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  }

  public async resetPassword(token: string, newPass: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/auth/reset-password', {
      method: 'POST',
      body: JSON.stringify({ token, newPass }),
    });
  }

  public async verifyEmailToken(token: string): Promise<{ success: boolean; message: string }> {
    return this.fetcher('/auth/verify-email', {
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
    return this.fetcher('/notifications/register-token', {
      method: 'POST',
      body: JSON.stringify({ userId, token, platform }),
    });
  }

  public async sendTestPushNotification(userId: string, title?: string, body?: string): Promise<{ success: boolean; messageId: string }> {
    return this.fetcher('/notifications/test-push', {
      method: 'POST',
      body: JSON.stringify({ userId, title, body }),
    });
  }

  // Geofence & Delivery Methods
  public async evaluateGeofence(lat: number, lng: number, itemTotal?: number): Promise<any> {
    return this.fetcher('/delivery/geofence-check', {
      method: 'POST',
      body: JSON.stringify({ lat, lng, itemTotal }),
    });
  }

  public async calculateSurgePricing(lat: number, lng: number, itemTotal?: number): Promise<any> {
    return this.fetcher('/delivery/surge-pricing', {
      method: 'POST',
      body: JSON.stringify({ lat, lng, itemTotal }),
    });
  }

  public async syncOfflineDeliveryQueue(actions: any[]): Promise<{ success: boolean; syncedCount: number; processedActionIds: string[] }> {
    return this.fetcher('/delivery/sync-offline-queue', {
      method: 'POST',
      body: JSON.stringify({ actions }),
    });
  }
}

export const apiClient = new ApiClient();

