// Import statements
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/user_model.dart';
import 'package:panchikawaththa/pages/RecentPurchasesPage.dart';
import 'package:panchikawaththa/pages/add_new_card_page.dart';
import 'package:panchikawaththa/pages/admin_dashboard_page.dart';
import 'package:panchikawaththa/pages/edit_profile_page.dart';
import 'package:panchikawaththa/pages/help_center_page.dart';
import 'package:panchikawaththa/pages/return_details_page.dart';
import 'package:panchikawaththa/pages/save_card_page.dart';
import 'package:panchikawaththa/pages/store_coupon_page.dart';
import 'package:panchikawaththa/pages/setting_page.dart';
import 'package:panchikawaththa/pages/notification.dart';
import 'package:panchikawaththa/pages/user_products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Profilepage());
}

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not signed in')),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userModel = UserModel.fromDocument(doc);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found.')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data')),
      );
    }
  }

  ImageProvider getUserImage(String base64Image) {
    try {
      Uint8List bytes = base64Decode(base64Image);
      return MemoryImage(bytes);
    } catch (e) {
      return const AssetImage("assets/profile.jpeg");
    }
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.black),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPurchaseItem(
      String title, String total, String qty, String price, String imagePath,
      {bool isDelivered = true}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Image.asset(imagePath, width: 50),
        title: Text(title),
        subtitle: Text('Qty: $qty\nTotal: Rs. $total'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Rs. $price'),
            const SizedBox(height: 4),
            Text(
              isDelivered ? 'Delivered' : 'Pending',
              style: TextStyle(
                color: isDelivered ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userModel == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'User data not found.',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    final avatarImage = userModel!.profileImageUrl.isNotEmpty
        ? getUserImage(userModel!.profileImageUrl)
        : const AssetImage("assets/profile.jpeg");

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const Text('Account',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage())),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsPage())),
                  ),
                ],
              ),
            ),

            // Profile section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userModel!.name,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.email,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(userModel!.email,
                                style: const TextStyle(color: Colors.grey))
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.phone,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(userModel!.phone,
                                style: const TextStyle(color: Colors.grey))
                          ]),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(radius: 30, backgroundImage: avatarImage),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage())),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: const [
                                Text('Edit Profile',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                Icon(Icons.arrow_forward_ios,
                                    size: 12, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (userModel!.status == 'admin')
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 28,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdminDashboardPage()),
                                  );
                                },
                                child: const Text(
                                  'Admin Panel',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpCenterPage())),
                      child: _buildMenuItem(Icons.headset, 'Help Center')),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedCardsPage())),
                      child: _buildMenuItem(Icons.credit_card, 'Cards')),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReturnDetailsPage())),
                      child: _buildMenuItem(Icons.keyboard_return, 'Return')),
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreCouponPage())),
                      child: _buildMenuItem(Icons.card_giftcard, 'Coupons')),
                ],
              ),
            ),

            const Divider(height: 32),

            // Recent Purchases + My Products button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Purchases',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecentPurchasesPage())),
                        child: const Text('Show all',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProductsPage()),
                          );
                        },
                        child: const Text('See My Products',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildPurchaseItem('Item Name', '375,000.00', '5',
                      '75,000.00', 'assets/wheel.jpg',
                      isDelivered: false),
                  _buildPurchaseItem('Exide Battery', '45,000.00', '1',
                      '45,000.00', 'assets/wheel.jpg'),
                  _buildPurchaseItem('Turbo unit', '75,000.00', '1',
                      '75,000.00', 'assets/wheel.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
