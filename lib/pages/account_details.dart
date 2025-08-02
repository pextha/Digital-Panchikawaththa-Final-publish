import 'package:flutter/material.dart';
import 'package:panchikawaththa/pages/help_center_page.dart';
import 'package:panchikawaththa/pages/login_page.dart';
import 'package:panchikawaththa/pages/return_details_page.dart';
import 'package:panchikawaththa/pages/save_card_page.dart';
import 'package:panchikawaththa/pages/setting_page.dart';
import 'package:panchikawaththa/pages/store_coupon_page.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});
  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: Colors.black87),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
          SizedBox(width: 16),
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 80, 192, 84),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'DigitalPanchikawatta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.black,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text('Sign in/ Register'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/mario.png',
                    height: 130,
                    width: 130,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(
              height: 2,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black12,
            ),
            Divider(
              height: 2,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AccountOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.black87),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
