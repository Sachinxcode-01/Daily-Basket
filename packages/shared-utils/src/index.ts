import { CartItem } from '@daily-basket/shared-types';

export const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0,
  }).format(amount);
};

export const calculateDiscountPercentage = (price: number, mrp: number): number => {
  if (!mrp || mrp <= price) return 0;
  return Math.round(((mrp - price) / mrp) * 100);
};

export const calculateCartTotals = (
  items: CartItem[],
  tipAmount = 0,
  couponDiscount = 0,
) => {
  const subtotal = items.reduce((acc, item) => acc + item.price * item.quantity, 0);
  const mrpTotal = items.reduce((acc, item) => acc + item.mrp * item.quantity, 0);
  const discount = Math.max(0, mrpTotal - subtotal);
  
  // Free delivery above ₹199
  const deliveryFee = subtotal >= 199 || items.length === 0 ? 0 : 25;
  const handlingFee = items.length > 0 ? 5 : 0;
  
  const total = Math.max(0, subtotal + deliveryFee + handlingFee + tipAmount - couponDiscount);
  const itemCount = items.reduce((acc, item) => acc + item.quantity, 0);

  return {
    subtotal,
    discount,
    deliveryFee,
    handlingFee,
    tipAmount,
    couponDiscount,
    total,
    itemCount,
  };
};

export const isValidPhoneNumber = (phone: string): boolean => {
  const phoneRegex = /^[6-9]\d{9}$/;
  return phoneRegex.test(phone.trim());
};

export const slugify = (text: string): string => {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')
    .replace(/[^\w\-]+/g, '')
    .replace(/\-\-+/g, '-');
};
