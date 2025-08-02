import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Arabic',
    'Hindi',
    'Japanese',
  ];

  void _changeLanguage(String? newLang) {
    if (newLang != null) {
      setState(() {
        _selectedLanguage = newLang;
      });

      // Logic: you can save the selection to shared preferences or localization provider here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $newLang'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Preferred Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              icon: const Icon(Icons.language),
              items: _languages
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: _changeLanguage,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Save setting if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language saved successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                "Save Language",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
