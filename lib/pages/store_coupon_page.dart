import 'package:flutter/material.dart';

void main() {
  runApp(const StoreCouponPage());
}

class StoreCouponPage extends StatelessWidget {
  const StoreCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Coupons',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Text',
      ),
      home: const StoreCouponScreen(),
    );
  }
}

class CouponData {
  final String amount;
  final String minOrder;
  final String validUntil;
  final String code;

  CouponData({
    required this.amount,
    required this.minOrder,
    required this.validUntil,
    required this.code,
  });
}

class StoreCouponScreen extends StatelessWidget {
  const StoreCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample coupon data
    final List<CouponData> coupons = [
      CouponData(
        amount: 'LKR1000.00',
        minOrder: 'Orders Over LKR25000.00',
        validUntil: 'Valid until Oct 31, 11:59 PM PT',
        code: 'SSNXP22MY01F',
      ),
      CouponData(
        amount: 'LKR1000.00',
        minOrder: 'Orders Over LKR 25000.00',
        validUntil: 'Valid until Oct 31, 11:59 PM PT',
        code: 'SA5A2V673ELP',
      ),
      CouponData(
        amount: 'LKR1500.00',
        minOrder: 'Orders Over LKR 30000.00',
        validUntil: 'Valid until Oct 31, 11:59 PM PT',
        code: 'S8ZXKEXPV33E',
      ),
      CouponData(
        amount: 'LKR2500.00',
        minOrder: 'Orders Over LKR 40000.00',
        validUntil: 'Valid until Oct 31, 11:59 PM PT',
        code: 'SYNW4B5CQR4',
      ),
      CouponData(
        amount: 'LKR2500.00',
        minOrder: 'Orders Over LKR 40000.00',
        validUntil: 'Valid until Oct 31, 11:59 PM PT',
        code: 'SRX34QM34RG',
      ),
      CouponData(
        amount: 'LKR2990.00',
        minOrder: 'Orders Over LKR 45000.00',
        validUntil: 'Valid until Oct 31, 11:59 PM PT',
        code: 'SSNXP22MY01F',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Store coupon',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300,
            height: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.signal_cellular_alt,
                    color: Colors.black.withOpacity(0.7), size: 16),
                const SizedBox(width: 2),
                Icon(Icons.wifi,
                    color: Colors.black.withOpacity(0.7), size: 16),
                const SizedBox(width: 2),
                Icon(Icons.battery_full,
                    color: Colors.black.withOpacity(0.7), size: 16),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Store name with arrow
            Row(
              children: [
                Text(
                  'Hubhome Store',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Coupon list
            ...coupons.map((coupon) => _buildCouponCard(coupon)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(CouponData coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDAF0E1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Left side - Coupon details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.minOrder,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coupon.validUntil,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Right side - Code and button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                coupon.code,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Use now',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
