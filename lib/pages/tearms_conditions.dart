import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Conditions")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 16),
              Text(
                "Last updated: May 18, 2025\n\n"
                "Please read these Terms and Conditions (\"Terms\", \"Terms and Conditions\") carefully before using our mobile application.\n\n"
                "1. Acceptance of Terms\n"
                "By accessing or using the app, you agree to be bound by these Terms. If you disagree with any part of the terms, you may not access the service.\n\n"
                "2. Use of the App\n"
                "- You must be at least 13 years old to use this app.\n"
                "- You agree not to misuse the app, disrupt its operation, or attempt unauthorized access.\n\n"
                "3. Intellectual Property\n"
                "All content, design, logos, and features are the property of the app developers and protected by copyright and trademark laws.\n\n"
                "4. Termination\n"
                "We may terminate or suspend access to the app immediately, without prior notice, for any reason, including a breach of the Terms.\n\n"
                "5. Limitation of Liability\n"
                "We are not liable for any damages or losses resulting from the use of the app. Use it at your own risk.\n\n"
                "6. Changes to the Terms\n"
                "We reserve the right to update these Terms at any time. Changes will be effective once posted on this page.\n\n"
                "7. Contact Us\n"
                "If you have any questions about these Terms, please contact us through the 'Contact Us' page in the app.\n\n"
                "Thank you for using our application.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
