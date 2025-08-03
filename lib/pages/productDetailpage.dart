import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/Product_Model.dart';
import 'package:panchikawaththa/models/Review_Model.dart';
import 'package:panchikawaththa/pages/add_to_cart_popup.dart';
import 'package:panchikawaththa/pages/orderConfirmation.dart';
import 'package:panchikawaththa/pages/review.dart';
import 'package:share_plus/share_plus.dart';
import 'seller_page.dart';
import 'dart:math';
import 'package:panchikawaththa/pages/ReviewForm.dart';

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
                      child: CartPopupContent(product: product),
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

class RatingsAndReviews extends StatefulWidget {
  final String productId;
  static const Color primaryColor = Color.fromARGB(255, 20, 211, 3);

  const RatingsAndReviews({super.key, required this.productId});

  @override
  _RatingsAndReviewsState createState() => _RatingsAndReviewsState();
}

class _RatingsAndReviewsState extends State<RatingsAndReviews> {
  List<Review> reviews = [];
  bool isLoading = true;
  Map<int, int> ratingCount = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: widget.productId)
          .orderBy('date', descending: true)
          .limit(3)
          .get();

      final data = snapshot.docs
          .map((doc) => Review.fromFirestore(doc.data(), doc.id))
          .toList();

      setState(() {
        reviews = data;
        calculateRatingCounts();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() => isLoading = false);
    }
  }

  void calculateRatingCounts() {
    ratingCount = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in reviews) {
      ratingCount[review.stars] = (ratingCount[review.stars] ?? 0) + 1;
    }
  }

  double get averageRating {
    int totalStars = 0;
    int totalRatings = 0;
    ratingCount.forEach((stars, count) {
      totalStars += stars * count;
      totalRatings += count;
    });
    return totalRatings > 0 ? totalStars / totalRatings : 0.0;
  }

  int get totalRatings => ratingCount.values.reduce((a, b) => a + b);

  Widget _buildRatingBar(int stars, int count) {
    double maxWidth = 100;
    double percent = totalRatings > 0 ? count / totalRatings : 0;

    return Row(
      children: [
        Row(
          children: List.generate(stars,
              (_) => const Icon(Icons.star, size: 12, color: Colors.orange)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: maxWidth,
          child: Stack(
            children: [
              Container(width: maxWidth, height: 8, color: Colors.grey[300]),
              Container(
                  width: maxWidth * percent, height: 8, color: Colors.green),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(count.toString()),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
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
          Text(review.review),
          const SizedBox(height: 6),
          Row(
            children: [
              Row(
                children: List.generate(
                    review.stars,
                    (_) =>
                        const Icon(Icons.star, size: 14, color: Colors.orange)),
              ),
              const SizedBox(width: 6),
              Text(review.name, style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 6),
              Text(
                review.date.toLocal().toString().substring(0, 10),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$totalRatings ratings'),
                          const SizedBox(height: 4),
                          ...ratingCount.keys.map((star) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: _buildRatingBar(star, ratingCount[star]!),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  reviews.isEmpty
                      ? const Text('No reviews yet.')
                      : Column(
                          children: reviews
                              .map((review) => _buildReviewCard(review))
                              .toList(),
                        ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RatingsAndReviews.primaryColor,
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
                              builder: (context) =>
                                  ReviewsPage(productId: widget.productId)),
                        );
                      },
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ReviewsPage extends StatefulWidget {
  final String productId;

  const ReviewsPage({super.key, required this.productId});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<Review> reviews = [];
  bool isLoading = true;
  Map<int, int> ratingCount = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: widget.productId)
          .orderBy('date', descending: true)
          .get();

      final data = snapshot.docs
          .map((doc) => Review.fromFirestore(doc.data(), doc.id))
          .toList();

      setState(() {
        reviews = data;
        calculateRatingCounts();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() => isLoading = false);
    }
  }

  void calculateRatingCounts() {
    ratingCount = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in reviews) {
      ratingCount[review.stars] = (ratingCount[review.stars] ?? 0) + 1;
    }
  }

  double get averageRating {
    int totalStars = 0;
    int totalRatings = 0;
    ratingCount.forEach((stars, count) {
      totalStars += stars * count;
      totalRatings += count;
    });
    return totalRatings > 0 ? totalStars / totalRatings : 0.0;
  }

  int get totalRatings => ratingCount.values.reduce((a, b) => a + b);

  void _showReviewPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReviewForm(productId: widget.productId),
    ).then((_) => fetchReviews());
  }

  Widget _buildRatingBar(int stars, int count) {
    double maxWidth = 200;
    double percent = totalRatings > 0 ? count / totalRatings : 0;

    return Row(
      children: [
        Icon(Icons.star, size: 16, color: Colors.orange),
        SizedBox(width: 2),
        Text('$stars', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Stack(
          children: [
            Container(width: maxWidth, height: 8, color: Colors.grey[300]),
            Container(
                width: maxWidth * percent, height: 8, color: Colors.green),
          ],
        ),
        SizedBox(width: 8),
        Text(count.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rating & Reviews')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rating & Reviews",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(averageRating.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ratingCount.keys.map((star) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: _buildRatingBar(star, ratingCount[star]!),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("${reviews.length} reviews",
                      style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (_, index) {
                        final review = reviews[index];
                        return ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          title: Text(review.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(
                                  review.stars,
                                  (_) => Icon(Icons.star,
                                      size: 16, color: Colors.orange),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(review.review),
                              Text(review.date.toLocal().toString(),
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton.icon(
                      onPressed: () => _showReviewPopup(context),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text('Write a review',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF02B91A),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
