import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Your Email',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 184, 196, 184)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 167, 182, 167)),
                ),
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 167, 182, 167)),
              ),
              cursorColor: Colors.green,
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Your Message',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 167, 182, 167)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 167, 182, 167)),
                ),
                labelStyle:
                    TextStyle(color: const Color.fromARGB(255, 167, 182, 167)),
              ),
              cursorColor: Colors.green,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white, // Set text color to white
              ),
              onPressed: () {},
              child: const Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
