import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String productId;
  final int stars;
  final String review;
  final String name;
  final DateTime date;

  Review({
    required this.id,
    required this.productId,
    required this.stars,
    required this.review,
    required this.name,
    required this.date,
  });

  factory Review.fromFirestore(Map<String, dynamic> data, String id) {
    return Review(
      id: id,
      productId: data['productId'] ?? '',
      stars: data['stars'] ?? 0,
      review: data['review'] ?? '',
      name: data['name'] ?? 'Anonymous',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'stars': stars,
      'review': review,
      'name': name,
      'date': date,
    };
  }
}
