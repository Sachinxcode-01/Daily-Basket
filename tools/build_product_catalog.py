import os
import json
import re

# Comprehensive product name templates and brand mapping for realistic Indian groceries
CATEGORIES = [
    'vermicelli',
    'poha-daliya-grains',
    'milk',
    'flakes-kids-cereals',
    'curd-yogurt',
    'fresh-vegetables',
    'bread-pav'
]

# Specific known items mapped by prefix or index
VERMICELLI_ITEMS = [
    ("MTR Roasted Vermicelli", "400 g Pack", "MTR", 42.0, 50.0, "Roasted Vermicelli", "16% OFF"),
    ("Tata Sampann Roasted Vermicelli", "400 g Pack", "Tata Sampann", 45.0, 55.0, "Roasted Vermicelli", "18% OFF"),
    ("Two Brothers Organic Khapli Wheat Vermicelli", "500 g Pack", "Two Brothers", 160.0, 190.0, "Organic Khapli", "Organic"),
    ("MTR Seviyan Vermicelli", "850 g Value Pack", "MTR", 85.0, 105.0, "Seviyan", "19% OFF"),
    ("Whole Wheat Roasted Vermicelli", "400 g Pack", "Zero Maida", 55.0, 65.0, "Whole Wheat", "15% OFF"),
    ("MTR Rice Sevai", "400 g Pack", "MTR", 48.0, 58.0, "Rice Sevai", "17% OFF"),
    ("Whole Wheat Roasted Vermicelli & Noodles Combo", "800 g Combo", "Zero Maida", 110.0, 135.0, "Combo Pack", "Hot Deal"),
    ("Prolicious High Protein Millet Vermicelli", "300 g Pack", "Prolicious", 95.0, 120.0, "Millet Vermicelli", "High Protein"),
    ("Bambino Roasted Vermicelli", "150 g Pack", "Bambino", 20.0, 25.0, "Roasted Vermicelli", "Daily Essential"),
    ("Bambino Plain Vermicelli", "400 g Pack", "Bambino", 38.0, 45.0, "Plain Vermicelli", "15% OFF"),
    ("Bambino Roasted Vermicelli - Family Pack", "400 g Pack", "Bambino", 42.0, 50.0, "Roasted Vermicelli", "16% OFF"),
    ("Bambino Roasted Vermicelli - Mega Saver", "850 g Pack", "Bambino", 78.0, 95.0, "Roasted Vermicelli", "18% OFF"),
    ("Bambino Roasted Vermicelli Easy-Store Jar", "1 kg Jar", "Bambino", 115.0, 140.0, "Storage Jar", "Popular"),
    ("Two Brothers Khapli Emmer Wheat Vermicelli", "350 g Pack", "Two Brothers", 145.0, 175.0, "Khapli Vermicelli", "Organic"),
    ("Hamdard Khaalis Roasted Seviyan", "200 g Pack", "Hamdard", 35.0, 42.0, "Roasted Seviyan", "Festival Special"),
    ("Real Thai Rice Vermicelli Noodles", "375 g Pack", "Real Thai", 185.0, 220.0, "Rice Vermicelli", "Imported")
]

POHA_ITEMS = [
    ("Nestlé Everyday Dairy Whitener", "400 g Pouch", "Nestlé", 240.0, 260.0, "Dairy Whitener", "Daily Essential"),
    ("MTR Roasted Vermicelli", "400 g Pouch", "MTR", 42.0, 50.0, "Roasted Vermicelli", "16% OFF"),
    ("Cavin's Kaju Butterscotch Milkshake", "200 ml Tetra", "Cavin's", 38.0, 45.0, "Flavoured Milk", "15% OFF"),
    ("Rajdhani Thick Poha", "500 g Pack", "Rajdhani", 34.0, 42.0, "Poha", "19% OFF"),
    ("Nestlé Milkmaid Condensed Milk", "380 g Tin", "Nestlé", 144.0, 155.0, "Condensed Milk", "Dessert Essential"),
    ("Godrej Yummiez Chicken Pepper & Herb Sausages", "250 g Pack", "Godrej Yummiez", 195.0, 225.0, "Ready to Cook", "Non-Veg"),
    ("iD Fresh Idly & Dosa Batter", "1 kg Pouch", "iD Fresh", 85.0, 95.0, "Fresh Batter", "Fresh Daily"),
    ("MTR 3 Minute Breakfast Seviyan Upma", "160 g Pack", "MTR", 45.0, 55.0, "Instant Breakfast", "Quick Cook"),
    ("Britannia Classic Cheese Slices", "200 g (10 Slices)", "Britannia", 140.0, 155.0, "Cheese", "Dairy"),
    ("Whole Farm Sabudana Sago Pearls", "500 g Pack", "Whole Farm", 65.0, 80.0, "Sabudana", "Pooja & Vrat"),
    ("Dabur 100% Pure Honey Squeezy", "500 g Bottle", "Dabur", 199.0, 235.0, "Pure Honey", "15% OFF"),
    ("MyFitness Chocolate Peanut Butter", "510 g Jar", "MyFitness", 349.0, 399.0, "Peanut Butter", "High Protein"),
    ("Rajdhani Premium Sabudana", "500 g Pack", "Rajdhani", 68.0, 85.0, "Sabudana", "Vrat Special"),
    ("Amul Pasteurised Salted Butter", "100 g Pack", "Amul", 58.0, 62.0, "Table Butter", "Daily Essential"),
    ("RiteBite Max Protein Daily Choco Almond Bar", "50 g Bar", "Max Protein", 65.0, 75.0, "Protein Bar", "Energy Snack"),
    ("Rajdhani Roasted Wheat Dalia", "500 g Pack", "Rajdhani", 42.0, 50.0, "Wheat Dalia", "Fiber Rich"),
    ("Rajdhani Special Thick Poha - Mandi Select", "1 kg Pack", "Rajdhani", 66.0, 80.0, "Poha", "18% OFF")
]

