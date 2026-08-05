import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/recently_viewed_provider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../categories/presentation/screens/browse_categories_screen.dart';
import '../../../search/presentation/screens/search_results_screen.dart';
import '../../../search/presentation/widgets/voice_search_dialog.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/order_history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../core/navigation/app_navigation_drawer.dart';
import '../../../catalog/presentation/screens/product_listing_screen.dart';
import '../widgets/quick_services_section.dart';
import '../widgets/recently_viewed_section.dart';
import '../widgets/buy_again_section.dart';

class _Product {
  final String id, name, brand, unit, price, mrp, imageUrl, category;
  final double rating;
  final int reviews;
  const _Product({required this.id, required this.name, required this.brand, required this.unit, required this.price, required this.mrp, required this.rating, required this.reviews, required this.imageUrl, required this.category});
}

const _catalog = <_Product>[
  _Product(id:'mlk1',name:'Full Cream Milk',brand:'Amul',unit:'1 L Pouch',price:r'₹64',mrp:r'₹68',rating:4.7,reviews:8420,imageUrl:'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',category:'Dairy'),
  _Product(id:'mlk2',name:'Toned Milk',brand:'Mother Dairy',unit:'500 ml Pouch',price:r'₹30',mrp:r'₹32',rating:4.6,reviews:6210,imageUrl:'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',category:'Dairy'),
  _Product(id:'mlk3',name:'Double Toned Milk',brand:'Nandini',unit:'1 L Pouch',price:r'₹54',mrp:r'₹58',rating:4.5,reviews:3120,imageUrl:'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',category:'Dairy'),
  _Product(id:'mlk4',name:'Organic Cow Milk',brand:'Akshayakalpa',unit:'500 ml',price:r'₹46',mrp:r'₹50',rating:4.8,reviews:2890,imageUrl:'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',category:'Dairy'),
  _Product(id:'crd1',name:'Set Curd',brand:'Amul',unit:'400 g Cup',price:r'₹42',mrp:r'₹45',rating:4.6,reviews:5340,imageUrl:'https://images.unsplash.com/photo-1571512599285-9b05c2b06e99?w=400',category:'Dairy'),
  _Product(id:'crd2',name:'Mishti Doi',brand:'Mother Dairy',unit:'100 g Cup',price:r'₹20',mrp:r'₹22',rating:4.5,reviews:2100,imageUrl:'https://images.unsplash.com/photo-1571512599285-9b05c2b06e99?w=400',category:'Dairy'),
  _Product(id:'lsi1',name:'Sweet Lassi',brand:'Amul',unit:'200 ml Bottle',price:r'₹25',mrp:r'₹28',rating:4.7,reviews:4120,imageUrl:'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400',category:'Dairy'),
  _Product(id:'lsi2',name:'Mango Lassi',brand:'Havmor',unit:'200 ml Bottle',price:r'₹28',mrp:r'₹30',rating:4.6,reviews:3200,imageUrl:'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400',category:'Dairy'),
  _Product(id:'tea1',name:'Dust Tea',brand:'Red Label',unit:'500 g Pack',price:r'₹198',mrp:r'₹210',rating:4.8,reviews:12400,imageUrl:'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400',category:'Beverages'),
  _Product(id:'tea2',name:'Natural Care Tea',brand:'Taj Mahal',unit:'250 g Pack',price:r'₹138',mrp:r'₹150',rating:4.7,reviews:9800,imageUrl:'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400',category:'Beverages'),
  _Product(id:'tea3',name:'Masala Tea Powder',brand:'Wagh Bakri',unit:'250 g Pack',price:r'₹115',mrp:r'₹125',rating:4.6,reviews:7300,imageUrl:'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400',category:'Beverages'),
  _Product(id:'tea4',name:'Green Tea Bags',brand:'Tata Gold',unit:'100 g Pack',price:r'₹89',mrp:r'₹99',rating:4.5,reviews:5210,imageUrl:'https://images.unsplash.com/photo-1564890369478-c89ca3d9cde4?w=400',category:'Beverages'),
  _Product(id:'tea5',name:'Assam Premium Tea',brand:'Society Tea',unit:'250 g Pack',price:r'₹130',mrp:r'₹145',rating:4.6,reviews:4890,imageUrl:'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400',category:'Beverages'),
  _Product(id:'chc1',name:'Dairy Milk Silk',brand:'Cadbury',unit:'150 g Bar',price:r'₹155',mrp:r'₹170',rating:4.8,reviews:15600,imageUrl:'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400',category:'Confectionery'),
  _Product(id:'chc2',name:'KitKat 4 Finger',brand:'Nestle',unit:'41.5 g Bar',price:r'₹30',mrp:r'₹35',rating:4.7,reviews:11200,imageUrl:'https://images.unsplash.com/photo-1526081347589-7fa3cb41d55b?w=400',category:'Confectionery'),
  _Product(id:'chc3',name:'5 Star Bar',brand:'Cadbury',unit:'42 g Bar',price:r'₹30',mrp:r'₹35',rating:4.6,reviews:9300,imageUrl:'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400',category:'Confectionery'),
  _Product(id:'chc4',name:'Dark Temptation',brand:'Cadbury',unit:'72 g Bar',price:r'₹55',mrp:r'₹60',rating:4.7,reviews:7100,imageUrl:'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400',category:'Confectionery'),
  _Product(id:'chc5',name:'Munch Bar',brand:'Nestle',unit:'10g x 12',price:r'₹80',mrp:r'₹90',rating:4.5,reviews:8900,imageUrl:'https://images.unsplash.com/photo-1526081347589-7fa3cb41d55b?w=400',category:'Confectionery'),
  _Product(id:'shp1',name:'Anti-Dandruff Shampoo',brand:'Head Shoulders',unit:'340 ml',price:r'₹265',mrp:r'₹295',rating:4.5,reviews:18900,imageUrl:'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',category:'Personal Care'),
  _Product(id:'shp2',name:'Damage Repair Shampoo',brand:'Dove',unit:'340 ml',price:r'₹272',mrp:r'₹295',rating:4.6,reviews:14300,imageUrl:'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',category:'Personal Care'),
  _Product(id:'shp3',name:'Kesh Kanti Shampoo',brand:'Patanjali',unit:'200 ml',price:r'₹85',mrp:r'₹95',rating:4.4,reviews:11200,imageUrl:'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',category:'Personal Care'),
  _Product(id:'shp4',name:'Long Strong Shampoo',brand:'Pantene',unit:'340 ml',price:r'₹260',mrp:r'₹285',rating:4.5,reviews:12400,imageUrl:'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',category:'Personal Care'),
  _Product(id:'shp5',name:'Sunsilk Thick Long',brand:'Sunsilk',unit:'320 ml',price:r'₹218',mrp:r'₹240',rating:4.4,reviews:9800,imageUrl:'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?w=400',category:'Personal Care'),
  _Product(id:'sop1',name:'Dettol Original Soap',brand:'Dettol',unit:'75g x 4 Pack',price:r'₹115',mrp:r'₹128',rating:4.7,reviews:21000,imageUrl:'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=400',category:'Personal Care'),
  _Product(id:'sop2',name:'Lifebuoy Total Bar',brand:'Lifebuoy',unit:'100g x 3 Pack',price:r'₹92',mrp:r'₹105',rating:4.5,reviews:16800,imageUrl:'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=400',category:'Personal Care'),
  _Product(id:'sop3',name:'Dove Cream Beauty Bar',brand:'Dove',unit:'100 g Bar',price:r'₹54',mrp:r'₹60',rating:4.7,reviews:18400,imageUrl:'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=400',category:'Personal Care'),
  _Product(id:'sop4',name:'Medimix Ayurvedic Bar',brand:'Medimix',unit:'125g x 3',price:r'₹105',mrp:r'₹120',rating:4.6,reviews:11300,imageUrl:'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=400',category:'Personal Care'),
  _Product(id:'sop5',name:'Lux Soft Touch Bar',brand:'Lux',unit:'100g x 4 Pack',price:r'₹108',mrp:r'₹120',rating:4.4,reviews:13200,imageUrl:'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=400',category:'Personal Care'),
  _Product(id:'wsh1',name:'Surf Excel Easy Wash',brand:'Surf Excel',unit:'1 kg Pack',price:r'₹155',mrp:r'₹172',rating:4.6,reviews:24500,imageUrl:'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',category:'Household'),
  _Product(id:'wsh2',name:'Ariel Complete',brand:'Ariel',unit:'1 kg Pack',price:r'₹165',mrp:r'₹185',rating:4.7,reviews:19800,imageUrl:'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',category:'Household'),
  _Product(id:'wsh3',name:'Rin Advance',brand:'Rin',unit:'1 kg Pack',price:r'₹115',mrp:r'₹128',rating:4.4,reviews:14200,imageUrl:'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',category:'Household'),
  _Product(id:'wsh4',name:'Nirma Washing Powder',brand:'Nirma',unit:'1 kg Pack',price:r'₹68',mrp:r'₹75',rating:4.3,reviews:18700,imageUrl:'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',category:'Household'),
  _Product(id:'wsh5',name:'Tide Ultra Clean',brand:'Tide',unit:'1 kg Pack',price:r'₹148',mrp:r'₹165',rating:4.5,reviews:12900,imageUrl:'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400',category:'Household'),
  _Product(id:'att1',name:'Chakki Fresh Atta',brand:'Aashirvaad',unit:'5 kg Bag',price:r'₹242',mrp:r'₹265',rating:4.7,reviews:28900,imageUrl:'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',category:'Staples'),
  _Product(id:'att2',name:'Whole Wheat Atta',brand:'Pillsbury',unit:'5 kg Bag',price:r'₹228',mrp:r'₹250',rating:4.6,reviews:16700,imageUrl:'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',category:'Staples'),
  _Product(id:'att3',name:'Organic Sharbati Atta',brand:'Organic Tattva',unit:'5 kg Bag',price:r'₹295',mrp:r'₹325',rating:4.5,reviews:8200,imageUrl:'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',category:'Staples'),
  _Product(id:'dal1',name:'Toor Dal',brand:'Tata Sampann',unit:'1 kg Pack',price:r'₹145',mrp:r'₹160',rating:4.6,reviews:14300,imageUrl:'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400',category:'Staples'),
  _Product(id:'dal2',name:'Moong Dal',brand:'Fortune',unit:'1 kg Pack',price:r'₹138',mrp:r'₹150',rating:4.5,reviews:9800,imageUrl:'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400',category:'Staples'),
  _Product(id:'dal3',name:'Masoor Dal',brand:'Tata Sampann',unit:'1 kg Pack',price:r'₹118',mrp:r'₹130',rating:4.5,reviews:8700,imageUrl:'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400',category:'Staples'),
  _Product(id:'dal4',name:'Chana Dal',brand:'Rajdhani',unit:'1 kg Pack',price:r'₹108',mrp:r'₹120',rating:4.4,reviews:7200,imageUrl:'https://images.unsplash.com/photo-1546548970-71785318a17b?w=400',category:'Staples'),
  _Product(id:'oil1',name:'Parachute Coconut Oil',brand:'Parachute',unit:'500 ml Jar',price:r'₹188',mrp:r'₹210',rating:4.8,reviews:32400,imageUrl:'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',category:'Oil'),
  _Product(id:'oil2',name:'Pure Coconut Oil',brand:'Nihar',unit:'500 ml Bottle',price:r'₹178',mrp:r'₹198',rating:4.6,reviews:18700,imageUrl:'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',category:'Oil'),
  _Product(id:'oil3',name:'Virgin Coconut Oil',brand:'KLF Nirmal',unit:'500 ml',price:r'₹215',mrp:r'₹240',rating:4.7,reviews:11200,imageUrl:'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',category:'Oil'),
  _Product(id:'oil4',name:'Coldpressed Coconut Oil',brand:'Coco Soul',unit:'250 ml',price:r'₹195',mrp:r'₹220',rating:4.6,reviews:7800,imageUrl:'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400',category:'Oil'),
  _Product(id:'msl1',name:'Garam Masala',brand:'MDH',unit:'100 g Pack',price:r'₹78',mrp:r'₹88',rating:4.7,reviews:22400,imageUrl:'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',category:'Spices'),
  _Product(id:'msl2',name:'Turmeric Powder',brand:'Everest',unit:'200 g Pack',price:r'₹62',mrp:r'₹72',rating:4.6,reviews:18900,imageUrl:'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',category:'Spices'),
  _Product(id:'msl3',name:'Red Chilli Powder',brand:'Catch',unit:'200 g Pack',price:r'₹68',mrp:r'₹78',rating:4.5,reviews:14700,imageUrl:'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',category:'Spices'),
  _Product(id:'msl4',name:'Coriander Powder',brand:'Suhana',unit:'200 g Pack',price:r'₹65',mrp:r'₹75',rating:4.4,reviews:11200,imageUrl:'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',category:'Spices'),
  _Product(id:'msl5',name:'Kitchen King Masala',brand:'MDH',unit:'100 g Pack',price:r'₹90',mrp:r'₹100',rating:4.7,reviews:16800,imageUrl:'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',category:'Spices'),
  _Product(id:'msl6',name:'Chicken Masala',brand:'Everest',unit:'50 g Pack',price:r'₹45',mrp:r'₹52',rating:4.6,reviews:9800,imageUrl:'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400',category:'Spices'),
  _Product(id:'stn1',name:'HB Pencils 10 pcs',brand:'Apsara',unit:'10 Pencils',price:r'₹38',mrp:r'₹45',rating:4.5,reviews:8900,imageUrl:'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400',category:'Stationery'),
  _Product(id:'stn2',name:'Nataraj HB Pencils',brand:'Nataraj',unit:'10 Pencils',price:r'₹32',mrp:r'₹40',rating:4.4,reviews:7400,imageUrl:'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400',category:'Stationery'),
  _Product(id:'stn3',name:'Colour Pencils 24',brand:'Camlin',unit:'24 pcs Tin',price:r'₹125',mrp:r'₹140',rating:4.7,reviews:11800,imageUrl:'https://images.unsplash.com/photo-1607344645866-009c320b63e0?w=400',category:'Stationery'),
  _Product(id:'stn4',name:'Sketch Pens 12 Shades',brand:'Maped',unit:'12 pcs Set',price:r'₹85',mrp:r'₹95',rating:4.5,reviews:8700,imageUrl:'https://images.unsplash.com/photo-1607344645866-009c320b63e0?w=400',category:'Stationery'),
  _Product(id:'stn5',name:'A4 Notebook 200 Pages',brand:'Classmate',unit:'200 Pages',price:r'₹75',mrp:r'₹85',rating:4.6,reviews:14200,imageUrl:'https://images.unsplash.com/photo-1587614382346-4ec70e388b28?w=400',category:'Stationery'),
  _Product(id:'stn6',name:'Geometry Box Set',brand:'Staedtler',unit:'1 Set',price:r'₹145',mrp:r'₹165',rating:4.7,reviews:9200,imageUrl:'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400',category:'Stationery'),
  _Product(id:'stn7',name:'Long Eraser 6 pcs',brand:'Faber-Castell',unit:'6 pcs Pack',price:r'₹56',mrp:r'₹65',rating:4.6,reviews:6200,imageUrl:'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=400',category:'Stationery'),
];

