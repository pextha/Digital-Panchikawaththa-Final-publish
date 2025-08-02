import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/Product_Model.dart';
import 'package:panchikawaththa/pages/add_to_cart_popup.dart';
import 'package:panchikawaththa/pages/orderConfirmation.dart';
import 'package:panchikawaththa/pages/review.dart';
import 'package:share_plus/share_plus.dart';
import 'seller_page.dart';
import 'dart:math';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? product;
  bool isLoading = true;

  static const Color primaryColor = Color.fromARGB(255, 20, 211, 3);

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (widget.productId.isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid product ID.')),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        setState(() {
          product = Product.fromJson(doc.data()!);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found.')),
        );
      }
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.message}')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  void _addToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to cart!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
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

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product details not available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                  'Check out this product: ${product!.name} - LKR ${product!.price.toStringAsFixed(2)}');
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: CartPopupContent(
                          product: product), // pass the actual product object
                    ),
                  );
                },
                child: const Text("Add to Cart",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  if (product != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderConfirmationPage(product: product!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Product not yet loaded. Please wait.')),
                    );
                  }
                },
                child: const Text("Buy Now",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product!.imageBase64.isNotEmpty
                    ? min(product!.imageBase64.length, 3)
                    : 1,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: product!.imageBase64.isNotEmpty
                          ? Image.memory(
                              base64Decode(product!.imageBase64[index]),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/placeholder_image.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/placeholder_image.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product?.name ?? 'Unknown Product',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "LKR ${product?.price.toStringAsFixed(2) ?? '0.00'}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Free shipping",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SellerPage()),
                      );
                    },
                    child: const Text(
                      "Seller Details",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: List.generate(
                    product!.rating.round(),
                    (_) =>
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  product?.rating.toStringAsFixed(1) ?? '0.0',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text("(${product?.sold ?? 0} ratings)"),
              ],
            ),
            const Divider(height: 30),
            RatingsAndReviews(productId: product!.id),
            const Divider(height: 30),
            const Text("Product details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              product?.description ?? 'No description available',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class RatingsAndReviews extends StatelessWidget {
  final String productId;
  static const Color primaryColor = Color.fromARGB(255, 20, 211, 3);

  const RatingsAndReviews({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ratings & Reviews',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '4.3', // Placeholder: Fetch dynamically if available
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('23 ratings'), // Placeholder: Fetch dynamically
                const SizedBox(height: 4),
                _buildRatingBar(5, 12),
                _buildRatingBar(4, 5),
                _buildRatingBar(3, 4),
                _buildRatingBar(2, 2),
                _buildRatingBar(1, 0),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          "Excellent Seller...quick shipment...item was exactly as stated...quality item! A+++",
          "2***k",
        ),
        _buildReviewCard(
          "Perfect transaction! Item exactly as described, and shipped quickly.",
          "4***n",
        ),
        _buildReviewCard(
          "Item received is exactly as advertised. Fast turnaround on shipping. Smooth transaction.",
          "0***w",
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'See More',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewsPage(productId: productId)),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  static Widget _buildRatingBar(int star, int count) {
    return Row(
      children: [
        Row(
          children: List.generate(star,
              (_) => const Icon(Icons.star, size: 12, color: Colors.orange)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: count / 12, // Adjust denominator based on total ratings
            color: Colors.green,
            backgroundColor: Colors.grey.shade300,
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 8),
        Text('$count'),
      ],
    );
  }

  static Widget _buildReviewCard(String review, String user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review),
          const SizedBox(height: 6),
          Row(
            children: [
              Row(
                children: List.generate(
                    5,
                    (_) =>
                        const Icon(Icons.star, size: 14, color: Colors.orange)),
              ),
              const SizedBox(width: 6),
              Text(user, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
