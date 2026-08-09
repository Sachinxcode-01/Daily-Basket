import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Google Stitch Source of Truth Screen: Delivery Partner Profile / Rider Profile
/// Project ID: 6885817708675501691
/// Screen ID: 752cc842c34a4783937ee46992667864
class AdminRiderProfileScreen extends StatefulWidget {
  final String riderId;

  const AdminRiderProfileScreen({
    super.key,
    this.riderId = 'DB-RIDER-402',
  });

  @override
  State<AdminRiderProfileScreen> createState() => _AdminRiderProfileScreenState();
}

class _AdminRiderProfileScreenState extends State<AdminRiderProfileScreen> {
  bool _isLoading = false;

  // Stitch Design System Colors
  static const Color _primaryGreen = Color(0xFF006837);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF1E2923);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _mintText = Color(0xFF15803D);

  // Rider Profile Data State
  final Map<String, dynamic> _rider = {
    'id': 'DB-RIDER-402',
    'name': 'Vikram Singh',
    'status': 'Online',
    'isVerified': true,
    'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    'vehicleType': 'E-Scooter',
    'vehicleReg': 'DL 4S AB 1234',
    'todayEarnings': '₹840',
    'todayTrend': '+12%',
    'rating': '4.8',
    'onTimeRate': '96%',
    'lastUpdated': '1m ago',
    'routeOrigin': 'New Delhi Central Warehouse',
    'routeDestination': 'Kirti Nagar Sector 4',
  };

  @override
  void initState() {
    super.initState();
    _fetchRiderProfileApi();
  }

  Future<void> _fetchRiderProfileApi() async {
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/delivery/track/ORD-8923'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['driverName'] != null) {
          setState(() {
            _rider['name'] = data['driverName'] ?? _rider['name'];
          });
        }
      }
    } catch (_) {
      // Graceful fallback to Stitch specs data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: _buildStitchAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primaryGreen))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // Identity & Vehicle Card
                    _buildRiderIdentityCard(),
                    const SizedBox(height: 16),

                    // Metrics Strip (2 Columns)
                    _buildPerformanceMetricsStrip(),
                    const SizedBox(height: 16),

                    // Live Location Map Card
                    _buildLiveLocationMapCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildStitchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'Rider Profile',
        style: TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: _textDark),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildRiderIdentityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Photo Avatar with Verified Pill Badge
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _rider['avatar'] as String,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name & Status
          Text(
            _rider['name'] as String,
            style: const TextStyle(
              color: _textDark,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_rider['id']}  •  ',
                style: const TextStyle(color: _textMuted, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.bolt_rounded, color: _mintText, size: 16),
              const SizedBox(width: 2),
              Text(
                _rider['status'] as String,
                style: const TextStyle(color: _mintText, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Vehicle Box Container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.electric_scooter_outlined, color: Color(0xFF0284C7), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _rider['vehicleType'] as String,
                        style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        _rider['vehicleReg'] as String,
                        style: const TextStyle(color: _textMuted, fontSize: 11.5, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetricsStrip() {
    return Row(
      children: [
        // Left Column: Today Earnings
        Expanded(
          flex: 5,
          child: Container(
            height: 136,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, color: _mintText, size: 22),
                    Text('Today', style: TextStyle(color: _textMuted, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                Text(
                  _rider['todayEarnings'] as String,
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 26),
                ),
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, color: _mintText, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      _rider['todayTrend'] as String,
                      style: const TextStyle(color: _mintText, fontWeight: FontWeight.bold, fontSize: 11.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Right Column: Rating & On-Time Cards
        Expanded(
          flex: 5,
          child: Column(
            children: [
              // Rating Card
              Container(
                height: 62,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _rider['rating'] as String,
                      style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    const Spacer(),
                    const Text('Rating', style: TextStyle(color: _textMuted, fontSize: 11.5)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // On-Time Card
              Container(
                height: 62,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: _primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _rider['onTimeRate'] as String,
                      style: const TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    const Spacer(),
                    const Text('On-Time', style: TextStyle(color: _textMuted, fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveLocationMapCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Location',
                style: TextStyle(color: _textDark, fontWeight: FontWeight.w900, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE6FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Last updated: ${_rider['lastUpdated']}',
                  style: const TextStyle(color: _textDark, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 60,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: _primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.electric_scooter_rounded, color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 70,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9F1239),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flag_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
