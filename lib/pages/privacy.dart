import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 16),
              Text(
                "Last updated: May 18, 2025\n\n"
                "We value your privacy and are committed to protecting your personal data. "
                "This privacy policy describes how we collect, use, and share information "
                "when you use our app.\n\n"
                "1. Information We Collect:\n"
                "- Personal Information (e.g., name, email address)\n"
                "- Usage Data (e.g., app interactions, crash logs)\n\n"
                "2. How We Use Your Information:\n"
                "- To provide and maintain our service\n"
                "- To improve our application and user experience\n"
                "- To send you updates or notifications\n\n"
                "3. Data Sharing:\n"
                "- We do not sell or share your personal data with third parties "
                "except as required by law or with your consent.\n\n"
                "4. Security:\n"
                "- We use secure methods to store and process your data, "
                "but no method is 100% secure.\n\n"
                "5. Your Rights:\n"
                "- You may request to review, update, or delete your personal information.\n\n"
                "6. Changes to This Policy:\n"
                "- We may update our privacy policy periodically. Any changes will be posted here.\n\n"
                "If you have any questions about this Privacy Policy, please contact us.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
