import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panchikawaththa/pages/UserAddProductPage.dart';
import 'package:panchikawaththa/pages/profile_page.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'search.dart';
// <-- Import this

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CartPage(),
    UserAddProductPage(),
    SearchPage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(
                icon: Icons.home,
                index: 0,
                activeColor: Color(0xFF02B91A),
              ),
              navItem(
                icon: Icons.shopping_cart_outlined,
                index: 1,
                activeColor: Color(0xFF02B91A),
              ),
              navItem(
                icon: Icons.add,
                index: 2,
                activeColor: Color(0xFF02B91A),
              ),
              navItem(
                icon: Icons.search,
                index: 3,
                activeColor: Color(0xFF02B91A),
              ),
              navItem(
                icon: Icons.account_circle,
                index: 4,
                activeColor: Color(0xFF02B91A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required int index,
    Color activeColor = Colors.white,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        size: 28.sp,
        color: _currentIndex == index ? activeColor : Colors.white,
      ),
      onPressed: () => setState(() => _currentIndex = index),
    );
  }
}
