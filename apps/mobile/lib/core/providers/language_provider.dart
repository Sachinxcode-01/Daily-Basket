import 'package:flutter/material.dart';

/// State management provider for Language preferences and dynamic localization
class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = 'English';
  String _selectedLanguageCode = 'en';

  final List<Map<String, String>> _availableLanguages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'gu', 'name': 'Gujarati', 'native': 'ગુજરાતી'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
  ];

  static const Map<String, Map<String, String>> _translations = {
    'shop': {
      'en': 'Shop',
      'hi': 'शॉप',
      'mr': 'दुकान',
      'ta': 'கடை',
      'te': 'షాప్',
      'gu': 'શોપ',
      'bn': 'শপ',
    },
    'categories': {
      'en': 'Categories',
      'hi': 'श्रेणियां',
      'mr': 'वर्ग',
      'ta': 'வகைகள்',
      'te': 'వర్గాలు',
      'gu': 'શ્રેણીઓ',
      'bn': 'ক্যাটাগরি',
    },
    'orders': {
      'en': 'Orders',
      'hi': 'ऑर्डर',
      'mr': 'ऑर्डर',
      'ta': 'ஆர்டர்கள்',
      'te': 'ఆర్డర్లు',
      'gu': 'ઓર્ડર',
      'bn': 'অর্ডার',
    },
    'delivery_address': {
      'en': 'Delivery Address',
      'hi': 'डिलिवरी पता',
      'mr': 'डिलिव्हरी पत्ता',
      'ta': 'விநியோக முகவரி',
      'te': 'డెలివరీ చిరునామా',
      'gu': 'ડિલિવરી સરનામું',
      'bn': 'ডেলিভারি ঠিকানা',
    },
    'pay_using_wallet': {
      'en': 'Pay using Daily Basket Wallet',
      'hi': 'डेली बास्केट वॉलेट से भुगतान करें',
      'mr': 'डेली बास्केट वॉलेट वापरून पैसे द्या',
      'ta': 'டெய்லி பாஸ்கெட் வாலட்டைப் பயன்படுத்தி செலுத்தவும்',
      'te': 'డైలీ బాస్కెట్ వాలెట్‌ని ఉపయోగించి చెల్లించండి',
      'gu': 'ડેઇલી બાસ્કેટ વોલેટનો ઉપયોગ કરીને બિલ ચૂકવો',
      'bn': 'ডেইলি বাস্কেট ওয়ালেট ব্যবহার করে অর্থ প্রদান করুন',
    },
    'available_balance': {
      'en': 'Available',
      'hi': 'उपलब्ध',
      'mr': 'उपलब्ध',
      'ta': 'கிடைப்பது',
      'te': 'అందుబాటులో ఉంది',
      'gu': 'ઉપલબ્ધ',
      'bn': 'উপলব্ধ',
    },
    'empty_cart': {
      'en': 'Your basket is empty',
      'hi': 'आपकी टोकरी खाली है',
      'mr': 'तुमची टोपली रिकामी आहे',
      'ta': 'உங்கள் கூடை காலியாக உள்ளது',
      'te': 'మీ బాస్కెట్ ఖాళీగా ఉంది',
      'gu': 'તમારી બાસ્કેટ ખાલી છે',
      'bn': 'আপনার ঝুড়ি খালি',
    },
    'search': {
      'en': 'Search',
      'hi': 'खोजें',
      'mr': 'शोधा',
      'ta': 'தேடு',
      'te': 'శోధించండి',
      'gu': 'શોધો',
      'bn': 'খুঁজুন',
    },
    'account': {
      'en': 'Account',
      'hi': 'खाता',
      'mr': 'खाते',
      'ta': 'கணக்கு',
      'te': 'ఖాతా',
      'gu': 'ખાતું',
      'bn': 'অ্যাকাউন্ট',
    },
    'cart': {
      'en': 'Cart',
      'hi': 'कार्ट',
      'mr': 'कार्ट',
      'ta': 'கார்ட்',
      'te': 'కార్ట్',
      'gu': 'કાર્ટ',
      'bn': 'কার্ট',
    },
    'notifications': {
      'en': 'Notifications',
      'hi': 'सूचनाएं',
      'mr': 'सूचना',
      'ta': 'அறிவிப்புகள்',
      'te': 'నోటిఫికేషన్లు',
      'gu': 'નોટિફિકેશન્સ',
      'bn': 'বিজ্ঞপ্তি',
    },
    'notification_settings': {
      'en': 'Notification Settings',
      'hi': 'सूचना सेटिंग्स',
      'mr': 'सूचना सेटिंग्ज',
      'ta': 'அறிவிப்பு அமைப்புகள்',
      'te': 'నోటిఫికేషన్ సెట్టింగ్‌లు',
      'gu': 'નોટિફિકેશન સેટિંગ્સ',
      'bn': 'বিজ্ঞপ্তি সেটিংস',
    },
    'language': {
      'en': 'Language',
      'hi': 'भाषा',
      'mr': 'भाषा',
      'ta': 'மொழி',
      'te': 'భాష',
      'gu': 'ભાષા',
      'bn': 'ভাষা',
    },
    'app_theme': {
      'en': 'App Theme',
      'hi': 'ऐप थीम',
      'mr': 'अ‍ॅप थीम',
      'ta': 'செயலி தீம்',
      'te': 'యాప్ థీమ్',
      'gu': 'એપ થીમ',
      'bn': 'অ্যাপ থিম',
    },
    'personal_info': {
      'en': 'Personal Information',
      'hi': 'व्यक्तिगत जानकारी',
      'mr': 'वैयक्तिक माहिती',
      'ta': 'தனிப்பட்ட தகவல்கள்',
      'te': 'వ్యక్తిగత సమాచారం',
      'gu': 'વ્યક્તિગત માહિતી',
      'bn': 'ব্যক্তিগত তথ্য',
    },
    'security': {
      'en': 'Security',
      'hi': 'सुरक्षा',
      'mr': 'सुरक्षा',
      'ta': 'பாதுகாப்பு',
      'te': 'భద్రత',
      'gu': 'સુરક્ષા',
      'bn': 'সুরক্ষা',
    },
    'saved_addresses': {
      'en': 'Saved Addresses',
      'hi': 'सहेजे गए पते',
      'mr': 'साठवलेले पत्ते',
      'ta': 'சேமிக்கப்பட்ட முகவரிகள்',
      'te': 'సేవ్ చేసిన చిరునామాలు',
      'gu': 'સેવ કરેલા સરનામા',
      'bn': 'সংরক্ষিত ঠিকানা',
    },
    'payment_methods': {
      'en': 'Payment Methods',
      'hi': 'भुगतान के तरीके',
      'mr': 'पैसे भरण्याच्या पद्धती',
      'ta': 'கட்டண முறைகள்',
      'te': 'చెల్లింపు పద్ధతులు',
      'gu': 'ચુકવણી પદ્ધતિઓ',
      'bn': 'পেমেন্ট পদ্ধতি',
    },
    'preferences': {
      'en': 'PREFERENCES',
      'hi': 'प्राथमिकताएं',
      'mr': 'प्राधान्ये',
      'ta': 'விருப்பங்கள்',
      'te': 'ప్రాధాన్యతలు',
      'gu': 'પસંદગીઓ',
      'bn': 'পছন্দসমূহ',
    },
    'account_settings': {
      'en': 'ACCOUNT SETTINGS',
      'hi': 'खाता सेटिंग्स',
      'mr': 'खाते सेटिंग्ज',
      'ta': 'கணக்கு அமைப்புகள்',
      'te': 'ఖాతా సెట్టింగ్‌లు',
      'gu': 'ખાતા સેટિંગ્સ',
      'bn': 'অ্যাকাউন্ট সেটিংস',
    },
    'support_legal': {
      'en': 'SUPPORT & LEGAL',
      'hi': 'सहायता एवं कानूनी',
      'mr': 'सहाय्य आणि कायदेशीर',
      'ta': 'ஆதரவு & சட்டம்',
      'te': 'మద్దతు & చట్టపరమైన',
      'gu': 'સપોર્ટ અને કાનૂની',
      'bn': 'সহায়তা ও আইনি',
    },
    'live_chat': {
      'en': 'Live Agent Chat',
      'hi': 'लाइव एजेंट चैट',
      'mr': 'लाइव्ह एजंट चॅट',
      'ta': 'நேரடி அரட்டை',
      'te': 'లైవ్ ఏజెంట్ చాట్',
      'gu': 'લાઇવ એજન્ટ ચેટ',
      'bn': 'লাইভ এজেন্ট চ্যাট',
    },
    'help_center': {
      'en': 'Help Center',
      'hi': 'सहायता केंद्र',
      'mr': 'मदत केंद्र',
      'ta': 'உதவி மையம்',
      'te': 'సహాయ కేంద్రం',
      'gu': 'મદદ કેન્દ્ર',
      'bn': 'সহায়তা কেন্দ্র',
    },
    'terms_of_service': {
      'en': 'Terms of Service',
      'hi': 'सेवा की शर्तें',
      'mr': 'सेवा अटी',
      'ta': 'சேவை விதிமுறைகள்',
      'te': 'సేవా నిబంధనలు',
      'gu': 'સેવાની શરતો',
      'bn': 'সেবার শর্তাবলী',
    },
    'privacy_policy': {
      'en': 'Privacy Policy',
      'hi': 'गोपनीयता नीति',
      'mr': 'गोपनीयता धोरण',
      'ta': 'தனியுரிமைக் கொள்கை',
      'te': 'గోప్యతా విధానం',
      'gu': 'ગોપનીયતા નીતિ',
      'bn': 'গোপনীয়তা নীতি',
    },
    'logout': {
      'en': 'Log Out',
      'hi': 'लॉग आउट',
      'mr': 'लॉग आउट',
      'ta': 'வெளியேறு',
      'te': 'లాగ్ అవుట్',
      'gu': 'લોગ આઉટ',
      'bn': 'লগ আউট',
    },
    'your_items': {
      'en': 'Your Items',
      'hi': 'आपकी वस्तुएं',
      'mr': 'तुमच्या वस्तू',
      'ta': 'உங்கள் பொருட்கள்',
      'te': 'మీ వస్తువులు',
      'gu': 'તમારી વસ્તુઓ',
      'bn': 'আপনার পণ্যসমূহ',
    },
    'bill_summary': {
      'en': 'Bill Summary',
      'hi': 'बिल सारांश',
      'mr': 'बिल सारांश',
      'ta': 'பில் சுருக்கம்',
      'te': 'బిల్లు సారాంశం',
      'gu': 'બિલ સારાંશ',
      'bn': 'বিল সারসংক্ষেপ',
    },
    'proceed_to_checkout': {
      'en': 'Proceed to Checkout',
      'hi': 'चेकआउट के लिए आगे बढ़ें',
      'mr': 'चेकआउट कडे जा',
      'ta': 'செக்அவுட்டிற்குச் செல்லவும்',
      'te': 'చెక్‌అవుట్‌కు వెళ్లండి',
      'gu': 'ચેકઆઉટ પર જાઓ',
      'bn': 'চেকআউটে যান',
    },
    'total_to_pay': {
      'en': 'TOTAL TO PAY',
      'hi': 'कुल भुगतान योग्य',
      'mr': 'एकूण देय',
      'ta': 'மொத்தக் கட்டணம்',
      'te': 'మొత్తం చెల్లింపు',
      'gu': 'કુલ ચુકવણી',
      'bn': 'মোট দেয়',
    },
    'select_language': {
      'en': 'Select Language',
      'hi': 'भाषा चुनें',
      'mr': 'भाषा निवडा',
      'ta': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'te': 'భాషను ఎంచుకోండి',
      'gu': 'ભાષા પસંદ કરો',
      'bn': 'ভাষা নির্বাচন করুন',
    },
    'language_changed_toast': {
      'en': 'App language changed to',
      'hi': 'ऐप की भाषा बदलकर कर दी गई',
      'mr': 'ॲपची भाषा बदलली',
      'ta': 'செயலி மொழி மாற்றப்பட்டது',
      'te': 'యాప్ భాష మార్చబడింది',
      'gu': 'એપની ભાષા બદલાઈ',
      'bn': 'অ্যাপের ভাষা পরিবর্তিত হয়েছে',
    },
  };

  String get selectedLanguage => _selectedLanguage;
  String get selectedLanguageCode => _selectedLanguageCode;
  List<Map<String, String>> get availableLanguages => _availableLanguages;

  void setLanguage(String languageName) {
    final match = _availableLanguages.firstWhere(
      (l) => l['name'] == languageName || l['native'] == languageName,
      orElse: () => {'code': 'en', 'name': 'English', 'native': 'English'},
    );
    _selectedLanguage = match['name']!;
    _selectedLanguageCode = match['code']!;
    notifyListeners();
  }

  void setLanguageByCode(String code) {
    final match = _availableLanguages.firstWhere(
      (l) => l['code'] == code,
      orElse: () => {'code': 'en', 'name': 'English', 'native': 'English'},
    );
    _selectedLanguage = match['name']!;
    _selectedLanguageCode = match['code']!;
    notifyListeners();
  }

  String translate(String key, [String? fallback]) {
    final map = _translations[key];
    if (map != null && map.containsKey(_selectedLanguageCode)) {
      return map[_selectedLanguageCode]!;
    }
    return fallback ?? (map?['en'] ?? key);
  }

  String getText(String key, [String? fallback]) => translate(key, fallback);
}
