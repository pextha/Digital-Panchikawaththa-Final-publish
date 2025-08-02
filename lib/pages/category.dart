import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panchikawaththa/models/product_model.dart';
import 'package:panchikawaththa/services/ProductService.dart';
import 'package:panchikawaththa/pages/productDetailpage.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  Future<void> _loadCategoryProducts() async {
    try {
      final allProducts = await ProductService().getProducts();
      final categoryProducts = allProducts
          .where((product) => product.category == widget.categoryId)
          .toList();
      setState(() {
        _products = categoryProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading category products: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 63, 204, 70),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _products.isEmpty
                ? const Center(child: Text('No products found.'))
                : GridView.builder(
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return dealCard(context, product);
                    },
                  ),
      ),
    );
  }

  Widget dealCard(BuildContext context, Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6.r,
              offset: const Offset(0, 2)),
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
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/placeholder_image.png',
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
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
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.green,
                        size: 16.sp,
                      ),
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
