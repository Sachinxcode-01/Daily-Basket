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

  public async verifyOtp(phoneNumber: string, code: string): Promise<{ token: string; user: any }> {
    return this.fetcher(API_ROUTES.AUTH.VERIFY_OTP, {
      method: 'POST',
      body: JSON.stringify({ phoneNumber, code }),
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
}

export const apiClient = new ApiClient();
