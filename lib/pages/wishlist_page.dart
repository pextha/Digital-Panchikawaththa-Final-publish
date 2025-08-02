import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});

  final List<Map<String, dynamic>> wishlistItems = [
    {
      'name': 'Front Brake Disc',
      'price': 15003.25,
      'image': 'assets/brake.jpg',
    },
    {
      'name': 'Clutch Disc',
      'price': 12919.47,
      'image': 'assets/clutch_disc.jpg',
    },
    {
      'name': 'Lid Projector Headlights',
      'price': 10508.15,
      'image': 'assets/light.jpg',
    },
    {
      'name': 'Air Filter',
      'price': 5670.00,
      'image': 'assets/airfilter.jpg',
    },
    {
      'name': 'Gasoline Diesel Car Engine',
      'price': 1468905.89,
      'image': 'assets/Engine.png',
    },
    {
      'name': 'Gasoline Diesel Car Engine',
      'price': 1468905.89,
      'image': 'assets/Engine.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text('My Wishlist',
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Image.asset(item['image'], width: 50.w, height: 50.h),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp)),
                              SizedBox(height: 4.h),
                              Text('LKR ${item['price'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 13.sp)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_cart_outlined,
                              color: Colors.green),
                          onPressed: () {
                            // Add to cart logic
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            // Delete from wishlist logic
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