MILK_ITEMS = [
    ("Amul Buffalo Milk A2 Pouch", "500 ml Pouch", "Amul", 35.0, 36.0, "Buffalo Milk", "A2 Rich"),
    ("Mother Dairy Toned Milk", "1 L Tetrapack", "Mother Dairy", 72.0, 75.0, "Toned Milk", "Fresh Daily"),
    ("Yakult Light Probiotic Drink", "5 x 65 ml Pack", "Yakult", 90.0, 95.0, "Probiotic Drink", "Gut Health"),
    ("Mother Dairy Promilk Protein Rich", "500 ml Pouch", "Mother Dairy", 36.0, 38.0, "High Protein Milk", "30% Extra Protein"),
    ("Amul Buffalo Milk A2 Premium", "1 L Pouch", "Amul", 70.0, 72.0, "Buffalo Milk", "Rich Cream"),
    ("Yakult Light Sugar-Free", "5 x 65 ml Pack", "Yakult", 95.0, 100.0, "Probiotic Drink", "Zero Sugar"),
    ("Heritage Happy Full Cream Milk", "500 ml Pouch", "Heritage", 34.0, 36.0, "Full Cream Milk", "Wholesome"),
    ("Amul Desi A2 Cow Milk Bottle", "1 L PET Bottle", "Amul", 85.0, 90.0, "Desi Cow Milk", "A2 Certified"),
    ("Amul Taaza Toned Fresh Milk", "500 ml Pouch", "Amul", 28.0, 28.0, "Toned Milk", "Daily Essential"),
    ("Yakult Original Probiotic Health Drink", "5 x 65 ml Pack", "Yakult", 85.0, 90.0, "Probiotic Drink", "Immunity"),
    ("Amul Cow Milk Tetrapack", "1 L Tetrapack", "Amul", 75.0, 78.0, "Cow Milk", "Nutritious"),
    ("Amul Buffalo Milk A2 Tetrapack", "1 L Tetrapack", "Amul", 80.0, 85.0, "Buffalo Milk", "A2 Purity"),
    ("Amul Gold Full Cream Milk Pouch", "500 ml Pouch", "Amul", 33.0, 34.0, "Full Cream Milk", "6% Fat"),
    ("Mother Dairy Pure Buffalo Milk", "1 L Pouch", "Mother Dairy", 72.0, 74.0, "Buffalo Milk", "Creamy"),
    ("Country Delight Farm Fresh Buffalo Milk", "1 L Pouch", "Country Delight", 84.0, 88.0, "Buffalo Milk", "Pure Farm"),
    ("Mother Dairy LiveLite Low Fat Milk", "500 ml Pouch", "Mother Dairy", 27.0, 29.0, "Low Fat Milk", "Weight Care"),
    ("Nestlé a+ Slim Skimmed Milk", "1 L Carton", "Nestlé", 88.0, 95.0, "Skimmed Milk", "Zero Fat"),
    ("Amul Taaza Toned Milk Carton", "1 L Carton", "Amul", 72.0, 75.0, "Toned Milk", "Homogenised"),
    ("Amul Lactose Free Milk", "1 L Carton", "Amul", 95.0, 105.0, "Lactose Free", "Easy Digest"),
    ("Amul T-Special High Fat Milk", "1 L Pouch", "Amul", 68.0, 70.0, "Special Milk", "Chai Special"),
    ("Amul Gold Homogenised Standardised Milk", "1 L Carton", "Amul", 78.0, 82.0, "Full Cream Milk", "Gold Quality"),
    ("Amul Taaza Homogenised Toned Milk", "1 L Tetra", "Amul", 72.0, 75.0, "Toned Milk", "Long Life"),
    ("Humpy Farms Desi Gir Cow A2 Milk", "1 L Pouch", "Humpy Farms", 110.0, 125.0, "Desi Cow Milk", "Farm Direct"),
    ("Mother Dairy Toned Fresh Milk", "500 ml Pouch", "Mother Dairy", 28.0, 28.0, "Toned Milk", "Daily Essential"),
    ("Saras Taaza Pasteurised Toned Milk", "500 ml Pouch", "Saras", 26.0, 27.0, "Toned Milk", "Pure"),
    ("Amul Camel Milk Pasteurised", "200 ml Bottle", "Amul", 35.0, 40.0, "Camel Milk", "Health Special"),
    ("Country Delight Fresh Cow Milk", "1 L Pouch", "Country Delight", 78.0, 82.0, "Cow Milk", "Direct From Farm"),
    ("Mother Dairy Full Cream Milk", "1 L Pouch", "Mother Dairy", 68.0, 70.0, "Full Cream Milk", "Rich Taste"),
    ("Amul Slim 'n' Trim Skimmed Milk", "1 L Carton", "Amul", 74.0, 78.0, "Skimmed Milk", "Fit Choice"),
    ("Amul Cow Milk Pasteurised", "500 ml Pouch", "Amul", 29.0, 30.0, "Cow Milk", "Cow Purity"),
    ("Amul Buffalo Milk Fresh Pouch", "500 ml Pouch", "Amul", 35.0, 36.0, "Buffalo Milk", "Rich Quality"),
    ("Nestlé a+ Nourish Toned Milk", "1 L Carton", "Nestlé", 82.0, 88.0, "Toned Milk", "Nourish+"),
    ("Mother Dairy Homogenised Long Life Milk", "1 L Carton", "Mother Dairy", 74.0, 78.0, "Toned Milk", "UHT Purity"),
    ("Amul Moti Long Life 90 Days Milk", "450 ml Pouch", "Amul", 32.0, 33.0, "Toned Milk", "90 Days Fresh"),
    ("Amul Desi Cow Milk Farm Fresh", "500 ml Pouch", "Amul", 32.0, 34.0, "Cow Milk", "Desi Breed"),
    ("Provilac High Protein Fresh Milk", "250 ml Bottle", "Provilac", 60.0, 70.0, "High Protein Milk", "Zero Additives"),
    ("Amul Calci+ Calcium Fortified Milk", "1 L Carton", "Amul", 85.0, 92.0, "Fortified Milk", "Calcium Rich"),
    ("Mother Dairy Special Cow Milk", "500 ml Pouch", "Mother Dairy", 30.0, 31.0, "Cow Milk", "Special Sweetness"),
    ("Country Delight x HRX 25g High Protein Milk", "450 ml Pouch", "Country Delight", 65.0, 75.0, "High Protein Milk", "Fitness Fuel"),
    ("Mother Dairy Fit Life Low Fat Milk", "500 ml Pouch", "Mother Dairy", 28.0, 30.0, "Low Fat Milk", "Active Life"),
    ("Mother Dairy Fit Life Double Toned Milk", "1 L Pouch", "Mother Dairy", 54.0, 56.0, "Double Toned", "Light & Fresh")
]

