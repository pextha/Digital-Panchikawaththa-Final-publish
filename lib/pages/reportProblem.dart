import 'package:flutter/material.dart';

class ReportProblemPage extends StatelessWidget {
  const ReportProblemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Report a Problem")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Describe the issue you encountered:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your problem...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Submit logic here
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted.')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF02B91A),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
