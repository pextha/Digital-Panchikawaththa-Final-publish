import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panchikawaththa/pages/category.dart';
import 'package:panchikawaththa/pages/chata_bot.dart';
import 'package:panchikawaththa/pages/notification.dart';
import 'package:panchikawaththa/pages/productDetailpage.dart';
import 'package:panchikawaththa/pages/serviceCenter.dart';
import 'package:panchikawaththa/models/category_model.dart';
import 'package:panchikawaththa/models/product_model.dart';
import 'package:panchikawaththa/services/ProductService.dart';
import 'package:panchikawaththa/services/category_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSupportMenu = false;
  List<Category> _categories = [];
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _isProductLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryService().getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ProductService().getProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isProductLoading = false;
      });
    } catch (e) {
      setState(() => _isProductLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  void _toggleSupportMenu() {
    setState(() => _showSupportMenu = !_showSupportMenu);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  Future<void> _refreshProducts() async {
    setState(() => _isProductLoading = true);
    await _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    _buildTopBar(context),
                    SizedBox(height: 24.h),
                    _buildSearchBar(),
                    SizedBox(height: 24.h),
                    _buildCategorySection(),
                    SizedBox(height: 24.h),
                    _buildHotDealsSection(context),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            if (_showSupportMenu) _buildSupportMenuOverlay(context),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/logo.png", height: 50.h),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            );
          },
          child: Icon(Icons.notifications_none, size: 26.sp),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search for products",
                      border: InputBorder.none,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Icon(Icons.mic, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 60.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              categoryId: category.name,
                              categoryName: category.name,
                            ),
                          ),
                        );
                      },
                      child: categoryItem(category.imageBase64),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildHotDealsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today Hot Deals',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        _isProductLoading
            ? const Center(child: CircularProgressIndicator())
            : _filteredProducts.isEmpty
                ? const Center(child: Text('No products found.'))
                : GridView.builder(
                    itemCount: _filteredProducts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return dealCard(context, _filteredProducts[index]);
                    },
                  ),
      ],
    );
  }

  Widget _buildSupportMenuOverlay(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _toggleSupportMenu,
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),
        ),
        Positioned(
          bottom: 90,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _supportMenuItem(
                icon: Icons.smart_toy,
                text: "Chat with Mario",
                onTap: () {
                  _toggleSupportMenu();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatBotPage()),
                  );
                },
              ),
              SizedBox(height: 10),
              _supportMenuItem(
                icon: Icons.support_agent,
                text: "Service Centers",
                onTap: () {
                  _toggleSupportMenu();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      elevation: 4,
      shape: const CircleBorder(),
      onPressed: _toggleSupportMenu,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _showSupportMenu
            ? Icon(Icons.close,
                key: const ValueKey('close'), color: Colors.white, size: 32)
            : ClipOval(
                key: const ValueKey('bot'),
                child: Image.asset(
                  'assets/mario_bot.jpg',
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _supportMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                spreadRadius: 2,
                offset: Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(
                    color: Color(0xFF02B91A),
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            Icon(icon, color: const Color(0xFF02B91A)),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(String imageBase64) {
    try {
      final bytes = base64Decode(imageBase64);
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: CircleAvatar(
          radius: 30.r,
          backgroundColor: Colors.grey[200],
          backgroundImage: MemoryImage(bytes),
        ),
      );
    } catch (_) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: CircleAvatar(
          radius: 30.r,
          backgroundColor: Colors.grey[200],
          backgroundImage: const AssetImage('assets/placeholder_image.png'),
        ),
      );
    }
  }

  Widget dealCard(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6.r, offset: Offset(0, 2)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(productId: product.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: product.imageBase64.isNotEmpty
                  ? Image.memory(
                      base64Decode(product.imageBase64.first),
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/placeholder_image.png',
                          height: 100.h,
                          width: double.infinity),
                    )
                  : Image.asset('assets/placeholder_image.png',
                      height: 100.h, width: double.infinity),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < product.rating.round()
                            ? Colors.amber
                            : Colors.grey,
                        size: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.name,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                    maxLines: 2,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "LKR ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${product.sold} sold",
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                      ),
                      Icon(Icons.shopping_cart,
                          color: Colors.green, size: 16.sp),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