# Generators for large categories
VEG_SPECIES = [
    ("Fresh Country Tomatoes (Tamatar)", "500 g", "Farm Fresh", 24.0, 35.0, "Fresh Vegetables", "Seasonal", "31% OFF"),
    ("Fresh Red Onions (Pyaaz)", "1 kg", "Farm Fresh", 35.0, 50.0, "Fresh Vegetables", "Seasonal", "30% OFF"),
    ("Premium Jyoti Potatoes (Aloo)", "1 kg", "Farm Fresh", 28.0, 40.0, "Fresh Vegetables", "Seasonal", "Hot Deal"),
    ("Farm Fresh Palak (Spinach)", "250 g", "Farm Fresh", 20.0, 30.0, "Leafy Greens", "Organic", "Organic"),
    ("Fresh Green Chillies (Hari Mirch)", "100 g", "Farm Fresh", 14.0, 20.0, "Fresh Vegetables", "Seasonal", "Spicy"),
    ("Juicy Yellow Lemons (Nimbu)", "4 pcs", "Farm Fresh", 18.0, 25.0, "Fresh Vegetables", "Seasonal", "Vitamin C"),
    ("Tender Peeled Baby Corn", "200 g", "Farm Fresh", 45.0, 60.0, "Exotics & Premium", "Seasonal", "Farm Direct"),
    ("Sweet American Corn Cob (Bhutta)", "2 pcs", "Farm Fresh", 38.0, 50.0, "Fresh Vegetables", "Seasonal", "Sweet & Crisp"),
    ("Fresh Green Peas (Matar) in Pods", "500 g", "Farm Fresh", 48.0, 65.0, "Fresh Vegetables", "Seasonal", "Fresh Harvest"),
    ("Cherry Tomatoes (Red & Orange)", "250 g", "Farm Fresh", 60.0, 80.0, "Exotics & Premium", "Organic", "Salad Special"),
    ("Sambar Shallots (Chotta Pyaaz)", "500 g", "Farm Fresh", 42.0, 55.0, "Fresh Vegetables", "Seasonal", "South Special"),
    ("Tri-Color Bell Peppers (Capsicum)", "3 pcs (Red, Yellow, Green)", "Hydroponic Direct", 115.0, 145.0, "Exotics & Premium", "Organic", "Hydroponic"),
    ("Crisp Spring Onions with Greens", "1 bunch (200g)", "Farm Fresh", 22.0, 30.0, "Fresh Vegetables", "Seasonal", "Fresh Cut"),
    ("Juicy Fresh Kagzi Lemons", "6 pcs", "Farm Fresh", 25.0, 35.0, "Fresh Vegetables", "Seasonal", "Tangy Citrus"),
    ("Sprouted Kala Chana (Brown Chickpeas)", "200 g", "Daily Basket Select", 35.0, 45.0, "Organic Produce", "Organic", "Protein Rich"),
    ("Tender Raw Jackfruit Chunks (Kathal)", "300 g Cut", "Farm Fresh", 55.0, 70.0, "Fresh Vegetables", "Seasonal", "Curry Special"),
    ("Raw Green Papaya (Kaccha Papita)", "1 pc (500g)", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables", "Seasonal", "Digestive"),
    ("Fresh Fragrant Mint Leaves (Pudina)", "1 bunch (100g)", "Farm Fresh", 12.0, 18.0, "Leafy Greens", "Seasonal", "Aromatic"),
    ("Fresh Fruits & Seasonal Berries Basket", "1 Pack", "Daily Basket Select", 180.0, 220.0, "Fresh Fruits", "Seasonal", "Delight"),
    ("Vine Ripe Hybrid Tomatoes", "1 kg", "Farm Fresh", 44.0, 60.0, "Fresh Vegetables", "Seasonal", "Farm Fresh"),
    ("Fresh Tinda (Apple Gourd)", "500 g", "Farm Fresh", 34.0, 45.0, "Fresh Vegetables", "Seasonal", "Tender"),
    ("Organic Baby Spinach Leaves", "200 g", "Farm Fresh", 28.0, 40.0, "Leafy Greens", "Organic", "Pesticide Free"),
    ("Fresh Mustard Greens (Sarson Ka Saag)", "500 g", "Farm Fresh", 30.0, 42.0, "Leafy Greens", "Seasonal", "Winter Special"),
    ("Fresh Sliced Lemon Quarters", "200 g Pack", "Farm Fresh", 22.0, 30.0, "Fresh Vegetables", "Seasonal", "Fresh Cut"),
    ("Sweet Juicy Mosambi (Sweet Lime)", "1 kg (4-5 pcs)", "Farm Fresh", 75.0, 95.0, "Fresh Fruits", "Seasonal", "Juicy")
]

MORE_VEG = [
    ("Fresh Green Tindora (Kundru)", "500 g", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables"),
    ("Crisp Orange Carrots (Gajar)", "500 g", "Farm Fresh", 28.0, 38.0, "Fresh Vegetables"),
    ("Raw Fresh Turmeric (Kacchi Haldi)", "250 g", "Organic Mandi", 35.0, 50.0, "Organic Produce"),
    ("Fresh Green Broccoli Florets", "1 pc (350g)", "Daily Basket Select", 58.0, 75.0, "Exotics & Premium"),
    ("Crisp Romaine Lettuce", "1 pc (250g)", "Hydroponic Direct", 45.0, 60.0, "Leafy Greens"),
    ("Fresh Green Capsicum (Shimla Mirch)", "500 g", "Farm Fresh", 36.0, 48.0, "Fresh Vegetables"),
    ("Fresh Cauliflower (Phool Gobhi)", "1 pc (500g)", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables"),
    ("Green Cabbage (Patta Gobhi)", "1 pc (600g)", "Farm Fresh", 24.0, 35.0, "Fresh Vegetables"),
    ("Fresh Lady Finger (Bhindi / Okra)", "500 g", "Farm Fresh", 34.0, 48.0, "Fresh Vegetables"),
    ("Tender Bottle Gourd (Lauki / Dudhi)", "1 pc (800g)", "Farm Fresh", 28.0, 40.0, "Fresh Vegetables"),
    ("Fresh Ridge Gourd (Turai)", "500 g", "Farm Fresh", 36.0, 50.0, "Fresh Vegetables"),
    ("Tender Bitter Gourd (Karela)", "500 g", "Farm Fresh", 38.0, 52.0, "Fresh Vegetables"),
    ("Fresh French Beans", "250 g", "Farm Fresh", 30.0, 42.0, "Fresh Vegetables"),
    ("Fresh Cluster Beans (Gawar Phali)", "250 g", "Farm Fresh", 28.0, 38.0, "Fresh Vegetables"),
    ("Fresh Ginger (Adrak)", "200 g", "Farm Fresh", 35.0, 48.0, "Fresh Vegetables"),
    ("Fresh Garlic Pearls (Desi Lahsun)", "200 g", "Farm Fresh", 45.0, 60.0, "Fresh Vegetables"),
    ("Peeled Garlic Cloves", "100 g", "Daily Basket Select", 38.0, 50.0, "Fresh Vegetables"),
    ("Fresh Coriander Leaves (Kothmir)", "1 bunch (100g)", "Farm Fresh", 10.0, 15.0, "Leafy Greens"),
    ("Fresh Curry Leaves (Kadi Patta)", "1 bunch (50g)", "Farm Fresh", 8.0, 12.0, "Leafy Greens"),
    ("Fresh Fenugreek Leaves (Methi)", "1 bunch (250g)", "Farm Fresh", 18.0, 25.0, "Leafy Greens"),
    ("Fresh Beetroot (Chukandar)", "500 g", "Farm Fresh", 28.0, 38.0, "Fresh Vegetables"),
    ("White Radish (Mooli)", "500 g", "Farm Fresh", 22.0, 32.0, "Fresh Vegetables"),
    ("Button Mushrooms Fresh Pack", "200 g Pack", "Daily Basket Select", 48.0, 60.0, "Exotics & Premium"),
    ("Hass Avocado (Imported)", "1 pc (200g)", "Daily Basket Select", 85.0, 110.0, "Exotics & Premium"),
    ("Fresh Zucchini Green", "1 pc (300g)", "Daily Basket Select", 42.0, 55.0, "Exotics & Premium"),
    ("Fresh Zucchini Yellow", "1 pc (300g)", "Daily Basket Select", 48.0, 62.0, "Exotics & Premium"),
    ("English Cucumber (Kheera)", "500 g", "Farm Fresh", 26.0, 36.0, "Fresh Vegetables"),
    ("Desi Cucumber (Local Kheera)", "500 g", "Farm Fresh", 24.0, 32.0, "Fresh Vegetables"),
    ("Raw Mango (Kaccha Aam)", "500 g", "Farm Fresh", 45.0, 60.0, "Fresh Fruits"),
    ("Fresh Snake Gourd (Chichinda)", "500 g", "Farm Fresh", 32.0, 44.0, "Fresh Vegetables"),
    ("Fresh Ash Gourd (Petha)", "1 slice (500g)", "Farm Fresh", 28.0, 38.0, "Fresh Vegetables"),
    ("Fresh Yam / Suran (Elephant Foot)", "500 g", "Farm Fresh", 40.0, 55.0, "Fresh Vegetables"),
    ("Fresh Arbi (Colocasia)", "500 g", "Farm Fresh", 35.0, 48.0, "Fresh Vegetables"),
    ("Fresh Sweet Potato (Shakarkandi)", "500 g", "Farm Fresh", 30.0, 42.0, "Fresh Vegetables"),
    ("Fresh Drumsticks (Moringa)", "250 g (3-4 pcs)", "Farm Fresh", 28.0, 38.0, "Fresh Vegetables")
]

# Generate mapping for all 607 files
def build_catalog():
    products_by_category = {}
    all_products = []

    # 1. Vermicelli (16 files)
    v_files = sorted(os.listdir('assets/products/vermicelli'))
    v_list = []
    for i, fn in enumerate(v_files):
        item = VERMICELLI_ITEMS[i % len(VERMICELLI_ITEMS)]
        v_list.append({
            'id': f'prod_vermi_{i+1:03d}',
            'name': item[0] if i < len(VERMICELLI_ITEMS) else f"{item[0]} (Variant {i+1})",
            'subtitle': item[1],
            'brand': item[2],
            'unit': item[1].split()[0] + ' ' + item[1].split()[1],
            'price': float(item[3]),
            'mrp': float(item[4]),
            'badge': item[6],
            'badgeColor': '0xFFBA1A1A' if '%' in item[6] else '0xFF006B23',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Staples',
            'sub': 'Sooji',
            'rating': round(4.5 + (i % 5) * 0.1, 1),
            'reviews': f"{320 + i * 45}",
            'image': f'assets/products/vermicelli/{fn}'
        })
    products_by_category['vermicelli'] = v_list

    # 2. Poha Daliya Grains (17 files)
    p_files = sorted(os.listdir('assets/products/poha-daliya-grains'))
    p_list = []
    for i, fn in enumerate(p_files):
        item = POHA_ITEMS[i % len(POHA_ITEMS)]
        p_list.append({
            'id': f'prod_poha_{i+1:03d}',
            'name': item[0] if i < len(POHA_ITEMS) else f"{item[0]} (Variant {i+1})",
            'subtitle': item[1],
            'brand': item[2],
            'unit': item[1].split()[0] + ' ' + item[1].split()[1],
            'price': float(item[3]),
            'mrp': float(item[4]),
            'badge': item[6],
            'badgeColor': '0xFFBA1A1A' if '%' in item[6] else '0xFF006B23',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Staples',
            'sub': 'Poha' if 'Poha' in item[0] else 'Grains',
            'rating': round(4.6 + (i % 4) * 0.1, 1),
            'reviews': f"{410 + i * 55}",
            'image': f'assets/products/poha-daliya-grains/{fn}'
        })
    products_by_category['poha-daliya-grains'] = p_list

    # 3. Milk (41 files)
    m_files = sorted(os.listdir('assets/products/milk'))
    m_list = []
    for i, fn in enumerate(m_files):
        item = MILK_ITEMS[i % len(MILK_ITEMS)]
        m_list.append({
            'id': f'prod_milk_{i+1:03d}',
            'name': item[0] if i < len(MILK_ITEMS) else f"{item[0]} (Size {i+1})",
            'subtitle': item[1],
            'brand': item[2],
            'unit': item[1].split()[0] + ' ' + item[1].split()[1],
            'price': float(item[3]),
            'mrp': float(item[4]),
            'badge': item[6],
            'badgeColor': '0xFF006B23' if 'Fresh' in item[6] or 'Daily' in item[6] else '0xFF00569E',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Dairy',
            'sub': 'Milk',
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{1200 + i * 110}",
            'image': f'assets/products/milk/{fn}'
        })
    products_by_category['milk'] = m_list

    # 4. Flakes & Kids Cereals (53 files)
    cereal_brands = ["Kellogg's", "Tata Soulfull", "Bagrry's", "Kwality", "Nestlé", "Slurrp Farm", "Zerobeli", "Organic Tattva"]
    cereal_types = [
        ("Munch Choco Fills Cereal", "375 g Box", "Nestlé", 165.0, 195.0, "Choco Fills", "15% OFF"),
        ("Kwality Cookie Rings Breakfast Cereal", "375 g Box", "Kwality", 145.0, 180.0, "Cookie Rings", "19% OFF"),
        ("Kwality Fruit Rings & Choco Fills Family Pack", "500 g Combo", "Kwality", 210.0, 260.0, "Cereal Combo", "Value Pack"),
        ("Kellogg's All-Bran Wheat Flakes High Fibre", "425 g Box", "Kellogg's", 185.0, 215.0, "Wheat Flakes", "High Fibre"),
        ("Organic Tattva 100% Certified Organic Quinoa", "500 g Pack", "Organic Tattva", 199.0, 245.0, "Organic Quinoa", "Organic"),
        ("Slurrp Farm Ragi & Jowar Choco Crunch Stars", "350 g Box", "Slurrp Farm", 190.0, 225.0, "Kids Cereal", "No Maida"),
        ("Tata Soulfull Ragi Bites Super Saver Pack", "700 g Pack", "Tata Soulfull", 249.0, 310.0, "Ragi Bites", "20% OFF"),
        ("Zerobeli Crunchy Choco Flakes Goodness of Jowar", "375 g Pouch", "Zerobeli", 135.0, 165.0, "Choco Flakes", "Millets"),
        ("Kellogg's Froot Loops with Multigrain", "285 g Box", "Kellogg's", 175.0, 199.0, "Froot Loops", "Kids Favourite"),
        ("Kellogg's Chocos Fills Caramel Delight", "250 g Box", "Kellogg's", 155.0, 175.0, "Choco Fills", "New"),
        ("Tata Soulfull Corn Flakes+ Millet Shakti", "400 g Pouch", "Tata Soulfull", 125.0, 150.0, "Corn Flakes", "Millet Power"),
        ("Kwality Choco Fills Ziplock Pouch", "250 g Pouch", "Kwality", 115.0, 140.0, "Choco Fills", "18% OFF"),
        ("Kwality Corn Flakes Almond & Honey Mega Saver", "750 g Pack", "Kwality", 230.0, 285.0, "Corn Flakes", "Mega Saver"),
        ("Kwality Fruit Rings Colorful Breakfast Cereal", "375 g Pouch", "Kwality", 140.0, 175.0, "Fruit Rings", "Popular"),
        ("Zerobeli Strawberry Flavoured Corn Flakes", "375 g Box", "Zerobeli", 145.0, 180.0, "Strawberry Flakes", "Real Fruit"),
        ("Bagrry's Choco+ Multigrain Crunch Super Saver", "750 g Pouch", "Bagrry's", 255.0, 320.0, "Choco Flakes", "Super Saver"),
        ("Bagrry's Corn Flakes+ Added Fibre Low Fat", "800 g Pack", "Bagrry's", 215.0, 270.0, "Corn Flakes", "Added Fibre"),
        ("Bagrry's Corn Flakes+ Almond & Honey", "400 g Box", "Bagrry's", 165.0, 200.0, "Corn Flakes", "Almond Honey"),
        ("Nestlé Munch Crunchy Chocolate Breakfast Cereal", "350 g Pouch", "Nestlé", 155.0, 185.0, "Crunchy Cereal", "Hot Deal"),
        ("Parle Hide & Seek Fills Chocolate Hazelnut", "250 g Pack", "Parle", 130.0, 150.0, "Choco Fills", "50% Choco"),
        ("Kellogg's Corn Flakes Real Almond & Honey Trial Pack", "150 g Pouch", "Kellogg's", 65.0, 75.0, "Corn Flakes", "Trial Pack"),
        ("Kellogg's Corn Flakes Original Family Saver", "1.2 kg Box", "Kellogg's", 345.0, 410.0, "Corn Flakes", "Family Pack"),
        ("Kellogg's Chocos Moons & Stars Multigrain", "375 g Pouch", "Kellogg's", 160.0, 190.0, "Chocos", "Iron Rich"),
        ("Kellogg's Special K High Protein & Fibre Cereal", "435 g Box", "Kellogg's", 240.0, 285.0, "Weight Care", "Fit Fuel")
    ]
    f_files = sorted(os.listdir('assets/products/flakes-kids-cereals'))
    f_list = []
    for i, fn in enumerate(f_files):
        t = cereal_types[i % len(cereal_types)]
        suffix = f" - Pack {i//len(cereal_types) + 1}" if i >= len(cereal_types) else ""
        f_list.append({
            'id': f'prod_cereal_{i+1:03d}',
            'name': f"{t[0]}{suffix}",
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1].split()[0] + ' ' + t[1].split()[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFFBA1A1A' if '%' in t[6] else '0xFF006B23',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Breakfast',
            'sub': 'Ready To Eat',
            'rating': round(4.6 + (i % 4) * 0.1, 1),
            'reviews': f"{520 + i * 40}",
            'image': f'assets/products/flakes-kids-cereals/{fn}'
        })
    products_by_category['flakes-kids-cereals'] = f_list

    # 5. Curd & Yogurt (78 files)
    curd_types = [
        ("Epigamia Turbo Greek Yogurt Alphonso Mango (15g Protein)", "125 g Cup", "Epigamia", 65.0, 70.0, "High Protein", "15g Protein"),
        ("Amul Masti Dahi Fresh Set Curd Tub", "400 g Tub", "Amul", 44.0, 45.0, "Set Curd", "Daily Essential"),
        ("Epigamia Strawberry Greek Yogurt Zero Added Sugar", "120 g Cup", "Epigamia", 55.0, 60.0, "Greek Yogurt", "Zero Sugar"),
        ("Milky Mist Fruit Yogurt Real Strawberry", "100 g Cup", "Milky Mist", 35.0, 40.0, "Fruit Yogurt", "Real Fruit"),
        ("Epigamia Greek Yogurt Smoothie Wild Blueberry", "200 ml Bottle", "Epigamia", 75.0, 80.0, "Smoothie", "Probiotic"),
        ("Mother Dairy Classic Dahi Fresh Tub", "400 g Cup", "Mother Dairy", 42.0, 45.0, "Classic Curd", "Fresh"),
        ("Amul Elaichi Shrikhand Tub", "500 g Tub", "Amul", 110.0, 120.0, "Shrikhand", "Traditional"),
        ("Epigamia Wild Raspberry Greek Yogurt", "120 g Cup", "Epigamia", 55.0, 60.0, "Greek Yogurt", "Delicious"),
        ("Amul Greek Yogurt Natural High Protein", "100 g Cup", "Amul", 45.0, 50.0, "Greek Yogurt", "No Preservatives"),
        ("Epigamia Natural Greek Yogurt Pure", "120 g Cup", "Epigamia", 50.0, 55.0, "Greek Yogurt", "Pure Protein"),
        ("High Protein Ghar Jaisa Dahi Pro by Gaurav Taneja", "400 g Tub", "HealthPro", 60.0, 70.0, "Protein Dahi", "15% OFF"),
        ("Amul Masti Dahi Pouch", "400 g Pouch", "Amul", 35.0, 36.0, "Fresh Curd", "Daily Essential"),
        ("Epigamia Crunch Cup Greek Yogurt with Granola", "110 g Cup", "Epigamia", 70.0, 75.0, "Crunch Cup", "Snack Cup"),
        ("Nestlé a+ Dahi Rich & Creamy Curd", "400 g Cup", "Nestlé", 50.0, 55.0, "Creamy Dahi", "Purity Assured"),
        ("Agápi Greek Yogurt Blueberry Delight", "100 g Cup", "Agápi", 60.0, 65.0, "Greek Yogurt", "Artisanal"),
        ("Agápi Greek Yogurt Strawberry Sensation", "100 g Cup", "Agápi", 60.0, 65.0, "Greek Yogurt", "Real Berries"),
        ("Doodhvale Farms Taaza Matka Dahi Natural Clay Pot", "500 g Clay Pot", "Doodhvale Farms", 85.0, 100.0, "Matka Dahi", "Authentic Clay"),
        ("Amul Dahi Classic Pouch", "1 kg Pouch", "Amul", 78.0, 80.0, "Fresh Curd", "Family Pack"),
        ("Epigamia Zero Sugar Greek Yogurt Natural Cup", "120 g Cup", "Epigamia", 55.0, 60.0, "Greek Yogurt", "Zero Sugar"),
        ("Fru Bon Premium Dahi Thick & Delicious Tub", "400 g Tub", "Fru Bon", 45.0, 50.0, "Thick Dahi", "Fresh"),
        ("Mother Dairy Ultimate Dahi Extra Creamy", "400 g Tub", "Mother Dairy", 48.0, 52.0, "Creamy Dahi", "Ultimate"),
        ("Fru Bon Dahi Fresh Pouch", "500 g Pouch", "Fru Bon", 36.0, 38.0, "Fresh Dahi", "Good Value"),
        ("Pride of Cows Artisanal Single Origin Curd", "400 g Glass Jar", "Pride of Cows", 130.0, 150.0, "Artisanal Curd", "Single Origin"),
        ("Epigamia Turbo Greek Yogurt Wild Blueberry", "125 g Cup", "Epigamia", 65.0, 70.0, "High Protein", "15g Protein"),
        ("Epigamia Crunch Cup Mango Yogurt with Honey Granola", "110 g Cup", "Epigamia", 70.0, 75.0, "Crunch Cup", "Delight")
    ]
    curd_files = sorted(os.listdir('assets/products/curd-yogurt'))
    curd_list = []
    for i, fn in enumerate(curd_files):
        t = curd_types[i % len(curd_types)]
        suffix = f" (Variant {i//len(curd_types) + 1})" if i >= len(curd_types) else ""
        curd_list.append({
            'id': f'prod_curd_{i+1:03d}',
            'name': f"{t[0]}{suffix}",
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1].split()[0] + ' ' + t[1].split()[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Daily' in t[6] or 'Protein' in t[6] else '0xFF00569E',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Dairy',
            'sub': 'Curd & Yogurt',
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{780 + i * 45}",
            'image': f'assets/products/curd-yogurt/{fn}'
        })
    products_by_category['curd-yogurt'] = curd_list

    # 6. Fresh Vegetables (154 files)
    all_veg_pool = VEG_SPECIES + [(v[0], v[1], v[2], v[3], v[4], v[5], "Seasonal", "Farm Fresh") for v in MORE_VEG]
    veg_files = sorted(os.listdir('assets/products/fresh-vegetables'))
    veg_list = []
    for i, fn in enumerate(veg_files):
        t = all_veg_pool[i % len(all_veg_pool)]
        round_num = i // len(all_veg_pool)
        size_label = " (Family Pack)" if round_num == 1 else (" (Organic Mandi)" if round_num >= 2 else "")
        veg_list.append({
            'id': f'prod_veg_{i+1:03d}',
            'name': f"{t[0]}{size_label}",
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3] * (1.5 if round_num == 1 else 1.0)),
            'mrp': float(t[4] * (1.5 if round_num == 1 else 1.0)),
            'badge': t[7] if round_num == 0 else ('Value Pack' if round_num == 1 else 'Mandi Fresh'),
            'badgeColor': '0xFFBA1A1A' if '%' in t[7] else '0xFF006B23',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': t[6],
            'sub': t[5],
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{950 + i * 50}",
            'image': f'assets/products/fresh-vegetables/{fn}'
        })
    products_by_category['fresh-vegetables'] = veg_list

    # 7. Bread & Pav (248 files)
    bread_types = [
        ("The Health Factory Zero Maida Footlong Bread", "300 g Loaf", "The Health Factory", 65.0, 75.0, "Footlong", "Zero Maida"),
        ("Paushtaa Organic Healthy Multigrain Cookies", "200 g Canister", "Paushtaa", 185.0, 220.0, "Cookies", "Organic"),
        ("The Cinnamon Kitchen Sugar-Free Cacao & Berry Rocks", "150 g Box", "The Cinnamon Kitchen", 295.0, 350.0, "Sugar-Free", "Artisanal"),
        ("Harvest Gold Pizza Base (Thin Crust)", "200 g (2 pcs)", "Harvest Gold", 40.0, 45.0, "Pizza Base", "Italian Crust"),
        ("Suchali's Buttercrust Milk Bread", "400 g Loaf", "Suchali's", 75.0, 85.0, "Milk Bread", "Artisanal"),
        ("Farm Fresh Brown Eggs Tray", "6 pcs Tray", "Daily Basket Select", 65.0, 75.0, "Brown Eggs", "Country Fresh"),
        ("Britannia 100% Whole Wheat Bread", "400 g Pack", "Britannia", 50.0, 55.0, "Whole Wheat", "100% Atta"),
        ("Double Choco Chip Cookies Gourmet Jar", "250 g Jar", "Cake Tale", 145.0, 175.0, "Cookies", "Choco Rich"),
        ("The Baker's Dozen Sourdough Grissini Breadsticks", "150 g Pack", "The Baker's Dozen", 110.0, 130.0, "Breadsticks", "Sourdough"),
        ("Suchali's Artisanal Sourdough Multigrain Bread", "500 g Loaf", "Suchali's", 140.0, 165.0, "Sourdough", "Stone Ground"),
        ("The Health Factory Multi Protein Footlong Bread", "300 g Loaf", "The Health Factory", 75.0, 85.0, "Footlong", "High Protein"),
        ("Gourmet Belgian Chocolate Walnut Brownie", "150 g Slice", "Cake Tale", 95.0, 120.0, "Brownie", "Fresh Baked"),
        ("Cake Tale Fruit & Nutty Breakfast Muffins", "180 g (3 pcs)", "Cake Tale", 115.0, 135.0, "Muffins", "Berry Delight"),
        ("Fresh Baked Chunky Chocolate Chip Cookie", "1 pc (75g)", "Cake Tale", 45.0, 55.0, "Cookie", "Oven Fresh"),
        ("Harvest Gold Sandwich White Bread", "450 g Pack", "Harvest Gold", 42.0, 48.0, "White Bread", "Daily Essential"),
        ("English Oven Garlic & Oregano Bread", "350 g Loaf", "English Oven", 60.0, 70.0, "Garlic Bread", "Herbed"),
        ("Harvest Gold Premium White Bread", "400 g Pack", "Harvest Gold", 40.0, 45.0, "White Bread", "Soft & Fresh"),
        ("Crispy Italian Rosemary Bread Sticks", "150 g Box", "English Oven", 75.0, 90.0, "Breadsticks", "Crisp"),
        ("English Oven Gourmet Olive Sub Rolls", "250 g (2 pcs)", "English Oven", 55.0, 65.0, "Sub Rolls", "Olive Herb"),
        ("iD Fresh Protein-Rich Whole Wheat Chapati", "350 g (10 pcs)", "iD Fresh", 80.0, 90.0, "Chapati", "11g Protein"),
        ("English Oven Amritsari Atta Kulcha", "250 g (5 pcs)", "English Oven", 50.0, 58.0, "Kulcha", "Soft Tawa"),
        ("The Health Factory Good Zero Zero Maida Bread", "400 g Loaf", "The Health Factory", 70.0, 80.0, "Zero Maida", "0% Maida"),
        ("iD Fresh Mini Malabar Parota", "360 g (8 pcs)", "iD Fresh", 95.0, 110.0, "Parota", "Crisp Layered"),
        ("Chewy Oatmeal Cinnamon Raisin Cookie", "1 pc (75g)", "Cake Tale", 45.0, 55.0, "Cookie", "Whole Grain"),
        ("Gourmet Stacked Fudge Walnut Brownies with Chocolate Drizzle", "250 g Box", "Cake Tale", 160.0, 190.0, "Brownie Box", "Indulgence"),
        ("English Oven 100% Whole Wheat Brown Bread", "400 g Pack", "English Oven", 50.0, 55.0, "Brown Bread", "High Fibre"),
        ("Britannia Daily Fresh Sandwich Bread", "400 g Pack", "Britannia", 40.0, 45.0, "Sandwich Bread", "Daily Essential"),
        ("Fresh Soft Ladi Pav Pack", "250 g (6 pcs)", "Local Bakery", 25.0, 30.0, "Pav", "Oven Fresh"),
        ("English Oven Jumbo Burger Buns", "200 g (2 pcs)", "English Oven", 38.0, 45.0, "Burger Buns", "Sesame Seed"),
        ("English Oven Hot Dog Rolls", "200 g (2 pcs)", "English Oven", 38.0, 45.0, "Hot Dog Buns", "Soft"),
        ("The Baker's Dozen Whole Wheat Sourdough Loaf", "450 g Loaf", "The Baker's Dozen", 125.0, 150.0, "Sourdough", "Natural Yeast"),
        ("Britannia Premium Bake Rusk (Real Elaichi)", "300 g Pack", "Britannia", 55.0, 65.0, "Toast & Rusk", "Tea Time"),
        ("Farm Fresh White Eggs", "12 pcs Tray", "Daily Basket Select", 90.0, 110.0, "Eggs", "Protein Rich"),
        ("Farm Fresh Brown Eggs - Value Pack", "30 pcs Tray", "Daily Basket Select", 295.0, 350.0, "Brown Eggs", "Value Tray"),
        ("English Oven Multigrain Bread with Seeds", "400 g Loaf", "English Oven", 65.0, 75.0, "Multigrain", "7 Seeds")
    ]
    bread_files = sorted(os.listdir('assets/products/bread-pav'))
    bread_list = []
    for i, fn in enumerate(bread_files):
        t = bread_types[i % len(bread_types)]
        round_num = i // len(bread_types)
        suffix = f" (Batch {round_num + 1})" if round_num > 0 else ""
        bread_list.append({
            'id': f'prod_bread_{i+1:03d}',
            'name': f"{t[0]}{suffix}",
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1].split()[0] + ' ' + t[1].split()[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Fresh' in t[6] or 'Daily' in t[6] or 'Zero' in t[6] else '0xFFBA1A1A',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Bakery',
            'sub': 'Bread & Pav' if 'Bread' in t[0] or 'Pav' in t[0] or 'Loaf' in t[0] or 'Sub' in t[0] or 'Kulcha' in t[0] or 'Parota' in t[0] or 'Chapati' in t[0] else ('Eggs' if 'Egg' in t[0] else 'Bread & Pav'),
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{650 + i * 35}",
            'image': f'assets/products/bread-pav/{fn}'
        })
    products_by_category['bread-pav'] = bread_list

    # Also build the high-level category views:
    # 1. 'fresh-fruits-vegetables': fresh-vegetables
    # 2. 'dairy-bread-eggs': milk + curd-yogurt + bread-pav
    # 3. 'snacks-packaged-foods': flakes-kids-cereals
    # 4. 'grocery': poha-daliya-grains + vermicelli
    high_level = {
        'fresh-fruits-vegetables': veg_list,
        'dairy-bread-eggs': m_list + curd_list + bread_list,
        'snacks-packaged-foods': f_list,
        'grocery': p_list + v_list,
    }

    # Combined map with both direct category folders and top-level slugs
    complete_map = {**products_by_category, **high_level}
    
    total_distinct = len(v_list) + len(p_list) + len(m_list) + len(f_list) + len(curd_list) + len(veg_list) + len(bread_list)
    print(f"Catalog generated successfully! Total mapped distinct images: {total_distinct} / 607")
    return complete_map

if __name__ == '__main__':
    catalog = build_catalog()
    
    # Save to JSON
    with open('packages/shared-types/src/products_catalog.json', 'w', encoding='utf-8') as f:
        json.dump(catalog, f, indent=2)
    print("Saved packages/shared-types/src/products_catalog.json")

    with open('services/api/prisma/products_catalog.json', 'w', encoding='utf-8') as f:
        json.dump(catalog, f, indent=2)
    print("Saved services/api/prisma/products_catalog.json")

    # Generate Dart catalog data file
    dart_lines = [
        "// Generated complete product catalog mapping all 607 asset images across 7 categories",
        "import 'package:flutter/material.dart';",
        "",
        "const Map<String, List<Map<String, dynamic>>> kAllCatalogProducts = {"
    ]
    for cat_slug, prods in catalog.items():
        dart_lines.append(f"  '{cat_slug}': [")
        for p in prods:
            dart_lines.append("    {")
            for k, v in p.items():
                if k in ['badgeColor', 'badgeTextColor']:
                    dart_lines.append(f"      '{k}': Color({v}),")
                elif isinstance(v, str):
                    escaped = v.replace("'", "\\'")
                    dart_lines.append(f"      '{k}': '{escaped}',")
                elif isinstance(v, bool):
                    bool_val = 'true' if v else 'false'
                    dart_lines.append(f"      '{k}': {bool_val},")
                elif isinstance(v, (int, float)):
                    dart_lines.append(f"      '{k}': {v},")
            dart_lines.append("    },")
        dart_lines.append("  ],")
    dart_lines.append("};")
    dart_lines.append("")

    dart_content = "\n".join(dart_lines)
    os.makedirs('apps/mobile/lib/core/data', exist_ok=True)
    with open('apps/mobile/lib/core/data/products_catalog_data.dart', 'w', encoding='utf-8') as f:
        f.write(dart_content)
    print(f"Saved apps/mobile/lib/core/data/products_catalog_data.dart ({len(dart_content)} bytes)")

