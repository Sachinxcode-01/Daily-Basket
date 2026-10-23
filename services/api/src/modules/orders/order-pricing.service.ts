import { Injectable } from '@nestjs/common';
import { CouponsService } from '../coupons/coupons.service';
import { PrismaService } from '../../database/prisma.service';
import { RedisService } from '../redis/redis.service';

export interface CalculatePricingDto {
  items: {
    id: string;
    productName: string;
    price: number;
    mrp?: number;
    quantity: number;
    categoryId?: string;
  }[];
  couponCode?: string;
  useWallet?: boolean;
  paymentMethod?: string;
  deliverySlot?: string;
  userWalletBalance?: number;
  userId?: string;
  storeId?: string;
  addressId?: string;
  customerCoordinates?: {
    latitude: number;
    longitude: number;
  };
  isRainMode?: boolean;
}

export interface OrderPricingResult {
  subtotal: number;
  itemDiscounts: number;
  couponDiscount: number;
  deliveryFee: number;
  surgeFee: number;
  rainFee: number;
  platformFee: number;
  packagingFee: number;
  cgst: number;
  sgst: number;
  totalGst: number;
  grandTotal: number;
  walletDeducted: number;
  finalPayable: number;
  selectedPaymentMethod: string;
  appliedCoupon: string | null;
  // Real-time Promise & Surge Engine (Blinkit System Design Pages 4, 10, 16)
  estimatedArrivalMins: number;
  promiseBadge: string;
  isSurgeApplied: boolean;
  isRainMode: boolean;
  surgeReason: string | null;
  storeLoadRatio: number;
  isSoftClosed: boolean;
  softCloseMessage: string | null;
  minOrderValue: number;
  isBelowMinOrder: boolean;
  paymentMethods: {
    id: string;
    name: string;
    badge: string | null;
    subtitle: string;
    iconName: string;
    isAvailable: boolean;
  }[];
  wallet: {
    availableBalance: number;
    deductedAmount: number;
    remainingBalance: number;
  };
}

function calculateHaversineDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // Earth's radius in km
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return +(R * c).toFixed(2);
}

@Injectable()
export class OrderPricingService {
  constructor(
    private readonly couponsService: CouponsService,
    private readonly prisma: PrismaService,
    private readonly redisService: RedisService,
  ) {}

