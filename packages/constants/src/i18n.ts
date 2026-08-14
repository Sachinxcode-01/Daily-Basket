export type SupportedLanguage = 'en' | 'kn' | 'hi';

export interface LanguageOption {
  code: SupportedLanguage;
  name: string;
  nativeName: string;
  flag: string;
}

export const SUPPORTED_LANGUAGES: LanguageOption[] = [
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧' },
  { code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳' },
  { code: 'hi', name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳' },
];

export const I18N_DICTIONARY: Record<SupportedLanguage, Record<string, string>> = {
  en: {
    app_name: 'Daily Basket',
    delivery_promise: 'Delivery in 10 minutes',
    search_placeholder: 'Search fresh vegetables, fruits, dairy...',
    cart: 'Cart',
    checkout: 'Checkout',
    item_total: 'Item Total',
    delivery_fee: 'Delivery Fee',
    free_delivery: 'FREE',
    surge_pricing_applied: 'Dynamic Surge Pricing Applied',
    grand_total: 'Grand Total',
    place_order: 'Place Order',
    order_status_confirmed: 'Order Confirmed',
    order_status_packing: 'Packing at Dark Store',
    order_status_out_for_delivery: 'Out for Delivery',
    order_status_delivered: 'Delivered to Doorstep',
    store_out_of_radius: 'Selected delivery location is outside dark store 5km coverage zone',
    save_address: 'Save Delivery Address',
    language: 'Language',
  },
  kn: {
    app_name: 'ಡೈಲಿ ಬಾಸ್ಕೆಟ್',
    delivery_promise: '೧೦ ನಿಮಿಷಗಳಲ್ಲಿ ಡೆಲಿವರಿ',
    search_placeholder: 'ತಾಜಾ ತರಕಾರಿಗಳು, ಹಣ್ಣುಗಳು, ಹಾಲಿನ ಉತ್ಪನ್ನಗಳನ್ನು ಹುಡುಕಿ...',
    cart: 'ಕಾರ್ಟ್',
    checkout: 'ಚೆಕ್ಔಟ್',
    item_total: 'ವಸ್ತುಗಳ ಒಟ್ಟು',
    delivery_fee: 'ಡೆಲಿವರಿ ಶುಲ್ಕ',
    free_delivery: 'ಉಚಿತ',
    surge_pricing_applied: 'ಡೈನಾಮಿಕ್ ಸರ್ಜ್ ದರ ಅನ್ವಯಿಸಲಾಗಿದೆ',
    grand_total: 'ಒಟ್ಟು ಮೊತ್ತ',
    place_order: 'ಆರ್ಡರ್ ಮಾಡಿ',
    order_status_confirmed: 'ಆರ್ಡರ್ ಖಚಿತವಾಗಿದೆ',
    order_status_packing: 'ಡಾರ್ಕ್ ಸ್ಟೋರ್‌ನಲ್ಲಿ ಪ್ಯಾಕ್ ಮಾಡಲಾಗುತ್ತಿದೆ',
    order_status_out_for_delivery: 'ಡೆಲಿವರಿಗೆ ಹೊರಟಿದೆ',
    order_status_delivered: 'ಮನೆಬಾಗಿಲಿಗೆ ತಲುಪಿಸಲಾಗಿದೆ',
    store_out_of_radius: 'ಆಯ್ಕೆಮಾಡಿದ ಸ್ಥಳವು ಡಾರ್ಕ್ ಸ್ಟೋರ್ 5km ವ್ಯಾಪ್ತಿಯಿಂದ ಹೊರಗಿದೆ',
    save_address: 'ಡೆಲಿವರಿ ವಿಳಾಸ ಉಳಿಸಿ',
    language: 'ಭಾಷೆ',
  },
  hi: {
    app_name: 'डेली बास्केट',
    delivery_promise: '10 मिनट में डिलीवरी',
    search_placeholder: 'ताजी सब्जियां, फल, डेयरी उत्पाद खोजें...',
    cart: 'कार्ट',
    checkout: 'चेकआउट',
    item_total: 'आइटम कुल',
    delivery_fee: 'डिलीवरी शुल्क',
    free_delivery: 'मुफ्त',
    surge_pricing_applied: 'डायनामिक सर्ज शुल्क लागू',
    grand_total: 'कुल राशि',
    place_order: 'ऑर्डर दें',
    order_status_confirmed: 'ऑर्डर की पुष्टि हो गई',
    order_status_packing: 'डार्क स्टोर में पैकिंग जारी है',
    order_status_out_for_delivery: 'डिलीवरी के लिए निकल चुका है',
    order_status_delivered: 'सफलतापूर्वक पहुंचा दिया गया',
    store_out_of_radius: 'चुना गया स्थान डार्क स्टोर की 5 किमी कवरेज सीमा से बाहर है',
    save_address: 'डिलीवरी पता सहेजें',
    language: 'भाषा',
  },
};

export function getTranslation(lang: SupportedLanguage, key: string): string {
  const dict = I18N_DICTIONARY[lang] || I18N_DICTIONARY.en;
  return dict[key] || I18N_DICTIONARY.en[key] || key;
}
