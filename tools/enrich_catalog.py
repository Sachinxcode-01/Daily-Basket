import os
import json
import random

# We ensure deterministic output by using fixed seeds or index-based mapping
random.seed(42)

def build_enriched_catalog():
    base_assets = 'assets/products'
    categories = [
        'vermicelli',
        'poha-daliya-grains',
        'milk',
        'flakes-kids-cereals',
        'curd-yogurt',
        'fresh-vegetables',
        'bread-pav'
    ]

    # Verify all category folders exist
    for c in categories:
        p = os.path.join(base_assets, c)
        if not os.path.isdir(p):
            raise Exception(f"Missing category folder: {p}")

    products_by_category = {}

    # 1. VERMICELLI (16 files)
    vermi_items = [
        ("MTR Roasted Vermicelli", "400 g Pack", "MTR", 42.0, 50.0, "Roasted Vermicelli", "16% OFF",
         "Premium roasted semolina vermicelli made from selected hard wheat. Pre-roasted to a golden brown for hassle-free, non-sticky upma, payasam, or kheer in minutes.",
         "Roasted Semolina (Wheat)", "Store in a cool, dry place in an airtight container", "12 Months",
         {"Calories": "364 kcal", "Protein": "11.2g", "Carbohydrates": "76.4g", "Dietary Fiber": "3.8g", "Total Fat": "1.2g"},
         ["100% Suji (No Maida)", "Pre-Roasted Golden Brown", "Non-Sticky Texture", "Ready in 5-8 Mins"],
         "Sauté with mustard seeds, curry leaves, ginger, chopped carrots, and green peas for a quick 10-minute breakfast upma.",
         False, True),
        ("Tata Sampann Roasted Vermicelli", "400 g Pack", "Tata Sampann", 45.0, 55.0, "Roasted Vermicelli", "18% OFF",
         "Made with high-protein durum wheat semolina. Stringently sorted and roasted to perfection for high nutritional value and authentic aroma.",
         "100% Durum Wheat Semolina", "Store in a cool, dry and hygienic environment", "9 Months",
         {"Calories": "358 kcal", "Protein": "12.0g", "Carbohydrates": "75.0g", "Dietary Fiber": "4.2g", "Total Fat": "1.0g"},
         ["High Protein Durum Wheat", "Evenly Roasted", "Zero Trans Fat", "High Dietary Fiber"],
         "Perfect for savory lemon vermicelli with roasted peanuts and a pinch of turmeric.",
         False, True),
        ("Two Brothers Organic Khapli Wheat Vermicelli", "500 g Pack", "Two Brothers", 160.0, 190.0, "Organic Khapli", "Organic",
         "Handcrafted from ancient native Emmer (Khapli) wheat grown on certified organic farms. Low glycemic index and exceptionally gentle on digestion.",
         "Stoneground Organic Khapli Wheat Flour, Water", "Store in a dry container away from sunlight", "6 Months",
         {"Calories": "342 kcal", "Protein": "13.5g", "Carbohydrates": "68.2g", "Dietary Fiber": "7.5g", "Total Fat": "1.8g"},
         ["Certified 100% Organic", "Ancient Emmer Wheat", "Low Glycemic Index", "No Preservatives"],
         "Boil with A2 milk, crushed green cardamom pods, and organic jaggery for traditional wholesome kheer.",
         True, True),
        ("MTR Seviyan Vermicelli - Value Pack", "850 g Value Pack", "MTR", 85.0, 105.0, "Seviyan", "19% OFF",
         "Classic unroasted fine vermicelli strands. Ideal for sweet sheer khurma, festive seviyan kheer, or savory breakfast stir-fries.",
         "Wheat Semolina", "Store in an airtight container once opened", "12 Months",
         {"Calories": "360 kcal", "Protein": "10.8g", "Carbohydrates": "77.0g", "Dietary Fiber": "3.5g", "Total Fat": "1.1g"},
         ["Value Family Pack", "Extra Fine Strands", "Ideal for Desserts", "Pure Vegetarian"],
         "Gently roast in pure desi ghee until golden before simmering in full-cream milk with saffron and almonds.",
         False, True),
        ("Zero Maida Whole Wheat Roasted Vermicelli", "400 g Pack", "Zero Maida", 55.0, 65.0, "Whole Wheat", "15% OFF",
         "Zero maida, 100% whole wheat roasted vermicelli. Rich in natural dietary fiber and complex carbohydrates for sustained energy.",
         "100% Whole Wheat Flour (Atta)", "Store in a cool, dry place", "9 Months",
         {"Calories": "348 kcal", "Protein": "11.8g", "Carbohydrates": "72.5g", "Dietary Fiber": "6.8g", "Total Fat": "1.5g"},
         ["Zero Refined Flour (Maida)", "100% Whole Wheat", "High in Dietary Fiber", "Heart Healthy"],
         "Toss with stir-fried bell peppers, cabbage, and light soy sauce for a wholesome Indo-Chinese noodle bowl.",
         False, True),
        ("MTR Rice Sevai (String Hoppers)", "400 g Pack", "MTR", 48.0, 58.0, "Rice Sevai", "17% OFF",
         "Light, gluten-free rice vermicelli made from selected South Indian rice. Incredibly delicate, quick to prepare, and gentle on the stomach.",
         "100% Pure Rice Flour, Water", "Store in a clean, dry place", "12 Months",
         {"Calories": "350 kcal", "Protein": "7.2g", "Carbohydrates": "79.0g", "Dietary Fiber": "1.8g", "Total Fat": "0.6g"},
         ["100% Gluten-Free Rice", "Light & Easy to Digest", "Quick 3-Minute Soak", "Traditional Idiyappam Style"],
         "Soak in hot water for 3 minutes, drain, and temper with fresh grated coconut, green chillies, and mustard seeds.",
         False, True),
        ("Zero Maida Wheat Vermicelli & Noodle Duo", "800 g Combo", "Zero Maida", 110.0, 135.0, "Combo Pack", "Hot Deal",
         "Twin saver pack featuring whole wheat roasted vermicelli and high-fiber whole wheat noodles for nutritious family meals.",
         "Whole Wheat Flour, Durum Semolina", "Store in a dry pantry", "9 Months",
         {"Calories": "352 kcal", "Protein": "11.5g", "Carbohydrates": "73.0g", "Dietary Fiber": "6.2g", "Total Fat": "1.4g"},
         ["Double Value Combo", "100% Whole Wheat Goodness", "Zero Trans Fat", "Versatile Breakfast & Dinner"],
         "Use the vermicelli for breakfast upma and the noodles for evening vegetable chowmein.",
         False, True),
        ("Prolicious High Protein Millet Vermicelli", "300 g Pack", "Prolicious", 95.0, 120.0, "Millet Vermicelli", "High Protein",
         "Power-packed millet vermicelli formulated with jowar, bajra, and plant proteins. Delivers 2x protein compared to standard vermicelli.",
         "Millet Flours (Jowar, Bajra), Plant Protein Isolates, Whole Wheat", "Store in an airtight jar", "9 Months",
         {"Calories": "362 kcal", "Protein": "20.5g", "Carbohydrates": "64.0g", "Dietary Fiber": "8.5g", "Total Fat": "2.2g"},
         ["2x Higher Protein", "Wholesome Multi-Millet Blend", "Low GI Sustained Energy", "Gut Friendly"],
         "Toss with diced paneer, baby spinach, and cherry tomatoes for a post-workout protein bowl.",
         False, True),
        ("Bambino Roasted Vermicelli", "150 g Pack", "Bambino", 20.0, 25.0, "Roasted Vermicelli", "Daily Essential",
         "India's iconic roasted vermicelli in a convenient single-meal pack. Pre-roasted to golden crunch for swift breakfast cooking.",
         "Hard Wheat Semolina", "Keep away from moisture", "12 Months",
         {"Calories": "365 kcal", "Protein": "11.0g", "Carbohydrates": "76.0g", "Dietary Fiber": "3.5g", "Total Fat": "1.0g"},
         ["Convenient 150g Trial Pack", "Pre-Roasted Golden", "No Clumping", "Economical Essential"],
         "Boil with green peas and sweet corn; finish with freshly squeezed lemon juice and chopped coriander.",
         False, True),
        ("Bambino Plain Hard Wheat Vermicelli", "400 g Pack", "Bambino", 38.0, 45.0, "Plain Vermicelli", "15% OFF",
         "Traditional raw non-roasted vermicelli crafted from premium durum wheat semolina. Customizable roasting level for desserts and savory mains.",
         "Durum Wheat Semolina", "Store in a cool dry area", "12 Months",
         {"Calories": "360 kcal", "Protein": "10.5g", "Carbohydrates": "77.5g", "Dietary Fiber": "3.2g", "Total Fat": "0.9g"},
         ["Customizable Roasting", "Firm Al Dente Bite", "Zero Preservatives", "Budget Friendly"],
         "Roast slowly in a dry pan until amber brown before making classic Eid sheer khurma with pistachios and chironji.",
         False, True),
        ("Bambino Roasted Vermicelli - Family Pack", "400 g Pack", "Bambino", 42.0, 50.0, "Roasted Vermicelli", "16% OFF",
         "The trusted breakfast staple in a standard family size. Evenly roasted under automated infrared ovens to lock in authentic nutty aroma.",
         "Wheat Semolina", "Store in a cool and dry container", "12 Months",
         {"Calories": "365 kcal", "Protein": "11.0g", "Carbohydrates": "76.0g", "Dietary Fiber": "3.5g", "Total Fat": "1.0g"},
         ["Infrared Even Roasting", "Zero Artificial Colors", "Kid Friendly", "Versatile"],
         "Make a festive semiya payasam with sweetened condensed milk and golden raisins sautéed in ghee.",
         False, True),
        ("Bambino Roasted Vermicelli - Mega Saver", "850 g Pack", "Bambino", 78.0, 95.0, "Roasted Vermicelli", "18% OFF",
         "Large mega saver pack of golden roasted vermicelli for big families and weekly meal-prep lovers. Guaranteed crisp quality in every batch.",
         "Durum Wheat Semolina", "Airtight storage recommended", "12 Months",
         {"Calories": "365 kcal", "Protein": "11.0g", "Carbohydrates": "76.0g", "Dietary Fiber": "3.5g", "Total Fat": "1.0g"},
         ["Mega Saver 850g", "Long Shelf Life", "Stays Fresh", "Quick Cooking"],
         "Steam in an idli steamer after mixing with yogurt, tempering, and grated ginger for instant vermicelli idlis.",
         False, True),
        ("Bambino Roasted Vermicelli Easy-Store Jar", "1 kg Jar", "Bambino", 115.0, 140.0, "Storage Jar", "Popular",
         "Reusable pantry-ready PET jar packed with 1kg of premium roasted vermicelli. Keeps moisture out and preserves crunchiness for months.",
         "Semolina (Durum Wheat)", "Store jar tightly closed", "12 Months",
         {"Calories": "365 kcal", "Protein": "11.0g", "Carbohydrates": "76.0g", "Dietary Fiber": "3.5g", "Total Fat": "1.0g"},
         ["Reusable PET Storage Jar", "Pest-Resistant Packaging", "1 kg Value Size", "Instant Access"],
         "Scoop directly into boiling water for effortless weekday dinners.",
         False, True),
        ("Two Brothers Khapli Emmer Wheat Vermicelli", "350 g Pack", "Two Brothers", 145.0, 175.0, "Khapli Vermicelli", "Organic",
         "Artisanal farm-crafted vermicelli made from heirloom Khapli Emmer wheat. Unbleached, unrefined, and sun-dried according to age-old methods.",
         "Native Khapli Wheat, Spring Water", "Store in a cool dry cabinet", "6 Months",
         {"Calories": "345 kcal", "Protein": "13.2g", "Carbohydrates": "69.0g", "Dietary Fiber": "7.2g", "Total Fat": "1.7g"},
         ["Ancient Heirloom Grain", "Sun-Dried Artisanal", "Zero Chemical Processing", "Nutty Complex Flavor"],
         "Simmer with almond milk and deglet nour dates for a wholesome, naturally sweetened dessert.",
         True, True),
        ("Hamdard Khaalis Roasted Seviyan", "200 g Pack", "Hamdard", 35.0, 42.0, "Roasted Seviyan", "Festival Special",
         "Special thin festival seviyan roasted in pure ghee essence. Ultra-slender strands that melt on the tongue for authentic royal desserts.",
         "Fine Wheat Semolina, Ghee Essence", "Keep sealed in dry pantry", "9 Months",
         {"Calories": "372 kcal", "Protein": "10.2g", "Carbohydrates": "75.5g", "Dietary Fiber": "3.0g", "Total Fat": "2.4g"},
         ["Ultra Fine Slender Strands", "Festive Royal Flavor", "Ghee Essence Infused", "Quick Softening"],
         "Cook with full-cream milk, crushed green cardamom, saffron, and slivered pistachios for authentic Eid Sheer Khurma.",
         False, True),
        ("Real Thai Rice Vermicelli Noodles", "375 g Pack", "Real Thai", 185.0, 220.0, "Rice Vermicelli", "Imported",
         "Authentic imported Thai rice vermicelli noodles. Non-sticky, naturally gluten-free, and ideal for clear soups, pad thai, and fresh spring rolls.",
         "100% Rice Flour, Water", "Store in ambient room temperature", "24 Months",
         {"Calories": "356 kcal", "Protein": "7.0g", "Carbohydrates": "80.0g", "Dietary Fiber": "1.5g", "Total Fat": "0.5g"},
         ["Authentic Imported Thai", "Naturally Gluten-Free", "Zero Trans Fat", "Versatile Asian Cooking"],
         "Steep in boiling water for 4 minutes, rinse with cold water, and toss with crunchy bean sprouts and peanut sauce.",
         False, True)
    ]

    v_files = sorted(os.listdir(os.path.join(base_assets, 'vermicelli')))
    v_list = []
    for i, fn in enumerate(v_files):
        t = vermi_items[i % len(vermi_items)]
        v_list.append({
            'id': f'prod_vermi_{i+1:03d}',
            'name': t[0],
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Organic' in t[6] or 'Protein' in t[6] else '0xFFBA1A1A',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Vermicelli & Seviyan',
            'sub': t[5],
            'categorySlug': 'vermicelli',
            'folder': 'vermicelli',
            'rating': round(4.5 + (i % 5) * 0.1, 1),
            'reviews': f"{340 + i * 45}",
            'image': f'assets/products/vermicelli/{fn}',
            'description': t[7],
            'ingredients': t[8],
            'storage': t[9],
            'shelfLife': t[10],
            'nutrition': t[11],
            'keyBenefits': t[12],
            'chefTip': t[13],
            'isOrganic': t[14],
            'isVeg': t[15]
        })
    products_by_category['vermicelli'] = v_list

    # 2. POHA, DALIYA & PANTRY GRAINS (17 files)
    # Notice: We fix the category and sub for every item accurately!
    poha_curated = [
        ("Nestle Everyday Dairy Whitener", "400 g Pouch", "Nestle", 240.0, 260.0, "Dairy Whitener", "Daily Essential",
         "Premium dairy whitener specially formulated for rich, creamy, and smooth tea and coffee without curdling.",
         "Partially Skimmed Milk Solids, Sugar", "Store in an airtight container after opening", "12 Months",
         {"Calories": "432 kcal", "Protein": "17.0g", "Carbohydrates": "54.0g", "Total Fat": "16.0g", "Calcium": "680mg"},
         ["Dissolves Instantly", "Rich Creamy Foam", "Makes 30+ Cups of Tea", "Made with Quality Milk"],
         "Whisk 2 tablespoons directly into hot brewed black tea for rich Punjabi-style chai.",
         "Dairy & Breakfast", "milk", False, True),
        ("MTR Roasted Vermicelli Instant Pack", "400 g Pouch", "MTR", 42.0, 50.0, "Roasted Vermicelli", "16% OFF",
         "Crisp pre-roasted semolina vermicelli for quick savory upma and celebratory puddings.",
         "Wheat Semolina", "Store in a cool dry container", "12 Months",
         {"Calories": "364 kcal", "Protein": "11.0g", "Carbohydrates": "76.0g", "Total Fat": "1.2g", "Dietary Fiber": "3.8g"},
         ["Pre-Roasted", "Non-Sticky", "Pure Suji", "10-Min Prep"],
         "Temper with mustard seeds and curry leaves for instant South Indian breakfast upma.",
         "Vermicelli & Seviyan", "vermicelli", False, True),
        ("Cavin's Kaju Butterscotch Milkshake", "200 ml Tetra", "Cavin's", 38.0, 45.0, "Flavoured Milk", "15% OFF",
         "Deliciously creamy flavored milkshake infused with real cashew nuts and rich butterscotch delight.",
         "Toned Milk, Sugar, Cashew Bits, Butterscotch Flavor", "Serve chilled. Refrigerate after opening.", "6 Months",
         {"Calories": "178 kcal", "Protein": "6.2g", "Carbohydrates": "24.0g", "Total Fat": "5.8g", "Calcium": "180mg"},
         ["Real Cashew Nut Bits", "Rich Butterscotch Flavor", "Good Source of Calcium", "On-the-Go Drink"],
         "Chill for 2 hours in the refrigerator and shake well before serving for a refreshing summer cooler.",
         "Milk & Dairy Drinks", "milk", False, True),
        ("Rajdhani Thick Poha (Flattened Rice)", "500 g Pack", "Rajdhani", 34.0, 42.0, "Poha", "19% OFF",
         "Premium thick beaten rice flakes processed from superior quality paddy. Retains shape after soaking for fluffy, non-mushy Kanda Batata Poha.",
         "100% Beaten Rice Flakes", "Store in an airtight container", "6 Months",
         {"Calories": "353 kcal", "Protein": "6.6g", "Carbohydrates": "77.3g", "Total Fat": "1.0g", "Iron": "20mg"},
         ["Naturally Gluten-Free", "Rich in Dietary Iron", "Retains Fluffy Texture", "Light on Stomach"],
         "Rinse gently in cold water for 30 seconds; toss with mustard seeds, curry leaves, peanuts, and turmeric.",
         "Poha, Daliya & Grains", "poha-daliya-grains", False, True),
        ("Nestle Milkmaid Sweetened Condensed Milk", "380 g Tin", "Nestle", 144.0, 155.0, "Condensed Milk", "Dessert Essential",
         "India's iconic sweetened condensed milk made with pure cow milk and sugar. Creates luscious, creamy mithais, cheesecakes, and halwa.",
         "Pasteurized Milk, Sugar", "Refrigerate after opening in a clean glass container", "9 Months",
         {"Calories": "321 kcal", "Protein": "7.9g", "Carbohydrates": "56.0g", "Total Fat": "8.0g", "Calcium": "260mg"},
         ["Rich Creamy Texture", "Real Milk Goodness", "Essential for Mithai", "Versatile Dessert Base"],
         "Blend with fresh fruit puree and whipped cream to make 3-ingredient homemade ice cream.",
         "Dairy & Desserts", "milk", False, True),
        ("Godrej Yummiez Chicken Pepper & Herb Sausages", "250 g Pack", "Godrej Yummiez", 195.0, 225.0, "Ready to Cook", "Non-Veg",
         "Juicy chicken breakfast sausages seasoned with freshly cracked black pepper and aromatic garden herbs. Flash frozen to seal in juiciness.",
         "Chicken Meat (65%), Water, Herb Seasoning, Black Pepper", "Keep frozen at -18°C or below", "9 Months",
         {"Calories": "210 kcal", "Protein": "14.5g", "Carbohydrates": "4.5g", "Total Fat": "15.0g", "Sodium": "580mg"},
         ["Real Chicken Meat", "Aromatic Cracked Pepper", "Pan Fry in 4 Mins", "Zero Added Hormones"],
         "Pan-sear on medium heat with a knob of butter for 3-4 minutes until golden brown; serve with toast.",
         "Meat & Breakfast Sausages", "poha-daliya-grains", False, False),
        ("iD Fresh Idly & Dosa Batter", "1 kg Pouch", "iD Fresh", 85.0, 95.0, "Fresh Batter", "Fresh Daily",
         "Traditional stone-ground, naturally fermented batter made with RO water and zero soda or preservatives. Yields soft idlis and crispy dosas.",
         "Rice, Urad Dal, Fenugreek Seeds, Water, Salt", "Keep refrigerated between 0°C to 5°C", "7 Days",
         {"Calories": "135 kcal", "Protein": "4.2g", "Carbohydrates": "28.0g", "Total Fat": "0.5g", "Fiber": "1.8g"},
         ["Naturally Fermented", "Zero Soda or Chemical Leavening", "Stone-Ground Texture", "Makes 15+ Dosas"],
         "Pour thin on a hot tawa with a drizzle of ghee for golden paper-roast dosa.",
         "Fresh Batter & Breakfast", "poha-daliya-grains", False, True),
        ("MTR 3 Minute Breakfast Seviyan Upma", "160 g Pack", "MTR", 45.0, 55.0, "Instant Breakfast", "Quick Cook",
         "Instant homestyle seviyan upma with crunchy carrots, green peas, and South Indian spices. Ready in just 3 minutes with boiling water.",
         "Semolina Vermicelli, Edible Vegetable Fat, Vegetables, Salt, Mustard, Spices", "Store in a cool dry place", "9 Months",
         {"Calories": "380 kcal", "Protein": "9.5g", "Carbohydrates": "68.0g", "Total Fat": "8.0g", "Fiber": "3.5g"},
         ["Ready in 3 Minutes", "Contains Real Vegetables", "No Added Artificial Flavors", "Convenient Travel Meal"],
         "Pour boiling water up to the mark inside the cup, cover for 3 minutes, stir, and enjoy hot.",
         "Instant Meals & Breakfast", "vermicelli", False, True),
        ("Britannia Classic Processed Cheese Slices", "200 g (10 Slices)", "Britannia", 140.0, 155.0, "Cheese", "Dairy",
         "Individually wrapped creamy cheese slices made from pure cow milk. Perfect melt for grilled sandwiches, burgers, and stuffed parathas.",
         "Cheese, Milk Solids, Emulsifying Salts, Common Salt", "Keep refrigerated at 4°C", "9 Months",
         {"Calories": "310 kcal", "Protein": "18.0g", "Carbohydrates": "3.5g", "Total Fat": "24.5g", "Calcium": "550mg"},
         ["Made with Cow Milk", "Superior Melty Texture", "10 Individually Wrapped Slices", "Rich in Calcium & Protein"],
         "Place between warm sourdough slices with sliced tomatoes for a gooey grilled cheese sandwich.",
         "Cheese & Dairy", "curd-yogurt", False, True),
        ("Whole Farm Sabudana (Tender Sago Pearls)", "500 g Pack", "Whole Farm", 65.0, 80.0, "Sabudana", "Pooja & Vrat",
         "Carefully selected, round and pearly white sabudana. Non-sticky when soaked, making it the top choice for Vrat Sabudana Khichdi and Vadas.",
         "100% Tapioca Starch", "Store in a cool dry place", "12 Months",
         {"Calories": "358 kcal", "Protein": "0.2g", "Carbohydrates": "88.7g", "Total Fat": "0.2g", "Fiber": "1.0g"},
         ["Pearly Non-Sticky Texture", "Vrat & Fasting Essential", "Naturally Gluten-Free", "Light Energy Fuel"],
         "Sprinkle water over soaked sabudana and saute with roasted crushed peanuts, green chillies, and cumin seeds.",
         "Poha, Daliya & Grains", "poha-daliya-grains", False, True),
        ("Dabur 100% Pure Squeezy Honey", "500 g Bottle", "Dabur", 199.0, 235.0, "Pure Honey", "15% OFF",
         "100% pure raw honey tested for zero sugar adulteration. Packed in an easy-squeezy, mess-free bottle for morning warm water or toast.",
         "100% Natural Honey", "Do not refrigerate. Store at room temperature", "18 Months",
         {"Calories": "320 kcal", "Protein": "0.3g", "Carbohydrates": "80.0g", "Total Fat": "0.0g", "Natural Sugars": "80g"},
         ["Zero Added Sugar / Adulterants", "Mess-Free Squeezy Spout", "Natural Antioxidants", "Immunity Booster"],
         "Squeeze over warm oatmeal or mix with lukewarm lemon water first thing in the morning.",
         "Honey & Spreads", "poha-daliya-grains", False, True),
        ("MyFitness All-Natural Chocolate Peanut Butter", "510 g Jar", "MyFitness", 349.0, 399.0, "Peanut Butter", "High Protein",
         "Slow-roasted export-grade peanuts ground with dark unsweetened Belgian cocoa. Delivers 26g protein per 100g with zero trans fat.",
         "Roasted Peanuts (90%), Cocoa Powder, Brown Sugar, Salt", "Store in a cool, dry place. Oil separation is natural", "12 Months",
         {"Calories": "585 kcal", "Protein": "26.0g", "Carbohydrates": "21.0g", "Total Fat": "44.0g", "Fiber": "7.0g"},
         ["26g Protein per 100g", "Real Dark Belgian Cocoa", "Zero Cholesterol & Trans Fat", "High Energy Snack"],
         "Spread over whole wheat toast or blend with a chilled banana and almond milk for a power smoothie.",
         "Spreads & Peanut Butter", "poha-daliya-grains", False, True),
        ("Rajdhani Premium Vrat Sabudana", "500 g Pack", "Rajdhani", 68.0, 85.0, "Sabudana", "Vrat Special",
         "Evenly sized, dust-free tapioca pearls. Soaks evenly without dissolving into paste for crunchy Sabudana Vadas.",
         "Refined Tapioca Starch", "Store in an airtight container", "12 Months",
         {"Calories": "355 kcal", "Protein": "0.3g", "Carbohydrates": "88.0g", "Total Fat": "0.2g", "Fiber": "0.9g"},
         ["Uniform Large Pearls", "Triple Cleaned & Sorted", "Hygienically Packed", "Fasting Approved"],
         "Mix soaked pearls with boiled mashed potatoes, rock salt, and chopped cilantro, then shallow fry into crisp patties.",
         "Poha, Daliya & Grains", "poha-daliya-grains", False, True),
        ("Amul Pasteurised Salted Table Butter", "100 g Pack", "Amul", 58.0, 62.0, "Table Butter", "Daily Essential",
         "The classic Utterly Butterly Delicious table butter made from pure fresh pasteurized cream with just the right touch of salt.",
         "Butter (Milk Fat 80%), Common Salt, Annatto Color", "Keep refrigerated at 4°C or below", "12 Months",
         {"Calories": "717 kcal", "Protein": "0.8g", "Carbohydrates": "0.0g", "Total Fat": "80.0g", "Sodium": "820mg"},
         ["100% Pure Fresh Cream", "Iconic Creamy Salty Taste", "Spreads Beautifully", "Rich in Vitamin A"],
         "Slather generously over hot aloo parathas, toasted ladi pav, or warm sourdough slices.",
         "Butter & Spreads", "milk", False, True),
        ("RiteBite Max Protein Daily Choco Almond Bar", "50 g Bar", "Max Protein", 65.0, 75.0, "Protein Bar", "Energy Snack",
         "Delicious on-the-go protein bar delivering 10g protein and 4g fiber. Made with real California almonds and dark chocolate.",
         "Protein Blend (Whey, Soy), Dark Chocolate, Almonds, Rolled Oats, Flax Seeds", "Store in a cool dry place below 25°C", "9 Months",
         {"Calories": "195 kcal", "Protein": "10.0g", "Carbohydrates": "22.0g", "Total Fat": "7.0g", "Fiber": "4.2g"},
         ["10g Protein & 4g Fiber", "Real California Almonds", "Sustained 2-Hour Energy", "Pocket Sized Fuel"],
         "Carry in your gym bag or commute backpack for a quick, guilt-free midday energy boost.",
         "Energy Bars & Snacks", "flakes-kids-cereals", False, True),
        ("Rajdhani Roasted Wheat Dalia (Cracked Wheat)", "500 g Pack", "Rajdhani", 42.0, 50.0, "Wheat Dalia", "Fiber Rich",
         "Finely broken whole wheat kernels pre-roasted to golden perfection. Packed with dietary fiber and complex carbs for high stamina.",
         "100% Whole Wheat Dalia", "Store in an airtight jar", "9 Months",
         {"Calories": "344 kcal", "Protein": "12.2g", "Carbohydrates": "71.0g", "Total Fat": "1.5g", "Dietary Fiber": "10.5g"},
         ["High Fiber (10.5g/100g)", "Pre-Roasted Golden", "Lowers Cholesterol", "Diabetic Friendly"],
         "Pressure cook with yellow moong dal, ginger, and turmeric for a comforting, gut-healing khichdi.",
         "Poha, Daliya & Grains", "poha-daliya-grains", False, True),
        ("Rajdhani Special Thick Poha - Mandi Select", "1 kg Pack", "Rajdhani", 66.0, 80.0, "Poha", "18% OFF",
         "1kg mega value pack of thick flattened rice. Handpicked from prime harvest clusters to ensure zero broken grains.",
         "100% Paddy Flattened Rice", "Keep in an airtight container away from moisture", "6 Months",
         {"Calories": "353 kcal", "Protein": "6.6g", "Carbohydrates": "77.3g", "Total Fat": "1.0g", "Iron": "20mg"},
         ["1 kg Mega Saver", "Mandi Select Grade", "Zero Broken Grains", "Stays Fresh"],
         "Great for making Indori Poha topped with spicy sev, fresh pomegranate seeds, and chopped onions.",
         "Poha, Daliya & Grains", "poha-daliya-grains", False, True)
    ]

    p_files = sorted(os.listdir(os.path.join(base_assets, 'poha-daliya-grains')))
    p_list = []
    for i, fn in enumerate(p_files):
        t = poha_curated[i % len(poha_curated)]
        p_list.append({
            'id': f'prod_poha_{i+1:03d}',
            'name': t[0],
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Organic' in t[6] or 'Daily' in t[6] or 'Protein' in t[6] else '0xFFBA1A1A',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': t[14],
            'sub': t[5],
            'categorySlug': t[15],
            'folder': 'poha-daliya-grains',
            'rating': round(4.5 + (i % 5) * 0.1, 1),
            'reviews': f"{420 + i * 50}",
            'image': f'assets/products/poha-daliya-grains/{fn}',
            'description': t[7],
            'ingredients': t[8],
            'storage': t[9],
            'shelfLife': t[10],
            'nutrition': t[11],
            'keyBenefits': t[12],
            'chefTip': t[13],
            'isOrganic': t[16],
            'isVeg': t[17]
        })
    products_by_category['poha-daliya-grains'] = p_list

    # 3. MILK (41 files)
    # We create realistic data for all 41 milk files:
    milk_sources = [
        ("Amul Buffalo Milk A2 Pouch", "500 ml Pouch", "Amul", 35.0, 36.0, "Buffalo Milk", "A2 Rich", 6.5, 3.8, 85),
        ("Mother Dairy Toned Fresh Milk", "1 L Tetrapack", "Mother Dairy", 72.0, 75.0, "Toned Milk", "Fresh Daily", 3.0, 3.2, 60),
        ("Yakult Light Probiotic Drink", "5 x 65 ml Pack", "Yakult", 90.0, 95.0, "Probiotic Drink", "Gut Health", 0.1, 1.2, 45),
        ("Mother Dairy Promilk Protein Rich", "500 ml Pouch", "Mother Dairy", 36.0, 38.0, "High Protein Milk", "30% Extra Protein", 4.0, 5.0, 78),
        ("Amul Buffalo Milk A2 Premium", "1 L Pouch", "Amul", 70.0, 72.0, "Buffalo Milk", "Rich Cream", 6.5, 3.8, 85),
        ("Yakult Light Sugar-Free", "5 x 65 ml Pack", "Yakult", 95.0, 100.0, "Probiotic Drink", "Zero Sugar", 0.1, 1.2, 38),
        ("Heritage Happy Full Cream Milk", "500 ml Pouch", "Heritage", 34.0, 36.0, "Full Cream Milk", "Wholesome", 6.0, 3.5, 82),
        ("Amul Desi A2 Cow Milk Bottle", "1 L PET Bottle", "Amul", 85.0, 90.0, "Desi Cow Milk", "A2 Certified", 4.0, 3.4, 68),
        ("Amul Taaza Toned Fresh Milk", "500 ml Pouch", "Amul", 28.0, 28.0, "Toned Milk", "Daily Essential", 3.0, 3.2, 58),
        ("Yakult Original Probiotic Health Drink", "5 x 65 ml Pack", "Yakult", 85.0, 90.0, "Probiotic Drink", "Immunity", 0.1, 1.2, 52),
        ("Amul Cow Milk Tetrapack", "1 L Tetrapack", "Amul", 75.0, 78.0, "Cow Milk", "Nutritious", 3.5, 3.3, 62),
        ("Amul Buffalo Milk A2 Tetrapack", "1 L Tetrapack", "Amul", 80.0, 85.0, "Buffalo Milk", "A2 Purity", 6.5, 3.8, 85),
        ("Amul Gold Full Cream Milk Pouch", "500 ml Pouch", "Amul", 33.0, 34.0, "Full Cream Milk", "6% Fat", 6.0, 3.5, 82),
        ("Mother Dairy Pure Buffalo Milk", "1 L Pouch", "Mother Dairy", 72.0, 74.0, "Buffalo Milk", "Creamy", 6.5, 3.8, 85),
        ("Country Delight Farm Fresh Buffalo Milk", "1 L Pouch", "Country Delight", 84.0, 88.0, "Buffalo Milk", "Pure Farm", 6.8, 3.9, 88),
        ("Mother Dairy LiveLite Low Fat Milk", "500 ml Pouch", "Mother Dairy", 27.0, 29.0, "Low Fat Milk", "Weight Care", 1.5, 3.4, 48),
        ("Nestle a+ Slim Skimmed Milk", "1 L Carton", "Nestle", 88.0, 95.0, "Skimmed Milk", "Zero Fat", 0.2, 3.5, 38),
        ("Amul Taaza Toned Milk Carton", "1 L Carton", "Amul", 72.0, 75.0, "Toned Milk", "Homogenised", 3.0, 3.2, 58),
        ("Amul Lactose Free Fresh Milk", "1 L Carton", "Amul", 95.0, 105.0, "Lactose Free", "Easy Digest", 3.0, 3.2, 58),
        ("Amul T-Special High Fat Milk", "1 L Pouch", "Amul", 68.0, 70.0, "Special Milk", "Chai Special", 7.0, 3.6, 92),
        ("Amul Gold Standardised Milk Carton", "1 L Carton", "Amul", 78.0, 82.0, "Full Cream Milk", "Gold Quality", 6.0, 3.5, 82),
        ("Amul Taaza Long Life Toned Milk", "1 L Tetra", "Amul", 72.0, 75.0, "Toned Milk", "Long Life", 3.0, 3.2, 58),
        ("Humpy Farms Desi Gir Cow A2 Milk", "1 L Pouch", "Humpy Farms", 110.0, 125.0, "Desi Cow Milk", "Farm Direct", 4.2, 3.6, 72),
        ("Mother Dairy Toned Pouch Milk", "500 ml Pouch", "Mother Dairy", 28.0, 28.0, "Toned Milk", "Daily Essential", 3.0, 3.2, 58),
        ("Saras Taaza Pasteurised Milk", "500 ml Pouch", "Saras", 26.0, 27.0, "Toned Milk", "Pure", 3.0, 3.1, 56),
        ("Amul Camel Milk Pasteurised", "200 ml Bottle", "Amul", 35.0, 40.0, "Camel Milk", "Health Special", 2.8, 3.1, 54),
        ("Country Delight Fresh Cow Milk", "1 L Pouch", "Country Delight", 78.0, 82.0, "Cow Milk", "Direct From Farm", 3.8, 3.4, 65),
        ("Mother Dairy Full Cream Milk", "1 L Pouch", "Mother Dairy", 68.0, 70.0, "Full Cream Milk", "Rich Taste", 6.0, 3.5, 82),
        ("Amul Slim 'n' Trim Skimmed Milk", "1 L Carton", "Amul", 74.0, 78.0, "Skimmed Milk", "Fit Choice", 0.2, 3.4, 38),
        ("Amul Cow Milk Pasteurised", "500 ml Pouch", "Amul", 29.0, 30.0, "Cow Milk", "Cow Purity", 3.5, 3.3, 62),
        ("Amul Buffalo Milk Fresh Pouch", "500 ml Pouch", "Amul", 35.0, 36.0, "Buffalo Milk", "Rich Quality", 6.5, 3.8, 85),
        ("Nestle a+ Nourish Toned Milk", "1 L Carton", "Nestle", 82.0, 88.0, "Toned Milk", "Nourish+", 3.0, 3.2, 58),
        ("Mother Dairy Homogenised Long Life Milk", "1 L Carton", "Mother Dairy", 74.0, 78.0, "Toned Milk", "UHT Purity", 3.0, 3.2, 58),
        ("Amul Moti Long Life 90 Days Milk", "450 ml Pouch", "Amul", 32.0, 33.0, "Toned Milk", "90 Days Fresh", 3.0, 3.2, 58),
        ("Amul Desi Cow Milk Farm Fresh", "500 ml Pouch", "Amul", 32.0, 34.0, "Cow Milk", "Desi Breed", 4.0, 3.4, 68),
        ("Provilac High Protein Fresh Milk", "250 ml Bottle", "Provilac", 60.0, 70.0, "High Protein Milk", "Zero Additives", 4.0, 6.0, 85),
        ("Amul Calci+ Calcium Fortified Milk", "1 L Carton", "Amul", 85.0, 92.0, "Fortified Milk", "Calcium Rich", 3.0, 3.4, 62),
        ("Mother Dairy Special Cow Milk", "500 ml Pouch", "Mother Dairy", 30.0, 31.0, "Cow Milk", "Special Sweetness", 3.5, 3.3, 62),
        ("Country Delight x HRX 25g High Protein Milk", "450 ml Pouch", "Country Delight", 65.0, 75.0, "High Protein Milk", "Fitness Fuel", 4.2, 6.2, 90),
        ("Mother Dairy Fit Life Low Fat Milk", "500 ml Pouch", "Mother Dairy", 28.0, 30.0, "Low Fat Milk", "Active Life", 1.5, 3.4, 48),
        ("Mother Dairy Fit Life Double Toned Milk", "1 L Pouch", "Mother Dairy", 54.0, 56.0, "Double Toned", "Light & Fresh", 1.5, 3.3, 46)
    ]

    m_files = sorted(os.listdir(os.path.join(base_assets, 'milk')))
    m_list = []
    for i, fn in enumerate(m_files):
        t = milk_sources[i % len(milk_sources)]
        m_list.append({
            'id': f'prod_milk_{i+1:03d}',
            'name': t[0],
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Daily' in t[6] or 'Fresh' in t[6] or 'Protein' in t[6] or 'A2' in t[6] else '0xFF00569E',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Fresh & Fortified Milk',
            'sub': t[5],
            'categorySlug': 'milk',
            'folder': 'milk',
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{1100 + i * 85}",
            'image': f'assets/products/milk/{fn}',
            'description': f"100% farm fresh pasteurized {t[5].lower()} sourced directly from hygienic local farms. Quality tested across 60+ purity parameters and delivered chilled in 10 minutes.",
            'ingredients': "Pasteurized Standardized / Toned Bovine Milk, Vitamin A & D2",
            'storage': "Keep refrigerated at 4°C or below. Consume within 2 days of opening",
            'shelfLife': "2-3 Days (Pouch) / 90-180 Days (UHT Carton)",
            'nutrition': {
                "Calories": f"{t[9]} kcal",
                "Protein": f"{t[8]}g",
                "Fat": f"{t[7]}g",
                "Carbohydrates": "4.8g",
                "Calcium": f"{int(t[8] * 38)}mg"
            },
            'keyBenefits': ["60+ Quality & Purity Checks", "Pasteurized & Homogenized", "Cold-Chain Maintained", "Natural Source of Calcium & B12"],
            'chefTip': "Boil gently on low flame for silky malai or froth directly for authentic filter coffee and kadak chai.",
            'isOrganic': 'A2' in t[0] or 'Gir' in t[0] or 'Farm' in t[0],
            'isVeg': True
        })
    products_by_category['milk'] = m_list

    # 4. FLAKES & KIDS CEREALS (53 files)
    cereal_sources = [
        ("Nestle Munch Choco Fills Cereal", "375 g Box", "Nestle", 165.0, 195.0, "Choco Fills", "15% OFF",
         "Crunchy cereal pillows filled with melted chocolate cream. Stays crunchy in warm milk for fun breakfasts.",
         "Rice Flour, Whole Wheat, Cocoa Solids, Sugar, Milk Solids", "Store in a cool dry place away from pests", "9 Months",
         {"Calories": "420 kcal", "Protein": "7.5g", "Carbohydrates": "78.0g", "Dietary Fiber": "4.2g", "Total Fat": "9.5g"},
         ["Real Melt-in-Mouth Choco Core", "Crunchy Wheat Shell", "Rich in Iron & B-Vitamins", "Kid Approved"],
         "Enjoy as a crunchy finger snack right out of the box or pour chilled farm milk over a heaping bowl.", False, True),
        ("Kwality Cookie Rings Breakfast Cereal", "375 g Box", "Kwality", 145.0, 180.0, "Cookie Rings", "19% OFF",
         "Fun cookie-shaped cereal rings with rich chocolate chip flavor. Fortified with essential vitamins and minerals.",
         "Corn Flour, Wheat Flour, Sugar, Cocoa Solids, Minerals", "Store in an airtight container once opened", "9 Months",
         {"Calories": "395 kcal", "Protein": "6.8g", "Carbohydrates": "82.0g", "Dietary Fiber": "3.8g", "Total Fat": "4.5g"},
         ["Fun Cookie Ring Shapes", "10 Essential Vitamins & Iron", "Crunchy & Low Fat", "No Trans Fat"],
         "Pair with chilled strawberry milk for an irresistible kids weekend treat.", False, True),
        ("Kwality Fruit Rings & Choco Fills Combo", "500 g Combo", "Kwality", 210.0, 260.0, "Cereal Combo", "Value Pack",
         "The ultimate morning duo featuring vibrant fruity multi-grain rings and molten choco-filled pillows.",
         "Multigrain Flours (Corn, Rice, Wheat), Natural Fruit Extracts, Cocoa Solids", "Store in ambient pantry", "9 Months",
         {"Calories": "408 kcal", "Protein": "7.2g", "Carbohydrates": "80.0g", "Dietary Fiber": "4.0g", "Total Fat": "7.0g"},
         ["Twin Variety Saver Pack", "Natural Fruit Flavors", "Molten Chocolate Center", "Great Value"],
         "Mix both varieties 50-50 in a bowl for a colorful breakfast medley.", False, True),
        ("Kellogg's All-Bran Wheat Flakes High Fibre", "425 g Box", "Kellogg's", 185.0, 215.0, "Wheat Flakes", "High Fibre",
         "100% whole wheat flakes loaded with natural wheat bran. Provides 20% of your daily fiber requirements in one bowl.",
         "Whole Wheat (88%), Wheat Bran, Sugar, Salt, Malt Extract", "Keep inside sealed inner bag after use", "12 Months",
         {"Calories": "355 kcal", "Protein": "10.5g", "Carbohydrates": "72.0g", "Dietary Fiber": "11.5g", "Total Fat": "1.8g"},
         ["11.5g Dietary Fiber per 100g", "100% Whole Wheat", "Promotes Digestive Wellness", "Heart Healthy"],
         "Top with sliced fresh bananas, chia seeds, and a drizzle of raw honey.", False, True),
        ("Organic Tattva 100% Certified Organic Quinoa", "500 g Pack", "Organic Tattva", 199.0, 245.0, "Organic Quinoa", "Organic",
         "Pre-washed royal white quinoa grown without synthetic chemical fertilizers or pesticides. A complete plant protein.",
         "100% Certified Organic White Quinoa Seeds", "Store in an airtight container", "12 Months",
         {"Calories": "368 kcal", "Protein": "14.1g", "Carbohydrates": "64.2g", "Dietary Fiber": "7.0g", "Total Fat": "6.1g"},
         ["Certified 100% Organic", "Complete Plant Protein (9 EAAs)", "Pre-Washed Saponin-Free", "Low Glycemic Index"],
         "Simmer 1 cup quinoa with 2 cups water for 15 minutes; fluff and toss with diced cucumber and bell peppers.", True, True),
        ("Slurrp Farm Ragi & Jowar Choco Crunch Stars", "350 g Box", "Slurrp Farm", 190.0, 225.0, "Kids Cereal", "No Maida",
         "Wholesome millet stars made with ragi and jowar, sweetened with raw unrefined jaggery and zero refined sugar.",
         "Ragi (Finger Millet) 35%, Jowar (Sorghum) 30%, Cocoa, Jaggery", "Store in a cool dry place", "9 Months",
         {"Calories": "378 kcal", "Protein": "8.5g", "Carbohydrates": "76.0g", "Dietary Fiber": "6.8g", "Total Fat": "4.2g"},
         ["Zero Refined Sugar or Maida", "Made with 65% Native Millets", "Sweetened with Jaggery", "Calcium-Rich Ragi"],
         "Serve warm with milk and fresh strawberry slices for a nourishing breakfast.", False, True),
        ("Tata Soulfull Ragi Bites Super Saver Pack", "700 g Pack", "Tata Soulfull", 249.0, 310.0, "Ragi Bites", "20% OFF",
         "Crunchy chocolate-filled ragi pillows in a large family economy pack. High in calcium and fiber with the power of super millets.",
         "Ragi (50%), Rice, Choco Filling (Sugar, Cocoa), Minerals", "Keep sealed in an airtight jar", "9 Months",
         {"Calories": "415 kcal", "Protein": "6.5g", "Carbohydrates": "78.0g", "Dietary Fiber": "5.5g", "Total Fat": "9.0g"},
         ["700g Family Economy Pack", "50% Finger Millet (Ragi)", "Real Cocoa Cream", "No Artificial Preservatives"],
         "A great after-school energy bite for active kids.", False, True),
        ("Zerobeli Crunchy Choco Flakes Goodness of Jowar", "375 g Pouch", "Zerobeli", 135.0, 165.0, "Choco Flakes", "Millets",
         "Delicious cocoa-coated breakfast flakes crafted with jowar millet. Light, airy, and naturally nutrient-dense.",
         "Jowar Flour, Wheat Flour, Cocoa Powder, Sugar, Salt", "Store in dry place", "9 Months",
         {"Calories": "382 kcal", "Protein": "7.8g", "Carbohydrates": "80.5g", "Dietary Fiber": "5.2g", "Total Fat": "3.5g"},
         ["Infused with Ancient Jowar", "Crispy & Light", "Low Fat Formulation", "Zero Cholesterol"],
         "Sprinkle over Greek yogurt for an energizing midday crunch.", False, True),
        ("Kellogg's Froot Loops with Multigrain", "285 g Box", "Kellogg's", 175.0, 199.0, "Froot Loops", "Kids Favourite",
         "Iconic brightly colored fruity cereal rings with natural fruit flavors and multigrain goodness.",
         "Corn, Wheat, Barley Flours, Sugar, Natural Fruit Flavors & Colors", "Keep sealed in original bag", "12 Months",
         {"Calories": "388 kcal", "Protein": "5.5g", "Carbohydrates": "85.0g", "Dietary Fiber": "3.0g", "Total Fat": "2.8g"},
         ["Natural Fruit Extracts", "Multigrain Corn, Wheat & Barley", "Fun Colorful Breakfast", "Rich in Vitamin C"],
         "Use as a colorful crunchy topping for acai smoothie bowls or vanilla ice cream.", False, True),
        ("Kellogg's Chocos Fills Caramel Delight", "250 g Box", "Kellogg's", 155.0, 175.0, "Choco Fills", "New",
         "Crispy multigrain pockets with a decadent liquid caramel and cocoa center. Melts delightfully on the tongue.",
         "Multigrain Blend, Sugar, Vegetable Oil, Cocoa, Caramel Flavor", "Store in cool dry cupboard", "9 Months",
         {"Calories": "430 kcal", "Protein": "6.8g", "Carbohydrates": "74.0g", "Dietary Fiber": "3.8g", "Total Fat": "12.5g"},
         ["Molten Caramel Core", "Multigrain Crunch Outer Shell", "Decadent Flavor", "Zero Trans Fat"],
         "Warm slightly in the microwave for 10 seconds for an extra gooey caramel center.", False, True),
        ("Tata Soulfull Corn Flakes+ Millet Shakti", "400 g Pouch", "Tata Soulfull", 125.0, 150.0, "Corn Flakes", "Millet Power",
         "Traditional crispy corn flakes fortified with nutrient-dense pearl and finger millets. Extra crunchy texture.",
         "Corn Grits (75%), Millets (Ragi, Bajra 15%), Sugar, Salt", "Store in airtight container", "9 Months",
         {"Calories": "375 kcal", "Protein": "7.5g", "Carbohydrates": "83.0g", "Dietary Fiber": "4.8g", "Total Fat": "1.2g"},
         ["Millet Powered Corn Flakes", "Extra Long Lasting Crunch", "Zero Preservatives", "Naturally Low Fat"],
         "Layer with chopped mangoes, curd, and flax seeds for a healthy breakfast parfait.", False, True),
        ("Kwality Choco Fills Ziplock Pouch", "250 g Pouch", "Kwality", 115.0, 140.0, "Choco Fills", "18% OFF",
         "Convenient resealable ziplock pouch packed with chocolate-filled cereal crunchies. Locks in freshness after every bowl.",
         "Wheat Flour, Rice Flour, Cocoa Cream, Sugar", "Reseal ziplock tightly after opening", "9 Months",
         {"Calories": "418 kcal", "Protein": "7.0g", "Carbohydrates": "77.5g", "Dietary Fiber": "3.9g", "Total Fat": "9.2g"},
         ["Resealable Ziplock Pouch", "Rich Chocolate Cream", "Pest-Proof Packaging", "Crisp Every Time"],
         "Great to pack in children's school lunchboxes as a crunchy snack.", False, True),
        ("Kwality Corn Flakes Almond & Honey Mega Saver", "750 g Pack", "Kwality", 230.0, 285.0, "Corn Flakes", "Mega Saver",
         "Golden toasted corn flakes tossed with real sliced California almonds and natural wild blossom honey.",
         "Corn Grits, Sliced Almonds (10%), Pure Honey, Sugar, Salt", "Store in clean airtight jar", "12 Months",
         {"Calories": "392 kcal", "Protein": "8.2g", "Carbohydrates": "79.0g", "Dietary Fiber": "5.2g", "Total Fat": "4.8g"},
         ["Real Sliced California Almonds", "Glazed with Natural Honey", "750g Value Pack", "No Added Artificial Colors"],
         "Pour ice-cold milk over the flakes and enjoy immediately for maximum almond crunch.", False, True),
        ("Kwality Fruit Rings Colorful Cereal", "375 g Pouch", "Kwality", 140.0, 175.0, "Fruit Rings", "Popular",
         "Playful rainbow rings bursting with berry, apple, and citrus flavors. High in zinc and 8 essential vitamins.",
         "Corn Grits, Wheat Flour, Sugar, Fruit Flavors, Natural Colors", "Store in dry place", "9 Months",
         {"Calories": "385 kcal", "Protein": "6.0g", "Carbohydrates": "84.0g", "Dietary Fiber": "3.2g", "Total Fat": "2.5g"},
         ["Bright Rainbow Rings", "Fortified with Zinc & Iron", "Crunchy & Sweet", "Kids Favorite"],
         "String onto clean kitchen twine for fun, edible kids craft necklaces.", False, True),
        ("Zerobeli Strawberry Flavoured Corn Flakes", "375 g Box", "Zerobeli", 145.0, 180.0, "Strawberry Flakes", "Real Fruit",
         "Toasted corn flakes delicately infused with real strawberry fruit powder. Turns milk delicious strawberry pink.",
         "Corn Grits, Strawberry Powder (8%), Sugar, Salt", "Store away from heat & humidity", "9 Months",
         {"Calories": "380 kcal", "Protein": "6.5g", "Carbohydrates": "82.5g", "Dietary Fiber": "3.8g", "Total Fat": "2.0g"},
         ["Infused with Real Strawberry", "Naturally Pink Milk", "Low Fat Breakfast", "Delicate Fruity Aroma"],
         "Top with fresh blueberries and sliced almonds for a colorful morning bowl.", False, True),
        ("Bagrry's Choco+ Multigrain Crunch Super Saver", "750 g Pouch", "Bagrry's", 255.0, 320.0, "Choco Flakes", "Super Saver",
         "Wholesome multigrain crunchies coated in rich dark chocolate. Made with oats, whole wheat, and rice for sustained energy.",
         "Rolled Oats (35%), Whole Wheat (30%), Cocoa Solids, Sugar", "Store in cool dry conditions", "9 Months",
         {"Calories": "410 kcal", "Protein": "9.2g", "Carbohydrates": "74.5g", "Dietary Fiber": "7.5g", "Total Fat": "7.8g"},
         ["High Oat Fiber (Beta-Glucan)", "Real Dark Chocolate", "Sustained Morning Stamina", "Super Saver 750g"],
         "Serve with warm milk or stir into Greek yogurt for an antioxidant-rich breakfast.", False, True),
        ("Bagrry's Corn Flakes+ Added Fibre Low Fat", "800 g Pack", "Bagrry's", 215.0, 270.0, "Corn Flakes", "Added Fibre",
         "Golden corn flakes enhanced with natural wheat bran for extra dietary fiber and digestive lightness.",
         "Corn Grits (85%), Wheat Bran (10%), Sugar, Salt", "Store in airtight jar", "12 Months",
         {"Calories": "362 kcal", "Protein": "8.0g", "Carbohydrates": "79.0g", "Dietary Fiber": "8.5g", "Total Fat": "1.2g"},
         ["Added Natural Wheat Bran", "8.5g Dietary Fiber per 100g", "Zero Trans Fat", "Light on Stomach"],
         "Add diced apple slices and cinnamon powder for a guilt-free breakfast treat.", False, True),
        ("Bagrry's Corn Flakes+ Almond & Honey", "400 g Box", "Bagrry's", 165.0, 200.0, "Corn Flakes", "Almond Honey",
         "Crunchy oven-toasted corn flakes coated in pure honey and studded with real sliced almonds.",
         "Corn Grits, Honey (8%), Almonds (6%), Sugar, Salt", "Keep in sealed bag", "9 Months",
         {"Calories": "390 kcal", "Protein": "7.8g", "Carbohydrates": "80.0g", "Dietary Fiber": "4.5g", "Total Fat": "4.2g"},
         ["Sweetened with Pure Honey", "Real Crunchy Almond Slivers", "Oven Toasted", "Iron Enriched"],
         "Pair with chilled almond milk for a 100% nutty breakfast sensation.", False, True),
        ("Nestle Munch Crunchy Chocolate Breakfast Cereal", "350 g Pouch", "Nestle", 155.0, 185.0, "Crunchy Cereal", "Hot Deal",
         "The beloved taste of Nestle Munch now in an energizing breakfast cereal. Extra crispy wafers coated in chocolate.",
         "Rice Flour, Wheat Flour, Cocoa Powder, Sugar, Vegetable Oil", "Store in cool dry place", "9 Months",
         {"Calories": "425 kcal", "Protein": "7.0g", "Carbohydrates": "76.0g", "Dietary Fiber": "3.5g", "Total Fat": "10.5g"},
         ["Beloved Munch Wafer Crunch", "Rich Chocolate Coating", "Stays Crispy in Milk", "Party Snack Favorite"],
         "Toss with mini marshmallows and roasted almonds for instant kids trail mix.", False, True),
        ("Parle Hide & Seek Fills Chocolate Hazelnut", "250 g Pack", "Parle", 130.0, 150.0, "Choco Fills", "50% Choco",
         "Crispy chocolate multigrain pillows generously stuffed with velvety chocolate hazelnut cream.",
         "Wheat Flour, Cocoa Butter, Hazelnut Paste, Sugar", "Store in clean cupboard", "9 Months",
         {"Calories": "445 kcal", "Protein": "6.5g", "Carbohydrates": "72.0g", "Dietary Fiber": "3.2g", "Total Fat": "14.5g"},
         ["50% Melt-in-Mouth Choco Core", "Real Hazelnut Essence", "Decadent & Crispy", "Zero Cholesterol"],
         "Enjoy as an evening dessert topping over hot chocolate or vanilla custard.", False, True),
        ("Kellogg's Corn Flakes Almond & Honey Trial", "150 g Pouch", "Kellogg's", 65.0, 75.0, "Corn Flakes", "Trial Pack",
         "Convenient travel-sized pouch of golden corn flakes glazed with honey and packed with sliced almonds.",
         "Corn Grits, Sliced Almonds, Honey, Sugar, Salt", "Keep sealed in pouch", "9 Months",
         {"Calories": "390 kcal", "Protein": "7.8g", "Carbohydrates": "80.0g", "Dietary Fiber": "4.5g", "Total Fat": "4.2g"},
         ["Pocket-Friendly Trial Size", "Real Almonds & Honey", "Quick Hostel Breakfast", "Freshness Preserved"],
         "Perfect size for college dorms, weekend getaways, and office breakfast desks.", False, True),
        ("Kellogg's Corn Flakes Original Family Saver", "1.2 kg Box", "Kellogg's", 345.0, 410.0, "Corn Flakes", "Family Pack",
         "The world's original and best corn flakes in a massive 1.2kg value box. Sun-ripened corn toasted to golden perfection.",
         "Milled Corn (90%), Sugar, Barley Malt Extract, Salt", "Store in airtight jar once box is opened", "12 Months",
         {"Calories": "370 kcal", "Protein": "7.0g", "Carbohydrates": "84.0g", "Dietary Fiber": "2.8g", "Total Fat": "0.9g"},
         ["1.2 kg Jumbo Family Value Box", "World's #1 Breakfast Brand", "Enriched with 8 Essential Vitamins", "Naturally Low Fat"],
         "Crush and use as a crunchy coating for baked paneer fingers or chicken tenders.", False, True),
        ("Kellogg's Chocos Moons & Stars Multigrain", "375 g Pouch", "Kellogg's", 160.0, 190.0, "Chocos", "Iron Rich",
         "Fun celestial shapes packed with the goodness of wheat, oats, and jowar coated in chocolate.",
         "Whole Wheat Flour (40%), Rice Flour, Cocoa, Sugar, Minerals", "Store in dry place", "9 Months",
         {"Calories": "385 kcal", "Protein": "8.0g", "Carbohydrates": "79.0g", "Dietary Fiber": "4.5g", "Total Fat": "3.5g"},
         ["Fun Moons & Stars Shapes", "Whole Grain Wheat & Oats", "High in Iron & Calcium", "Zero Added Colors"],
         "Pour warm milk over the bowl and watch the milk transform into delicious hot cocoa.", False, True),
        ("Kellogg's Special K High Protein & Fibre", "435 g Box", "Kellogg's", 240.0, 285.0, "Weight Care", "Fit Fuel",
         "Wholesome crispy flakes crafted with wheat and rice, fortified with 8 essential vitamins, protein, and dietary fiber.",
         "Whole Wheat (60%), Rice, Protein Isolates, Sugar, Vitamins", "Keep bag tightly sealed", "12 Months",
         {"Calories": "358 kcal", "Protein": "15.0g", "Carbohydrates": "71.0g", "Dietary Fiber": "7.5g", "Total Fat": "1.5g"},
         ["15g Protein per 100g", "Low Fat Formulation", "Fortified with B-Vitamins", "Supports Active Fitness"],
         "Serve with skimmed milk and a handful of mixed walnuts and dried cranberries.", False, True)
    ]

    f_files = sorted(os.listdir(os.path.join(base_assets, 'flakes-kids-cereals')))
    f_list = []
    for i, fn in enumerate(f_files):
        t = cereal_sources[i % len(cereal_sources)]
        # When repeating, provide distinctive title additions based on realistic sub-variants
        variant_subtitles = ["Crunch Pack", "Breakfast Bowl", "Value Saver", "Pantry Reserve"]
        variant_idx = i // len(cereal_sources)
        title_suffix = f" ({variant_subtitles[variant_idx % len(variant_subtitles)]})" if variant_idx > 0 else ""
        f_list.append({
            'id': f'prod_cereal_{i+1:03d}',
            'name': f"{t[0]}{title_suffix}",
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Organic' in t[6] or 'Fibre' in t[6] or 'Millets' in t[6] else '0xFFBA1A1A',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Flakes & Kids Cereals',
            'sub': t[5],
            'categorySlug': 'flakes-kids-cereals',
            'folder': 'flakes-kids-cereals',
            'rating': round(4.6 + (i % 4) * 0.1, 1),
            'reviews': f"{480 + i * 38}",
            'image': f'assets/products/flakes-kids-cereals/{fn}',
            'description': t[7],
            'ingredients': t[8],
            'storage': t[9],
            'shelfLife': t[10],
            'nutrition': t[11],
            'keyBenefits': t[12],
            'chefTip': t[13],
            'isOrganic': t[14],
            'isVeg': t[15]
        })
    products_by_category['flakes-kids-cereals'] = f_list

    # 5. CURD & YOGURT (78 files)
    curd_sources = [
        ("Epigamia Turbo Greek Yogurt Alphonso Mango", "125 g Cup", "Epigamia", 65.0, 70.0, "High Protein Greek Yogurt", "15g Protein", 15.0, 115, "Alphonso Mango Puree, Greek Yogurt", True),
        ("Amul Masti Dahi Fresh Set Curd Tub", "400 g Tub", "Amul", 44.0, 45.0, "Set Curd", "Daily Essential", 4.0, 75, "Pasteurized Toned Milk, Active Starter Culture", False),
        ("Epigamia Strawberry Greek Yogurt Zero Added Sugar", "120 g Cup", "Epigamia", 55.0, 60.0, "Greek Yogurt", "Zero Sugar", 10.0, 95, "Cultured Milk, Real Strawberries, Stevia", True),
        ("Milky Mist Fruit Yogurt Real Strawberry", "100 g Cup", "Milky Mist", 35.0, 40.0, "Fruit Yogurt", "Real Fruit", 4.5, 90, "Pasteurized Milk, Real Strawberry Pulp", False),
        ("Epigamia Greek Yogurt Smoothie Wild Blueberry", "200 ml Bottle", "Epigamia", 75.0, 80.0, "Drinkable Yogurt", "Probiotic", 8.0, 130, "Cultured Milk, Wild Blueberry Puree", True),
        ("Mother Dairy Classic Dahi Fresh Tub", "400 g Cup", "Mother Dairy", 42.0, 45.0, "Classic Curd", "Fresh Daily", 3.8, 72, "Pasteurized Milk, Active Lactic Cultures", False),
        ("Amul Elaichi Shrikhand Traditional Tub", "500 g Tub", "Amul", 110.0, 120.0, "Shrikhand", "Traditional", 7.0, 260, "Chakka (Strained Curd), Sugar, Green Cardamom", False),
        ("Epigamia Wild Raspberry Greek Yogurt", "120 g Cup", "Epigamia", 55.0, 60.0, "Greek Yogurt", "Real Berries", 10.0, 98, "Cultured Milk, Raspberry Puree", True),
        ("Amul High Protein Natural Greek Yogurt", "100 g Cup", "Amul", 45.0, 50.0, "Greek Yogurt", "High Protein", 11.0, 85, "Skimmed Milk Solids, Active Probiotic Cultures", False),
        ("Epigamia Natural Pure Greek Yogurt", "120 g Cup", "Epigamia", 50.0, 55.0, "Greek Yogurt", "Pure Protein", 12.0, 90, "Pasteurized Double Toned Milk, Starter Culture", True),
        ("HealthPro Ghar Jaisa High Protein Dahi", "400 g Tub", "HealthPro", 60.0, 70.0, "Protein Dahi", "15% OFF", 8.0, 80, "Pasteurized Milk, Active Probiotics", False),
        ("Amul Masti Dahi Fresh Pouch", "400 g Pouch", "Amul", 35.0, 36.0, "Set Curd", "Daily Essential", 3.8, 70, "Pasteurized Toned Milk, Culture", False),
        ("Epigamia Crunch Cup Greek Yogurt with Granola", "110 g Cup", "Epigamia", 70.0, 75.0, "Crunch Cup", "Snack Cup", 10.5, 140, "Greek Yogurt, Honey Toasted Granola", True),
        ("Nestle a+ Dahi Rich & Creamy Curd", "400 g Cup", "Nestle", 50.0, 55.0, "Creamy Dahi", "Purity Assured", 4.2, 78, "Pasteurized Milk, Lactic Culture", False),
        ("Agapi Artisanal Greek Yogurt Blueberry", "100 g Cup", "Agapi", 60.0, 65.0, "Greek Yogurt", "Artisanal", 9.5, 92, "Fresh Cow Milk, Wild Blueberries", True),
        ("Agapi Artisanal Greek Yogurt Strawberry", "100 g Cup", "Agapi", 60.0, 65.0, "Greek Yogurt", "Real Fruit", 9.5, 92, "Fresh Cow Milk, Fresh Strawberries", True),
        ("Doodhvale Farms Natural Matka Dahi", "500 g Clay Pot", "Doodhvale Farms", 85.0, 100.0, "Matka Dahi", "Authentic Clay", 5.0, 88, "Farm Fresh Cow Milk, Ancient Culture", True),
        ("Amul Dahi Classic Family Pouch", "1 kg Pouch", "Amul", 78.0, 80.0, "Set Curd", "Family Pack", 3.8, 70, "Pasteurized Toned Milk", False),
        ("Epigamia Zero Added Sugar Greek Yogurt Natural", "120 g Cup", "Epigamia", 55.0, 60.0, "Greek Yogurt", "Zero Sugar", 12.0, 85, "Pasteurized Milk, Active Live Cultures", True),
        ("Fru Bon Premium Thick & Delicious Dahi", "400 g Tub", "Fru Bon", 45.0, 50.0, "Thick Dahi", "Fresh", 4.0, 75, "Standardized Milk, Starter", False),
        ("Mother Dairy Ultimate Extra Creamy Dahi", "400 g Tub", "Mother Dairy", 48.0, 52.0, "Creamy Dahi", "Ultimate", 4.8, 85, "Full Cream Milk, Active Culture", False),
        ("Fru Bon Fresh Dahi Pouch", "500 g Pouch", "Fru Bon", 36.0, 38.0, "Set Curd", "Good Value", 3.8, 70, "Toned Milk, Active Culture", False),
        ("Pride of Cows Artisanal Single Origin Curd", "400 g Glass Jar", "Pride of Cows", 130.0, 150.0, "Artisanal Curd", "Single Origin", 5.5, 95, "Single Origin Cow Milk, Traditional Culture", True),
        ("Epigamia Turbo Greek Yogurt Wild Blueberry", "125 g Cup", "Epigamia", 65.0, 70.0, "High Protein Greek Yogurt", "15g Protein", 15.0, 115, "Greek Yogurt, Blueberry Puree", True),
        ("Epigamia Crunch Cup Mango with Honey Granola", "110 g Cup", "Epigamia", 70.0, 75.0, "Crunch Cup", "Delight", 10.5, 140, "Greek Yogurt, Alphonso Mango, Granola", True),
        ("Milky Mist Greek Yogurt Natural Unsweetened", "100 g Cup", "Milky Mist", 40.0, 45.0, "Greek Yogurt", "Unsweetened", 10.0, 88, "Pasteurized Milk Solids, Starter", False)
    ]

    curd_files = sorted(os.listdir(os.path.join(base_assets, 'curd-yogurt')))
    curd_list = []
    for i, fn in enumerate(curd_files):
        t = curd_sources[i % len(curd_sources)]
        cycle = i // len(curd_sources)
        name_prefixes = ["", "Reserve ", "Select "]
        prefix = name_prefixes[cycle % len(name_prefixes)]
        final_name = f"{prefix}{t[0]}" if prefix else t[0]
        curd_list.append({
            'id': f'prod_curd_{i+1:03d}',
            'name': final_name,
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if 'Protein' in t[6] or 'Daily' in t[6] or 'Organic' in t[6] else '0xFF00569E',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Curd & Greek Yogurt',
            'sub': t[5],
            'categorySlug': 'curd-yogurt',
            'folder': 'curd-yogurt',
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{720 + i * 42}",
            'image': f'assets/products/curd-yogurt/{fn}',
            'description': f"Artisanal fresh {t[5].lower()} made with 100% pasteurized farm milk and live active probiotic cultures. Incredibly thick, velvety, and naturally gut-friendly.",
            'ingredients': t[9],
            'storage': "Store refrigerated between 1°C - 4°C. Do not freeze",
            'shelfLife': "14-21 Days from manufacture",
            'nutrition': {
                "Calories": f"{t[8]} kcal",
                "Protein": f"{t[7]}g",
                "Carbohydrates": "5.5g",
                "Fat": "3.5g",
                "Calcium": "130mg"
            },
            'keyBenefits': ["Billions of Live Probiotics", "High Natural Dairy Protein", "Smooth & Thick Texture", "No Artificial Gelatin or Starches"],
            'chefTip': "Blend with chilled berries and a spoon of honey for an energizing breakfast smoothie bowl, or use as a rich base for raita.",
            'isOrganic': t[10],
            'isVeg': True
        })
    products_by_category['curd-yogurt'] = curd_list

    # 6. FRESH VEGETABLES (154 files)
    # 50+ unique vegetable types mapped cleanly across all 154 files without ugly 'Batch' or 'Family Pack' repetitions
    veg_pool = [
        ("Fresh Country Tomatoes (Tamatar)", "500 g", "Farm Fresh", 24.0, 35.0, "Fresh Vegetables", "Seasonal", "31% OFF", False),
        ("Fresh Red Onions (Pyaaz)", "1 kg", "Farm Fresh", 35.0, 50.0, "Fresh Vegetables", "Seasonal", "30% OFF", False),
        ("Premium Jyoti Potatoes (Aloo)", "1 kg", "Farm Fresh", 28.0, 40.0, "Fresh Vegetables", "Seasonal", "Hot Deal", False),
        ("Farm Fresh Palak (Spinach Leaves)", "250 g", "Farm Fresh", 20.0, 30.0, "Leafy Greens", "Organic", "Organic", True),
        ("Fresh Green Chillies (Hari Mirch)", "100 g", "Farm Fresh", 14.0, 20.0, "Fresh Vegetables", "Seasonal", "Spicy", False),
        ("Juicy Yellow Lemons (Nimbu)", "4 pcs", "Farm Fresh", 18.0, 25.0, "Fresh Vegetables", "Seasonal", "Vitamin C", False),
        ("Tender Peeled Baby Corn", "200 g", "Farm Fresh", 45.0, 60.0, "Exotics & Salads", "Seasonal", "Farm Direct", False),
        ("Sweet American Corn Cob (Bhutta)", "2 pcs", "Farm Fresh", 38.0, 50.0, "Fresh Vegetables", "Seasonal", "Sweet & Crisp", False),
        ("Fresh Green Peas (Matar) in Pods", "500 g", "Farm Fresh", 48.0, 65.0, "Fresh Vegetables", "Seasonal", "Fresh Harvest", False),
        ("Cherry Tomatoes (Red & Orange)", "250 g", "Farm Fresh", 60.0, 80.0, "Exotics & Salads", "Organic", "Salad Special", True),
        ("Sambar Shallots (Chotta Pyaaz)", "500 g", "Farm Fresh", 42.0, 55.0, "Fresh Vegetables", "Seasonal", "South Special", False),
        ("Tri-Color Bell Peppers (Capsicum)", "3 pcs (Red, Yellow, Green)", "Hydroponic Direct", 115.0, 145.0, "Exotics & Salads", "Organic", "Hydroponic", True),
        ("Crisp Spring Onions with Greens", "1 bunch (200g)", "Farm Fresh", 22.0, 30.0, "Fresh Vegetables", "Seasonal", "Fresh Cut", False),
        ("Juicy Fresh Kagzi Lemons", "6 pcs", "Farm Fresh", 25.0, 35.0, "Fresh Vegetables", "Seasonal", "Tangy Citrus", False),
        ("Sprouted Kala Chana (Brown Chickpeas)", "200 g", "Daily Basket Select", 35.0, 45.0, "Organic Produce", "Organic", "Protein Rich", True),
        ("Tender Raw Jackfruit Chunks (Kathal)", "300 g Cut", "Farm Fresh", 55.0, 70.0, "Fresh Vegetables", "Seasonal", "Curry Special", False),
        ("Raw Green Papaya (Kaccha Papita)", "1 pc (500g)", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables", "Seasonal", "Digestive", False),
        ("Fresh Fragrant Mint Leaves (Pudina)", "1 bunch (100g)", "Farm Fresh", 12.0, 18.0, "Leafy Greens", "Seasonal", "Aromatic", False),
        ("Seasonal Fresh Harvest Vegetable Basket", "1 Pack (2.5kg)", "Daily Basket Select", 180.0, 220.0, "Fresh Vegetables", "Seasonal", "Delight", True),
        ("Vine Ripe Hybrid Tomatoes", "1 kg", "Farm Fresh", 44.0, 60.0, "Fresh Vegetables", "Seasonal", "Farm Fresh", False),
        ("Fresh Tinda (Apple Gourd)", "500 g", "Farm Fresh", 34.0, 45.0, "Fresh Vegetables", "Seasonal", "Tender", False),
        ("Organic Baby Spinach Leaves", "200 g", "Farm Fresh", 28.0, 40.0, "Leafy Greens", "Organic", "Pesticide Free", True),
        ("Fresh Mustard Greens (Sarson Ka Saag)", "500 g", "Farm Fresh", 30.0, 42.0, "Leafy Greens", "Seasonal", "Winter Special", False),
        ("Fresh Sliced Lemon Quarters", "200 g Pack", "Farm Fresh", 22.0, 30.0, "Fresh Vegetables", "Seasonal", "Fresh Cut", False),
        ("Sweet Juicy Mosambi (Sweet Lime)", "1 kg (4-5 pcs)", "Farm Fresh", 75.0, 95.0, "Fresh Fruits", "Seasonal", "Juicy", False),
        ("Fresh Green Tindora (Kundru)", "500 g", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables", "Seasonal", "Daily Fresh", False),
        ("Crisp Orange Carrots (Gajar)", "500 g", "Farm Fresh", 28.0, 38.0, "Root Vegetables", "Seasonal", "Vitamin A", False),
        ("Raw Fresh Turmeric (Kacchi Haldi)", "250 g", "Organic Mandi", 35.0, 50.0, "Organic Produce", "Organic", "Immunity", True),
        ("Fresh Green Broccoli Florets", "1 pc (350g)", "Daily Basket Select", 58.0, 75.0, "Exotics & Salads", "Organic", "Superfood", True),
        ("Crisp Romaine Lettuce", "1 pc (250g)", "Hydroponic Direct", 45.0, 60.0, "Leafy Greens", "Organic", "Hydroponic", True),
        ("Fresh Green Capsicum (Shimla Mirch)", "500 g", "Farm Fresh", 36.0, 48.0, "Fresh Vegetables", "Seasonal", "Crisp", False),
        ("Fresh Cauliflower (Phool Gobhi)", "1 pc (500g)", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables", "Seasonal", "Tender", False),
        ("Green Cabbage (Patta Gobhi)", "1 pc (600g)", "Farm Fresh", 24.0, 35.0, "Fresh Vegetables", "Seasonal", "Crunchy", False),
        ("Fresh Lady Finger (Bhindi / Okra)", "500 g", "Farm Fresh", 34.0, 48.0, "Fresh Vegetables", "Seasonal", "Tender Pods", False),
        ("Tender Bottle Gourd (Lauki / Dudhi)", "1 pc (800g)", "Farm Fresh", 28.0, 40.0, "Fresh Vegetables", "Seasonal", "Cooling", False),
        ("Fresh Ridge Gourd (Turai)", "500 g", "Farm Fresh", 36.0, 50.0, "Fresh Vegetables", "Seasonal", "Easy Digest", False),
        ("Tender Bitter Gourd (Karela)", "500 g", "Farm Fresh", 38.0, 52.0, "Fresh Vegetables", "Seasonal", "Diabetic Care", False),
        ("Fresh French Beans", "250 g", "Farm Fresh", 30.0, 42.0, "Fresh Vegetables", "Seasonal", "Tender Crisp", False),
        ("Fresh Cluster Beans (Gawar Phali)", "250 g", "Farm Fresh", 28.0, 38.0, "Fresh Vegetables", "Seasonal", "High Fiber", False),
        ("Fresh Ginger (Desi Adrak)", "200 g", "Farm Fresh", 35.0, 48.0, "Root Vegetables", "Seasonal", "Digestive", False),
        ("Fresh Garlic Pearls (Desi Lahsun)", "200 g", "Farm Fresh", 45.0, 60.0, "Root Vegetables", "Seasonal", "Aromatic", False),
        ("Peeled Garlic Cloves", "100 g", "Daily Basket Select", 38.0, 50.0, "Fresh Cut", "Seasonal", "100% Peeled", False),
        ("Fresh Coriander Leaves (Kothmir)", "1 bunch (100g)", "Farm Fresh", 10.0, 15.0, "Leafy Greens", "Seasonal", "Garnish Fresh", False),
        ("Fresh Curry Leaves (Kadi Patta)", "1 bunch (50g)", "Farm Fresh", 8.0, 12.0, "Leafy Greens", "Seasonal", "Aromatic", False),
        ("Fresh Fenugreek Leaves (Methi)", "1 bunch (250g)", "Farm Fresh", 18.0, 25.0, "Leafy Greens", "Seasonal", "Iron Rich", False),
        ("Fresh Beetroot (Chukandar)", "500 g", "Farm Fresh", 28.0, 38.0, "Root Vegetables", "Seasonal", "Blood Purifier", False),
        ("English Long Cucumber (Kheera)", "500 g", "Farm Fresh", 25.0, 35.0, "Exotics & Salads", "Seasonal", "Hydrating", False),
        ("Desi Small Kheera (Field Cucumber)", "500 g", "Farm Fresh", 22.0, 30.0, "Fresh Vegetables", "Seasonal", "Cooling", False),
        ("Purple Round Brinjal (Baingan Bharta)", "500 g (2 pcs)", "Farm Fresh", 32.0, 45.0, "Fresh Vegetables", "Seasonal", "Bharta Special", False),
        ("Small Purple Baby Brinjal (Gutthi Vankaya)", "250 g", "Farm Fresh", 22.0, 30.0, "Fresh Vegetables", "Seasonal", "Stuffed Special", False),
        ("Green Long Snake Gourd (Chichinda)", "1 pc (500g)", "Farm Fresh", 30.0, 40.0, "Fresh Vegetables", "Seasonal", "Hydrating", False),
        ("White Radish with Greens (Mooli)", "500 g", "Farm Fresh", 24.0, 32.0, "Root Vegetables", "Seasonal", "Crunchy", False)
    ]

    veg_files = sorted(os.listdir(os.path.join(base_assets, 'fresh-vegetables')))
    veg_list = []
    for i, fn in enumerate(veg_files):
        t = veg_pool[i % len(veg_pool)]
        round_idx = i // len(veg_pool)
        tier_names = ["", "Hydroponic ", "Farm Select "]
        t_name = f"{tier_names[round_idx % len(tier_names)]}{t[0]}" if round_idx > 0 else t[0]
        veg_list.append({
            'id': f'prod_veg_{i+1:03d}',
            'name': t_name,
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[7],
            'badgeColor': '0xFF006B23' if t[8] or 'Organic' in t[7] else '0xFFBA1A1A',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Fresh Vegetables',
            'sub': t[5],
            'categorySlug': 'fresh-vegetables',
            'folder': 'fresh-vegetables',
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{850 + i * 48}",
            'image': f'assets/products/fresh-vegetables/{fn}',
            'description': f"Direct from verified organic & local farms. Harvested early morning, sorted through ozone-wash hygiene grading, and delivered crisp in 10 minutes.",
            'ingredients': f"100% Fresh {t[0].split('(')[0].strip()}",
            'storage': "Refrigerate in a perforated vegetable bag or crisp drawer",
            'shelfLife': "3-5 Days from harvest",
            'nutrition': {
                "Calories": f"{20 + (i % 15)} kcal",
                "Carbohydrates": f"{4.0 + (i % 5)*0.5}g",
                "Dietary Fiber": "2.8g",
                "Protein": "1.4g",
                "Vitamin C": "22mg"
            },
            'keyBenefits': ["Harvested Today Morning", "Triple Washed & Ozone Sanitized", "Zero Chemical Preservatives", "Maximum Freshness Guarantee"],
            'chefTip': "Chop and sauté with mild cumin, mustard seeds, and freshly grated coconut for an authentic South Indian poriyal or dry sabzi.",
            'isOrganic': t[8],
            'isVeg': True
        })
    products_by_category['fresh-vegetables'] = veg_list

    # 7. BREAD, PAV & BAKERY (248 files)
    # We expand the bakery catalogue into diverse real bakery items
    bread_pool = [
        ("The Health Factory Zero Maida Footlong Bread", "300 g Loaf", "The Health Factory", 65.0, 75.0, "Sandwich Bread", "Zero Maida", False),
        ("Paushtaa Organic Healthy Multigrain Cookies", "200 g Canister", "Paushtaa", 185.0, 220.0, "Cookies & Biscuits", "Organic", True),
        ("The Cinnamon Kitchen Sugar-Free Cacao & Berry Rocks", "150 g Box", "The Cinnamon Kitchen", 295.0, 350.0, "Cakes & Brownies", "Artisanal", True),
        ("Harvest Gold Pizza Base (Thin Crust)", "200 g (2 pcs)", "Harvest Gold", 40.0, 45.0, "Pizza Base", "Italian Crust", False),
        ("Suchali's Buttercrust Milk Bread", "400 g Loaf", "Suchali's", 75.0, 85.0, "Sandwich Bread", "Artisanal", False),
        ("Farm Fresh Brown Eggs Tray", "6 pcs Tray", "Daily Basket Select", 65.0, 75.0, "Farm Eggs", "Country Fresh", False),
        ("Britannia 100% Whole Wheat Bread", "400 g Pack", "Britannia", 50.0, 55.0, "Sandwich Bread", "100% Atta", False),
        ("Double Choco Chip Cookies Gourmet Jar", "250 g Jar", "Cake Tale", 145.0, 175.0, "Cookies & Biscuits", "Choco Rich", False),
        ("The Baker's Dozen Sourdough Grissini Breadsticks", "150 g Pack", "The Baker's Dozen", 110.0, 130.0, "Artisanal Sourdough", "Sourdough", False),
        ("Suchali's Artisanal Sourdough Multigrain Bread", "500 g Loaf", "Suchali's", 140.0, 165.0, "Artisanal Sourdough", "Stone Ground", True),
        ("The Health Factory Multi Protein Footlong Bread", "300 g Loaf", "The Health Factory", 75.0, 85.0, "Sandwich Bread", "High Protein", False),
        ("Gourmet Belgian Chocolate Walnut Brownie", "150 g Slice", "Cake Tale", 95.0, 120.0, "Cakes & Brownies", "Fresh Baked", False),
        ("Cake Tale Fruit & Nutty Breakfast Muffins", "180 g (3 pcs)", "Cake Tale", 115.0, 135.0, "Cakes & Brownies", "Berry Delight", False),
        ("Fresh Baked Chunky Chocolate Chip Cookie", "1 pc (75g)", "Cake Tale", 45.0, 55.0, "Cookies & Biscuits", "Oven Fresh", False),
        ("Harvest Gold Sandwich White Bread", "450 g Pack", "Harvest Gold", 42.0, 48.0, "Sandwich Bread", "Daily Essential", False),
        ("English Oven Garlic & Oregano Bread", "350 g Loaf", "English Oven", 60.0, 70.0, "Flavored Bread", "Herbed", False),
        ("Harvest Gold Premium White Bread", "400 g Pack", "Harvest Gold", 40.0, 45.0, "Sandwich Bread", "Soft & Fresh", False),
        ("Crispy Italian Rosemary Bread Sticks", "150 g Box", "English Oven", 75.0, 90.0, "Cookies & Biscuits", "Crisp", False),
        ("English Oven Gourmet Olive Sub Rolls", "250 g (2 pcs)", "English Oven", 55.0, 65.0, "Buns & Pav", "Olive Herb", False),
        ("iD Fresh Protein-Rich Whole Wheat Chapati", "350 g (10 pcs)", "iD Fresh", 80.0, 90.0, "Flatbreads", "11g Protein", False),
        ("English Oven Amritsari Atta Kulcha", "250 g (5 pcs)", "English Oven", 50.0, 58.0, "Flatbreads", "Soft Tawa", False),
        ("The Health Factory Zero Zero Maida Bread", "400 g Loaf", "The Health Factory", 70.0, 80.0, "Sandwich Bread", "0% Maida", False),
        ("iD Fresh Mini Malabar Parota", "360 g (8 pcs)", "iD Fresh", 95.0, 110.0, "Flatbreads", "Crisp Layered", False),
        ("Chewy Oatmeal Cinnamon Raisin Cookie", "1 pc (75g)", "Cake Tale", 45.0, 55.0, "Cookies & Biscuits", "Whole Grain", False),
        ("Gourmet Stacked Fudge Walnut Brownies", "250 g Box", "Cake Tale", 160.0, 190.0, "Cakes & Brownies", "Indulgence", False),
        ("English Oven 100% Whole Wheat Brown Bread", "400 g Pack", "English Oven", 50.0, 55.0, "Sandwich Bread", "High Fibre", False),
        ("Britannia Daily Fresh Sandwich Bread", "400 g Pack", "Britannia", 40.0, 45.0, "Sandwich Bread", "Daily Essential", False),
        ("Fresh Soft Ladi Pav Pack", "250 g (6 pcs)", "Local Bakery", 25.0, 30.0, "Buns & Pav", "Oven Fresh", False),
        ("English Oven Jumbo Burger Buns", "200 g (2 pcs)", "English Oven", 38.0, 45.0, "Buns & Pav", "Sesame Seed", False),
        ("English Oven Hot Dog Rolls", "200 g (2 pcs)", "English Oven", 38.0, 45.0, "Buns & Pav", "Soft", False),
        ("The Baker's Dozen Country Sourdough Loaf", "450 g Loaf", "The Baker's Dozen", 125.0, 150.0, "Artisanal Sourdough", "Natural Yeast", True),
        ("Britannia Premium Bake Rusk (Real Elaichi)", "300 g Pack", "Britannia", 55.0, 65.0, "Cookies & Biscuits", "Tea Time", False),
        ("Farm Fresh White Eggs", "12 pcs Tray", "Daily Basket Select", 90.0, 110.0, "Farm Eggs", "Protein Rich", False),
        ("Farm Fresh Brown Eggs - Value Pack", "30 pcs Tray", "Daily Basket Select", 295.0, 350.0, "Farm Eggs", "Value Tray", False),
        ("English Oven Multigrain Bread with 7 Seeds", "400 g Loaf", "English Oven", 65.0, 75.0, "Sandwich Bread", "7 Seeds", True),
        ("The Baker's Dozen Whole Wheat Pita Bread", "200 g (4 pcs)", "The Baker's Dozen", 80.0, 95.0, "Flatbreads", "Stone Baked", False),
        ("English Oven Brioche Burger Buns", "200 g (2 pcs)", "English Oven", 50.0, 60.0, "Buns & Pav", "Buttery Soft", False),
        ("Suchali's Traditional French Baguette", "250 g Loaf", "Suchali's", 95.0, 115.0, "Artisanal Sourdough", "French Crust", False),
        ("Cake Tale Red Velvet Cream Cheese Cupcake", "1 pc (85g)", "Cake Tale", 65.0, 80.0, "Cakes & Brownies", "Velvety", False),
        ("The Health Factory Focaccia Herb Bread", "250 g Loaf", "The Health Factory", 85.0, 100.0, "Flavored Bread", "Rosemary & Olive", False),
        ("Suchali's Pain Au Chocolat (Chocolate Croissant)", "1 pc (90g)", "Suchali's", 95.0, 120.0, "Cakes & Brownies", "Flaky Butter", False),
        ("Britannia Little Hearts Sugar Glazed Biscuits", "75 g Pack", "Britannia", 25.0, 30.0, "Cookies & Biscuits", "Crunchy Sweet", False),
        ("English Oven Sweet Fruit Bun Pack", "150 g (2 pcs)", "English Oven", 30.0, 35.0, "Buns & Pav", "Tutti Frutti", False),
        ("The Baker's Dozen Banana Walnut Bread", "250 g Loaf", "The Baker's Dozen", 145.0, 175.0, "Cakes & Brownies", "Tea Cake", False),
        ("Harvest Gold Multigrain Brown Bread", "400 g Pack", "Harvest Gold", 55.0, 62.0, "Sandwich Bread", "Multigrain", False),
        ("Suchali's Artisanal Multiseed Bagel", "150 g (2 pcs)", "Suchali's", 90.0, 110.0, "Buns & Pav", "Chewy Crust", False)
    ]

    bread_files = sorted(os.listdir(os.path.join(base_assets, 'bread-pav')))
    bread_list = []
    for i, fn in enumerate(bread_files):
        t = bread_pool[i % len(bread_pool)]
        round_idx = i // len(bread_pool)
        prefix = ""
        if round_idx == 1:
            prefix = "Artisan "
        elif round_idx == 2:
            prefix = "Baker's Special "
        elif round_idx == 3:
            prefix = "Homestyle "
        elif round_idx == 4:
            prefix = "Gourmet "
        elif round_idx >= 5:
            prefix = "Daily Fresh "
        
        b_name = f"{prefix}{t[0]}" if prefix and not t[0].startswith(prefix) else t[0]
        is_egg = "Egg" in t[0]

        bread_list.append({
            'id': f'prod_bread_{i+1:03d}',
            'name': b_name,
            'subtitle': t[1],
            'brand': t[2],
            'unit': t[1],
            'price': float(t[3]),
            'mrp': float(t[4]),
            'badge': t[6],
            'badgeColor': '0xFF006B23' if t[7] or 'Zero' in t[6] or '100%' in t[6] or 'Artisanal' in t[6] else '0xFFBA1A1A',
            'badgeTextColor': '0xFFFFFFFF',
            'inStock': True,
            'category': 'Bread, Pav & Bakery',
            'sub': t[5],
            'categorySlug': 'bread-pav',
            'folder': 'bread-pav',
            'rating': round(4.7 + (i % 3) * 0.1, 1),
            'reviews': f"{620 + i * 36}",
            'image': f'assets/products/bread-pav/{fn}',
            'description': f"Freshly baked early morning by {t[2]}. Zero trans-fat, crafted with premium grains, and delivered warm and fragrant within 10 minutes.",
            'ingredients': "Whole Wheat Flour / Refined Flour, Water, Yeast, Butter/Oil, Sugar, Salt" if not is_egg else "100% Farm Fresh Eggs from Free-Range Hen Farms",
            'storage': "Store in a cool dry bread box; keep refrigerated in humid weather" if not is_egg else "Refrigerate at 4°C",
            'shelfLife': "3-4 Days (Oven Fresh)" if not is_egg else "21 Days",
            'nutrition': {
                "Calories": "248 kcal" if not is_egg else "72 kcal per egg",
                "Protein": "8.5g" if not is_egg else "6.3g per egg",
                "Carbohydrates": "49.0g" if not is_egg else "0.4g",
                "Total Fat": "2.1g" if not is_egg else "4.8g",
                "Dietary Fiber": "4.2g" if not is_egg else "0.0g"
            },
            'keyBenefits': ["Baked Fresh Today Morning", "Zero Trans Fat", "Soft & Fluffy Texture", "10-Minute Doorstep Delivery"],
            'chefTip': "Toast with salted butter until golden brown, or use to build crisp vegetable club sandwiches.",
            'isOrganic': t[7],
            'isVeg': not is_egg
        })
    products_by_category['bread-pav'] = bread_list

    # High-level aggregate views
    all_607 = veg_list + bread_list + curd_list + m_list + f_list + p_list + v_list
    high_level = {
        'all': all_607,
        'all-products': all_607,
        'fresh-fruits-vegetables': veg_list,
        'dairy-bread-eggs': m_list + curd_list + bread_list,
        'snacks-packaged-foods': f_list,
        'grocery': p_list + v_list,
    }

    complete = {**products_by_category, **high_level}
    total_distinct = len(v_list) + len(p_list) + len(m_list) + len(f_list) + len(curd_list) + len(veg_list) + len(bread_list)
    print(f"Generated complete enriched catalog: {total_distinct} items.")
    return complete

if __name__ == '__main__':
    catalog = build_enriched_catalog()

    # 1. Output packages/shared-types/src/products_catalog.json
    p1 = 'packages/shared-types/src/products_catalog.json'
    with open(p1, 'w', encoding='utf-8') as f:
        json.dump(catalog, f, indent=2)
    print(f"Wrote {p1} ({os.path.getsize(p1)} bytes)")

    # 2. Output services/api/prisma/products_catalog.json
    p2 = 'services/api/prisma/products_catalog.json'
    with open(p2, 'w', encoding='utf-8') as f:
        json.dump(catalog, f, indent=2)
    print(f"Wrote {p2} ({os.path.getsize(p2)} bytes)")

    # 3. Output apps/mobile/lib/core/data/products_catalog_data.dart
    dart_lines = [
        "// Generated complete enriched product catalog mapping all 607 asset images across 7 categories",
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
                    escaped = v.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$")
                    dart_lines.append(f"      '{k}': '{escaped}',")
                elif isinstance(v, bool):
                    bool_val = 'true' if v else 'false'
                    dart_lines.append(f"      '{k}': {bool_val},")
                elif isinstance(v, (int, float)):
                    dart_lines.append(f"      '{k}': {v},")
                elif isinstance(v, dict):
                    dart_lines.append(f"      '{k}': {json.dumps(v)},")
                elif isinstance(v, list):
                    dart_lines.append(f"      '{k}': {json.dumps(v)},")
            dart_lines.append("    },")
        dart_lines.append("  ],")
    dart_lines.append("};")
    dart_lines.append("")

    dart_content = "\n".join(dart_lines)
    p3 = 'apps/mobile/lib/core/data/products_catalog_data.dart'
    with open(p3, 'w', encoding='utf-8') as f:
        f.write(dart_content)
    print(f"Wrote {p3} ({len(dart_content)} bytes)")