const _kCats = ['All','Dairy','Beverages','Confectionery','Personal Care','Household','Staples','Oil','Spices','Stationery'];

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});
  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _navIndex = 0;
  String _selectedCat = 'All';
  final Map<String, int> _cart = {};

  void _updateQty(String id, int delta) => setState(() {
        final n = (_cart[id] ?? 0) + delta;
        n <= 0 ? _cart.remove(id) : (_cart[id] = n);
      });

  void _updateProductQty(_Product p, int delta, CartProvider? cartProvider) {
    if (cartProvider != null) {
      final priceVal = double.tryParse(p.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 50.0;
      cartProvider.updateQuantityById(
        id: p.id,
        name: p.name,
        subtitle: p.unit,
        price: priceVal,
        image: p.imageUrl,
        delta: delta,
      );
    } else {
      _updateQty(p.id, delta);
    }
  }

  int _getItemQty(String id, CartProvider? cartProvider) {
    if (cartProvider != null) {
      return cartProvider.getQuantity(id);
    }
    return _cart[id] ?? 0;
  }

  int get _cartCount => _cart.values.fold(0, (s, v) => s + v);
  List<_Product> get _filtered =>
      _selectedCat == 'All' ? _catalog : _catalog.where((p) => p.category == _selectedCat).toList();

  @override
  Widget build(BuildContext context) {
    CartProvider? cartProvider;
    LanguageProvider? languageProvider;

    try { cartProvider = context.watch<CartProvider>(); } catch (_) {}
    try { languageProvider = context.watch<LanguageProvider>(); } catch (_) {}

    final cartCount = cartProvider?.totalCount ?? _cartCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _navIndex,
          children: [
            _buildFeed(cartProvider),
            const BrowseCategoriesScreen(),
            const SearchResultsScreen(),
            const CartScreen(),
            const OrderHistoryScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(cartCount, languageProvider),
    );
  }

  Widget _buildBottomNav(int cartCount, LanguageProvider? languageProvider) => Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_rounded, languageProvider?.translate('shop', 'Home') ?? 'Home'),
            _navItem(1, Icons.grid_view_rounded, languageProvider?.translate('categories', 'Categories') ?? 'Categories'),
            _navItem(2, Icons.search_rounded, languageProvider?.translate('search', 'Search') ?? 'Search'),
            _navItem(3, Icons.shopping_basket_outlined, languageProvider?.translate('cart', 'Cart') ?? 'Cart', badge: cartCount),
            _navItem(4, Icons.receipt_long_rounded, languageProvider?.translate('orders', 'Orders') ?? 'Orders'),
            _navItem(5, Icons.person_outline_rounded, languageProvider?.translate('account', 'Profile') ?? 'Profile'),
          ],
        ),
      );

  Widget _buildFeed(CartProvider? cartProvider) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildHeader(), const SizedBox(height: 12),
                _buildAddressBar(), const SizedBox(height: 12),
                _buildSearchBar(), const SizedBox(height: 16),
              ]),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildBanner()),
            const SizedBox(height: 20),
            // ─── Premium Quick Services Section ──────────────────────────────────
            const QuickServicesSection(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionHeader('Categories', onAll: () => setState(() => _navIndex = 1)),
                const SizedBox(height: 12),
                _buildCategoryChips(),
                const SizedBox(height: 24),
                _sectionHeader('Best Sellers', onAll: () {}),
                const SizedBox(height: 12),
              ]),
            ),
            SizedBox(
              height: 310,
              child: AnimationLimiter(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: SizedBox(width: 170, child: _buildCard(_catalog[i], cartProvider)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionHeader('Kirana Essentials'),
                const SizedBox(height: 12),
                _buildCategoryFilter(),
                const SizedBox(height: 16),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.54,
                    crossAxisSpacing: 14, mainAxisSpacing: 14,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => AnimationConfiguration.staggeredGrid(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 2,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildCard(_filtered[i], cartProvider),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ─── Buy Again ──────────────────────────────────────────────
            const SizedBox(height: 28),
            const BuyAgainSection(),
            // ─── Recently Viewed ───────────────────────────────────────
            const SizedBox(height: 28),
            const RecentlyViewedSection(),
            const SizedBox(height: 32),
          ],
        ),
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => AppNavigationDrawer.show(context), icon: const Icon(Icons.menu_rounded, color: Color(0xFF1A1C1E), size: 26)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 28, height: 28, padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12)),
              child: Image.asset('assets/images/daily_basket_logo.png', fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag_rounded, size: 18, color: Color(0xFF006B23))),
            ),
            const SizedBox(width: 8),
            Text('Daily Basket', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF006B23))),
          ]),
          Stack(clipBehavior: Clip.none, children: [
            IconButton(onPressed: () => Navigator.pushNamed(context, '/cart'), icon: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF006B23), size: 26)),
            if (_cartCount > 0) Positioned(top: 6, right: 6, child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFF006B23), shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$_cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            )),
          ]),
        ],
      );

  Widget _buildAddressBar() => GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/saved-addresses'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFFF3F3F6), borderRadius: BorderRadius.circular(9999)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF006B23), size: 20),
            const SizedBox(width: 8),
            Text('123 Main St, New York', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF1A1C1E))),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6E7A6C), size: 20),
          ]),
        ),
      );

  Widget _buildSearchBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFF3F3F6), borderRadius: BorderRadius.circular(9999)),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Row(children: [
                  const Icon(Icons.search_rounded, color: Color(0xFF6E7A6C), size: 22),
                  const SizedBox(width: 10),
                  Text('Search products...', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6E7A6C))),
                ]),
              ),
            ),
            GestureDetector(
              onTap: () {
                VoiceSearchDialog.show(
                  context,
                  onSpeechResult: (query) {
                    Navigator.pushNamed(context, '/search', arguments: query);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Color(0xFF006B23),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildBanner() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: double.infinity,
          height: 180,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/illustrations/fresharrivalbg.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFF006B23))),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft, end: Alignment.centerRight,
                  colors: [const Color(0xFF006B23).withValues(alpha: 0.92), const Color(0xFF006B23).withValues(alpha: 0.50), Colors.transparent],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Fresh Arrivals', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 190),
                  child: Text('Up to 20% off organic vegetables this weekend.', style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.95), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/categories'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9999)),
                    child: Text('Shop Now', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF006B23))),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      );

  Widget _sectionHeader(String title, {VoidCallback? onAll}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1A1C1E))),
          if (onAll != null) TextButton(onPressed: onAll, child: Text('See All', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF006B23)))),
        ],
      );




  Widget _buildCategoryChips() {
    const chips = [
      ('Fruits', 'cat-1', '🍌'),
      ('Vegetables', 'cat-1', '🥦'),
      ('Dairy', 'cat-2', '🥛'),
      ('Bakery', 'cat-5', '🥐'),
      ('Beverages', 'cat-3', '☕'),
      ('Household', 'cat-6', '🧺'),
      ('Spices', 'cat-1', '🌶️'),
      ('Stationery', 'cat-4', '✏️'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.map((c) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListingScreen(
                  categoryId: c.$2,
                  categoryName: c.$1,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF3F3F6), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [Text(c.$3, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8), Text(c.$1, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)))]),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCategoryFilter() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(children: _kCats.map((cat) {
          final sel = _selectedCat == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFF006B23) : Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: sel ? const Color(0xFF006B23) : const Color(0xFFBECAB9)),
              ),
              child: Text(cat, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: sel ? Colors.white : const Color(0xFF3F4A3D))),
            ),
          );
        }).toList()),
      );

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy':
        return Icons.egg_alt_rounded;
      case 'Beverages':
        return Icons.local_drink_rounded;
      case 'Confectionery':
        return Icons.cookie_rounded;
      case 'Personal Care':
        return Icons.clean_hands_rounded;
      case 'Household':
        return Icons.soap_rounded;
      case 'Staples':
        return Icons.grain_rounded;
      case 'Oil':
        return Icons.oil_barrel_rounded;
      case 'Spices':
        return Icons.local_fire_department_rounded;
      case 'Stationery':
        return Icons.edit_rounded;
      default:
        return Icons.shopping_basket_rounded;
    }
  }

  Widget _buildCard(_Product p, [CartProvider? cartProvider]) {
    final qty = _getItemQty(p.id, cartProvider);
    return GestureDetector(
      onTap: () {
        try {
          context.read<RecentlyViewedProvider>().addRecentlyViewed({
            'id': p.id,
            'name': p.name,
            'brand': p.brand,
            'unit': p.unit,
            'price': p.price,
            'mrp': p.mrp,
            'imageUrl': p.imageUrl,
          });
        } catch (_) {}
        Navigator.pushNamed(
          context,
          '/product-details',
          arguments: {
            'productId': p.id,
            'categoryTag': p.category.toUpperCase(),
            'productName': p.name,
            'price': p.price,
            'mrp': p.mrp,
            'discountPercentage': '20% OFF',
            'unitDetails': p.unit,
            'deliveryTime': '8 mins',
            'imageUrl': p.imageUrl,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBECAB9).withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: AppNetworkImage(
                    imageUrl: p.imageUrl,
                    fit: BoxFit.cover,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    fallbackIcon: _getCategoryIcon(p.category),
                    fallbackBgColor: const Color(0xFFF3F3F6),
                    fallbackIconColor: const Color(0xFF006B23),
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: FavoriteButton(
                  productId: p.id,
                  productDetails: {
                    'id': p.id,
                    'name': p.name,
                    'brand': p.brand,
                    'weight': p.unit,
                    'price': double.tryParse(p.price.replaceAll('₹', '')) ?? 50.0,
                    'mrp': double.tryParse(p.mrp.replaceAll('₹', '')) ?? 60.0,
                    'category': p.category,
                    'imageUrl': p.imageUrl,
                  },
                  size: 20,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.brand, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF006B23)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(p.name, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E)), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 1),
                Text(p.unit, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6E7A6C))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 2),
                  Text(p.rating.toStringAsFixed(1), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1A1C1E))),
                  const SizedBox(width: 3),
                  Flexible(child: Text('(${_fmt(p.reviews)})', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6E7A6C)), overflow: TextOverflow.ellipsis)),
                ]),
                const Spacer(),
                Row(children: [
                  Text(p.price, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF006B23))),
                  const SizedBox(width: 5),
                  Text(p.mrp, style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF6E7A6C), decoration: TextDecoration.lineThrough)),
                ]),
                const SizedBox(height: 7),
                qty == 0
                    ? SizedBox(
                        width: double.infinity, height: 32,
                        child: ElevatedButton(
                          onPressed: () => _updateProductQty(p, 1, cartProvider),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006B23), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: EdgeInsets.zero),
                          child: Text('Add', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      )
                    : Container(
                        height: 32,
                        decoration: BoxDecoration(color: const Color(0xFF006B23), borderRadius: BorderRadius.circular(8)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          GestureDetector(onTap: () => _updateProductQty(p, -1, cartProvider), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.remove, color: Colors.white, size: 16))),
                          Text('$qty', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                          GestureDetector(onTap: () => _updateProductQty(p, 1, cartProvider), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.add, color: Colors.white, size: 16))),
                        ]),
                      ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  Widget _navItem(int index, IconData icon, String label, {int badge = 0}) {
    final active = _navIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: active ? const Color(0xFF006B23) : Colors.transparent, borderRadius: BorderRadius.circular(9999)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(icon, color: active ? Colors.white : const Color(0xFF6E7A6C), size: 22),
            if (badge > 0 && !active) Positioned(top: -4, right: -6, child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            )),
          ]),
          if (active) ...[const SizedBox(width: 6), Text(label, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))],
        ]),
      ),
    );
  }
}
