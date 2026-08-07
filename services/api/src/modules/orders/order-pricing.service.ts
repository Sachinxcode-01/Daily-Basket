import { Injectable } from '@nestjs/common';

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
}

export interface OrderPricingResult {
  subtotal: number;
  itemDiscounts: number;
  couponDiscount: number;
  deliveryFee: number;
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

@Injectable()
export class OrderPricingService {
  calculatePricing(dto: CalculatePricingDto): OrderPricingResult {
    const items = dto.items || [];
    const userWalletBalance = dto.userWalletBalance ?? 150.0;
    const selectedPaymentMethod = dto.paymentMethod || 'UPI';

    // 1. Calculate Subtotal & Item Savings
    let subtotal = 0;
    let itemDiscounts = 0;

    for (const item of items) {
      const lineTotal = item.price * item.quantity;
      subtotal += lineTotal;
      if (item.mrp && item.mrp > item.price) {
        itemDiscounts += (item.mrp - item.price) * item.quantity;
      }
    }

    // 2. Coupon Discount Calculation
    let couponDiscount = 0;
    let appliedCoupon: string | null = null;
    if (dto.couponCode) {
      const code = dto.couponCode.toUpperCase().trim();
      if (code === 'DAILY50' && subtotal >= 199) {
        couponDiscount = 50.0;
        appliedCoupon = 'DAILY50';
      } else if (code === 'FRESH20' && subtotal >= 299) {
        couponDiscount = +(subtotal * 0.2).toFixed(2);
        appliedCoupon = 'FRESH20';
      } else if (code === 'WELCOME100' && subtotal >= 499) {
        couponDiscount = 100.0;
        appliedCoupon = 'WELCOME100';
      }
    }

    // 3. Dynamic Delivery Fee Rules
    // Free delivery above ₹199, else ₹25
    const deliveryFee = subtotal >= 199 || subtotal === 0 ? 0 : 25.0;

    // 4. Platform & Packaging Fees
    const platformFee = subtotal > 0 ? 3.0 : 0;
    const packagingFee = subtotal > 0 ? 5.0 : 0;

    // 5. GST Calculations (5% Total GST = 2.5% CGST + 2.5% SGST)
    const taxableAmount = Math.max(0, subtotal - couponDiscount);
    const cgst = +(taxableAmount * 0.025).toFixed(2);
    const sgst = +(taxableAmount * 0.025).toFixed(2);
    const totalGst = +(cgst + sgst).toFixed(2);

    // 6. Grand Total
    const grandTotal = +(subtotal + deliveryFee + platformFee + packagingFee + totalGst - couponDiscount).toFixed(2);

    // 7. Wallet Deductions
    let walletDeducted = 0;
    if (dto.useWallet || selectedPaymentMethod === 'WALLET') {
      walletDeducted = Math.min(userWalletBalance, grandTotal);
    }
    walletDeducted = +walletDeducted.toFixed(2);

    // 8. Final Payable Amount
    const finalPayable = Math.max(0, +(grandTotal - walletDeducted).toFixed(2));

    // 9. Supported Payment Methods List
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
      deliveryFee,
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
      paymentMethods,
      wallet: {
        availableBalance: userWalletBalance,
        deductedAmount: walletDeducted,
        remainingBalance: +(userWalletBalance - walletDeducted).toFixed(2),
      },
    };
  }
}