  async calculatePricing(dto: CalculatePricingDto): Promise<OrderPricingResult> {
    const items = dto.items || [];
    const userWalletBalance = dto.userWalletBalance ?? 150.0;
    const selectedPaymentMethod = dto.paymentMethod || 'UPI';

    // 1. Calculate Subtotal & Item Savings
    let subtotal = 0;
    let itemDiscounts = 0;
    let totalItemsQuantity = 0;

    for (const item of items) {
      const qty = item.quantity || 1;
      totalItemsQuantity += qty;

      let itemPrice = item.price;
      let itemMrp = item.mrp;

      // Server-Authoritative Pricing: Validate variant price from database
      if (item.id) {
        try {
          const variant = await this.prisma.productVariant.findUnique({
            where: { id: item.id },
          });
          if (variant) {
            itemPrice = variant.price;
            itemMrp = variant.mrp ?? itemMrp;
          }
        } catch {
          // Keep item price fallback if database lookup fails
        }
      }

      const lineTotal = itemPrice * qty;
      subtotal += lineTotal;
      if (itemMrp && itemMrp > itemPrice) {
        itemDiscounts += (itemMrp - itemPrice) * qty;
      }
    }

    // 2. Resolve Store, Coordinates & Store Settings (Blinkit Micro-Fulfilment Engine)
    let store = dto.storeId ? await this.prisma.store.findUnique({ where: { id: dto.storeId } }) : null;
    if (!store) {
      store = await this.prisma.store.findFirst();
    }
    const storeId = store?.id || 'store_default';
    const storeLat = store?.latitude ?? 12.9716;
    const storeLng = store?.longitude ?? 77.5946;

    // Resolve Customer Coordinates if addressId provided
    let customerLat = dto.customerCoordinates?.latitude;
    let customerLng = dto.customerCoordinates?.longitude;
    if (!customerLat && dto.addressId) {
      const addr = await this.prisma.address.findUnique({ where: { id: dto.addressId } });
      if (addr) {
        customerLat = addr.latitude;
        customerLng = addr.longitude;
      }
    }

    const storeSettings = store ? await this.prisma.storeSettings.findUnique({ where: { storeId: store.id } }) : null;
    const storeCapacityPerHour = storeSettings?.storeCapacityPerHour ?? 60;
    const minOrderValue = storeSettings?.minOrderValue ?? 149.0;
    const isMaintenanceMode = storeSettings?.isMaintenanceMode ?? false;

    // 3. Query Real-Time Dark Store Load & Active Order Queue (Page 10 Promise Breakdown)
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
    let activeOrdersCount = 0;
    try {
      activeOrdersCount = await this.prisma.order.count({
        where: {
          storeId,
          status: { in: ['CONFIRMED', 'PACKING', 'READY_FOR_PICKUP'] },
          createdAt: { gte: oneHourAgo },
        },
      });
    } catch (_) {
      activeOrdersCount = 5;
    }

    // Query Redis for live operational flags (Rain Mode, Manual ETA Buffer, Soft-Close)
    const redisRainMode = await this.redisService.get(`dailybasket:store:${storeId}:rain_mode`);
    const redisBuffer = await this.redisService.get(`dailybasket:store:${storeId}:promise_buffer`);
    const redisSoftClosed = await this.redisService.get(`dailybasket:store:${storeId}:soft_closed`);

    const isRainMode = dto.isRainMode ?? (redisRainMode === 'true' || redisRainMode === true);
    const manualBuffer = typeof redisBuffer === 'number' ? redisBuffer : parseInt(String(redisBuffer || '0'), 10) || 0;
    const storeLoadRatio = +(activeOrdersCount / Math.max(1, storeCapacityPerHour)).toFixed(2);
    const isSoftClosed = redisSoftClosed === 'true' || redisSoftClosed === true || isMaintenanceMode || storeLoadRatio >= 1.0;
    const softCloseMessage = isSoftClosed
      ? 'High order demand in this dark store. Deliveries are temporarily paused to ensure accurate fulfilment.'
      : null;

    // 4. Compute Real-Time 10-Minute Promise ETA (Page 10 Formulation)
    // T_queue + T_pick_pack + T_rider_road + T_variability_buffer
    const queueMins = storeLoadRatio <= 0.4 ? 1 : storeLoadRatio <= 0.75 ? 2 : storeLoadRatio <= 0.9 ? 4 : 6;
    const pickPackMins = 2.0 + (totalItemsQuantity * 0.15);

    let riderTravelMins = 3.0;
    if (customerLat && customerLng) {
      const distanceKm = calculateHaversineDistance(storeLat, storeLng, customerLat, customerLng);
      riderTravelMins = 2.0 + (distanceKm * 1.8);
    }

    let bufferMins = 1.0 + manualBuffer;
    if (isRainMode) bufferMins += 5.0;
    if (storeLoadRatio > 0.8) bufferMins += 3.0;

    const rawEta = Math.round(queueMins + pickPackMins + riderTravelMins + bufferMins);
    const estimatedArrivalMins = Math.min(35, Math.max(8, rawEta));

    // Dynamic Promise Badge
    let promiseBadge = '10–12 MINS ⚡';
    if (isRainMode) {
      promiseBadge = `${estimatedArrivalMins - 2}–${estimatedArrivalMins + 3} MINS (Rain Mode 🌧️)`;
    } else if (estimatedArrivalMins <= 12) {
      promiseBadge = '10–12 MINS ⚡';
    } else if (estimatedArrivalMins <= 16) {
      promiseBadge = '12–15 MINS';
    } else if (estimatedArrivalMins <= 22) {
      promiseBadge = '15–20 MINS';
    } else {
      promiseBadge = `${estimatedArrivalMins - 2}–${estimatedArrivalMins + 3} MINS`;
    }

    // 5. Dynamic Surge & Rain Mode Fees (Page 16 Honest Levers)
    let surgeFee = 0;
    let surgeReason: string | null = null;
    let isSurgeApplied = false;

    if (storeLoadRatio > 0.8) {
      surgeFee = storeLoadRatio > 0.92 ? 25.0 : 15.0;
      surgeReason = 'High order surge in your dark store zone';
      isSurgeApplied = true;
    }

    const rainFee = isRainMode ? 20.0 : 0.0;

    // 6. Coupon Discount
    let couponDiscount = 0;
    let appliedCoupon: string | null = null;
    if (dto.couponCode) {
      try {
        const result = await this.couponsService.validateCoupon(
          dto.couponCode,
          subtotal,
          dto.userId || 'usr_default',
        );
        if (result?.valid) {
          couponDiscount = result.discountAmount;
          appliedCoupon = result.code;
        }
      } catch {
        couponDiscount = 0;
        appliedCoupon = null;
      }
    }

    // 7. Base Delivery Fee (Free delivery above ₹199, else ₹25)
    const baseDeliveryFee = subtotal >= 199 || subtotal === 0 ? 0 : 25.0;
    const totalDeliveryFee = +(baseDeliveryFee + surgeFee + rainFee).toFixed(2);

    // 8. Platform & Packaging Fees
    const platformFee = subtotal > 0 ? 3.0 : 0;
    const packagingFee = subtotal > 0 ? 5.0 : 0;

    // 9. GST Calculations (5% Total GST = 2.5% CGST + 2.5% SGST)
    const taxableAmount = Math.max(0, subtotal - couponDiscount);
    const cgst = +(taxableAmount * 0.025).toFixed(2);
    const sgst = +(taxableAmount * 0.025).toFixed(2);
    const totalGst = +(cgst + sgst).toFixed(2);

    // 10. Grand Total & Minimum Order Checks
    const grandTotal = +(subtotal + totalDeliveryFee + platformFee + packagingFee + totalGst - couponDiscount).toFixed(2);
    const isBelowMinOrder = subtotal > 0 && subtotal < minOrderValue;

    // 11. Wallet Deductions
    let walletDeducted = 0;
    if (dto.useWallet || selectedPaymentMethod === 'WALLET') {
      walletDeducted = Math.min(userWalletBalance, grandTotal);
    }
    walletDeducted = +walletDeducted.toFixed(2);

    // 12. Final Payable Amount
    const finalPayable = Math.max(0, +(grandTotal - walletDeducted).toFixed(2));

    // 13. Supported Payment Methods List
    const paymentMethods = [
      {
        id: 'UPI',
        name: 'UPI (Instant)',
        badge: 'FASTEST',
        subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
        iconName: 'bolt',
        isAvailable: true,
      },
      {
        id: 'CREDIT_CARD',
        name: 'Credit Card',
        badge: 'OFFERS',
        subtitle: 'Visa, Mastercard, AMEX, RuPay',
        iconName: 'credit_card',
        isAvailable: true,
      },
      {
        id: 'DEBIT_CARD',
        name: 'Debit Card',
        badge: null,
        subtitle: 'All Indian bank debit cards',
        iconName: 'credit_card',
        isAvailable: true,
      },
      {
        id: 'NETBANKING',
        name: 'Net Banking',
        badge: null,
        subtitle: 'HDFC, SBI, ICICI, Axis & 50+ Banks',
        iconName: 'account_balance',
        isAvailable: true,
      },
      {
        id: 'WALLET',
        name: 'Daily Basket Wallet',
        badge: '₹150 BALANCE',
        subtitle: 'Instant 1-click checkout',
        iconName: 'account_balance_wallet',
        isAvailable: userWalletBalance > 0,
      },
      {
        id: 'COD',
        name: 'Cash on Delivery',
        badge: null,
        subtitle: 'Pay cash or UPI at delivery doorstep',
        iconName: 'payments',
        isAvailable: true,
      },
      {
        id: 'EMI',
        name: 'Easy EMI',
        badge: '3-12 MONTHS',
        subtitle: 'Credit Card EMI & No Cost EMI',
        iconName: 'calendar_month',
        isAvailable: grandTotal >= 1999,
      },
    ];

    return {
      subtotal,
      itemDiscounts,
      couponDiscount,
      deliveryFee: totalDeliveryFee,
      surgeFee,
      rainFee,
      platformFee,
      packagingFee,
      cgst,
      sgst,
      totalGst,
      grandTotal,
      walletDeducted,
      finalPayable,
      selectedPaymentMethod,
      appliedCoupon,
      // Real-time Promise & Surge Breakdown (Blinkit System Design Pages 4, 10, 16)
      estimatedArrivalMins,
      promiseBadge,
      isSurgeApplied,
      isRainMode,
      surgeReason,
      storeLoadRatio,
      isSoftClosed,
      softCloseMessage,
      minOrderValue,
      isBelowMinOrder,
      paymentMethods,
      wallet: {
        availableBalance: userWalletBalance,
        deductedAmount: walletDeducted,
        remainingBalance: +(userWalletBalance - walletDeducted).toFixed(2),
      },
    };
  }
}
