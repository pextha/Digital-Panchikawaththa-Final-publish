import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panchikawaththa/utils/dialogs.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final List<Map<String, dynamic>> searchResults = [
    {
      'title':
          '7.8" Inch Portable DVD Player Swivel Screen 270° Multi Region In Car USB Charger',
      'price': 40750.48,
      'rating': 5,
      'sold': 621,
      'condition': 'Brand New',
      'image': 'assets/dvd.jpg',
    },
    {
      'title':
          'Bush 12 inch Swivel Screen Portable DVD Player - Black - Car Straps',
      'price': 16550.09,
      'rating': 4,
      'sold': 423,
      'condition': 'Pre-Owned',
      'image': 'assets/dvd.jpg',
    },
    {
      'title':
          'FANGOR 10.1" Android TabletPortable DVD Player for Headrest/Car, Quad-Core 1.3G',
      'price': 10750.00,
      'rating': 2,
      'sold': 201,
      'condition': 'Brand New',
      'image': 'assets/dvd.jpg',
    },
    {
      'title':
          'Boss BV755B Double DIN In-Dash DVD/CD/AM/FM Bluetooth Car Stereo Receiver 6.2"',
      'price': 54778.10,
      'rating': 5,
      'sold': 421,
      'condition': 'Brand New',
      'image': 'assets/dvd.jpg',
    },
  ];

  Widget _buildStars(int count) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(Icons.star,
            color: i < count ? Colors.amber : Colors.grey, size: 14.sp);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Row(
              children: [
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "dvd player for car",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.mic, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Filter row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Best Match",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.sp)),
                Row(
                  children: [
                    Icon(Icons.sort, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text("Price: lowest to high",
                        style: TextStyle(fontSize: 14.sp)),
                    SizedBox(width: 12.w),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () => showFilterPopup(context),
                    ),
                    Text(" Filters", style: TextStyle(fontSize: 14.sp)),
                  ],
                )
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final item = searchResults[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(item['image'],
                            width: 80.w, height: 80.h, fit: BoxFit.contain),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'],
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 4.h),
                              Text(item['condition'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.sp)),
                              SizedBox(height: 6.h),
                              Text("LKR ${item['price'].toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp)),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  _buildStars(item['rating']),
                                  SizedBox(width: 6.w),
                                  Text("${item['sold']} sold",
                                      style: TextStyle(fontSize: 11.sp)),
                                  Spacer(),
                                  Icon(Icons.local_shipping,
                                      size: 18.sp, color: Colors.green)
                                ],
                              )
                            ],
                          ),
                        )
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
