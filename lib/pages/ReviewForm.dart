import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/Review_Model.dart';
import 'review.dart';

class ReviewForm extends StatefulWidget {
  final String productId;

  const ReviewForm({super.key, required this.productId});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (_rating == 0 || _controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide both rating and comment")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final review = Review(
      id: '',
      productId: widget.productId,
      stars: _rating,
      review: _controller.text.trim(),
      name: "Anonymous",
      date: DateTime.now(),
    );

    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        ...review.toMap(),
        'date': FieldValue.serverTimestamp(), // Let Firestore set accurate time
      });

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 40),
              SizedBox(height: 10),
              Text("Review Submitted", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit review. Try again later.")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("What is your rate?", style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Please share your opinion about the product',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF02B91A),
              ),
              onPressed: _isSubmitting ? null : _submitReview,
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'SEND REVIEW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
