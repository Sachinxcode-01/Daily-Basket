export const APP_NAME = 'Daily Basket';
export const DELIVERY_PROMISE_MINS = 10;
export const FREE_DELIVERY_THRESHOLD = 199;
export const STORE_DEFAULT_ID = 'store_main_01';

export const API_ROUTES = {
  AUTH: {
    LOGIN_OTP: '/api/v1/auth/login-otp',
    VERIFY_OTP: '/api/v1/auth/verify-otp',
    REFRESH_TOKEN: '/api/v1/auth/refresh',
    LOGOUT: '/api/v1/auth/logout',
  },
  PRODUCTS: {
    LIST: '/api/v1/products',
    DETAILS: (id: string) => `/api/v1/products/${id}`,
    CATEGORIES: '/api/v1/categories',
    SEARCH: '/api/v1/search',
  },
  ORDERS: {
    CREATE: '/api/v1/orders',
    LIST: '/api/v1/orders',
    DETAILS: (id: string) => `/api/v1/orders/${id}`,
    TRACKING: (id: string) => `/api/v1/orders/${id}/tracking`,
  },
  PAYMENTS: {
    INITIATE: '/api/v1/payments/initiate',
    VERIFY: '/api/v1/payments/verify',
  },
  ADMIN: {
    INVENTORY: '/api/v1/admin/inventory',
    ORDERS: '/api/v1/admin/orders',
    ANALYTICS: '/api/v1/admin/analytics',
  },
};

export const ERROR_CODES = {
  UNAUTHORIZED: 'ERR_AUTH_UNAUTHORIZED',
  PRODUCT_NOT_FOUND: 'ERR_PRODUCT_NOT_FOUND',
  OUT_OF_STOCK: 'ERR_OUT_OF_STOCK',
  PAYMENT_FAILED: 'ERR_PAYMENT_FAILED',
  STORE_CLOSED: 'ERR_STORE_CLOSED',
  INVALID_COUPON: 'ERR_INVALID_COUPON',
};
