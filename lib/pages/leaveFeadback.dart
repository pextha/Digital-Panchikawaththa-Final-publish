import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LeaveFeedbackPage extends StatefulWidget {
  const LeaveFeedbackPage({super.key});

  @override
  State<LeaveFeedbackPage> createState() => _LeaveFeedbackPageState();
}

class _LeaveFeedbackPageState extends State<LeaveFeedbackPage> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    final feedback = _feedbackController.text;

    if (_rating == 0 || feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and feedback.")),
      );
      return;
    }

    // Process the feedback here (e.g., send to server)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );

    _feedbackController.clear();
    setState(() {
      _rating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rate our app:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              glow: false,
              unratedColor: Colors.grey.shade300,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.green,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              cursorColor: Colors.green,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: _submitFeedback,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
