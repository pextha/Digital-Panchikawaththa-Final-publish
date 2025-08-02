import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/Review_Model.dart';
import 'ReviewForm.dart';
import 'review.dart';

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
