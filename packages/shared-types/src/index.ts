export enum UserRole {
  CUSTOMER = 'CUSTOMER',
  ADMIN = 'ADMIN',
  STORE_MANAGER = 'STORE_MANAGER',
  DELIVERY_PARTNER = 'DELIVERY_PARTNER',
}

export enum OrderStatus {
  CREATED = 'CREATED',
  CONFIRMED = 'CONFIRMED',
  PACKING = 'PACKING',
  READY_FOR_PICKUP = 'READY_FOR_PICKUP',
  OUT_FOR_DELIVERY = 'OUT_FOR_DELIVERY',
  DELIVERED = 'DELIVERED',
  CANCELLED = 'CANCELLED',
  REFUNDED = 'REFUNDED',
}

export enum PaymentMethod {
  UPI = 'UPI',
  CARD = 'CARD',
  NET_BANKING = 'NET_BANKING',
  WALLET = 'WALLET',
  CASH_ON_DELIVERY = 'CASH_ON_DELIVERY',
}

export enum PaymentStatus {
  PENDING = 'PENDING',
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED',
  REFUNDED = 'REFUNDED',
}

export interface ApiResponseEnvelope<T> {
  success: boolean;
  statusCode: number;
  data: T;
  meta?: {
    requestId?: string;
    timestamp: string;
    pagination?: {
      page: number;
      limit: number;
      totalItems: number;
      totalPages: number;
    };
  };
}

export interface User {
  id: string;
  phoneNumber: string;
  email?: string;
  fullName: string;
  role: UserRole;
  avatarUrl?: string;
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  imageUrl?: string;
  iconName?: string;
  parentId?: string;
  sortOrder: number;
  isActive: boolean;
}

export interface ProductVariant {
  id: string;
  productId: string;
  unitName: string;
  price: number;
  mrp: number;
  sku: string;
  stockQuantity: number;
  isAvailable: boolean;
}

export interface Product {
  id: string;
  storeId: string;
  categoryId: string;
  name: string;
  slug: string;
  description: string;
  images: string[];
  isOrganic?: boolean;
  tags: string[];
  variants: ProductVariant[];
  rating: number;
  reviewCount: number;
  createdAt: Date;
}

export interface CartItem {
  id: string;
  productId: string;
  variantId: string;
  productName: string;
  unitName: string;
  price: number;
  mrp: number;
  quantity: number;
  imageUrl?: string;
}

export interface Cart {
  items: CartItem[];
  itemCount: number;
  subtotal: number;
  discount: number;
  deliveryFee: number;
  handlingFee: number;
  tipAmount: number;
  couponDiscount: number;
  total: number;
}

export interface Address {
  id: string;
  userId: string;
  label: 'HOME' | 'WORK' | 'OTHER';
  houseNo: string;
  street: string;
  landmark?: string;
  city: string;
  pincode: string;
  latitude: number;
  longitude: number;
  isDefault: boolean;
}

export interface OrderItem {
  id: string;
  orderId: string;
  productId: string;
  variantId: string;
  productName: string;
  unitName: string;
  price: number;
  quantity: number;
  totalPrice: number;
}

export interface Order {
  id: string;
  orderNumber: string;
  storeId: string;
  userId: string;
  address: Address;
  items: OrderItem[];
  subtotal: number;
  deliveryFee: number;
  discount: number;
  totalAmount: number;
  status: OrderStatus;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  deliveryPartnerId?: string;
  estimatedArrivalMins: number;
  createdAt: Date;
}

export interface WalletTransaction {
  id: string;
  walletId: string;
  amount: number;
  type: 'CREDIT' | 'DEBIT';
  description: string;
  createdAt: Date;
}
