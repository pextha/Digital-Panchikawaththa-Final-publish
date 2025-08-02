import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'manage_categories_page.dart';
import 'manage_products_page.dart'; // You need to create this page
import 'login_page.dart'; // Update this to your actual login page

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  void _logoutAndRestart(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logoutAndRestart(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.category,
              label: 'Manage Categories',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageCategoriesPage(),
                  ),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.shopping_bag,
              label: 'Manage Products',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageProductsPage(),
                  ),
                );
              },
            ),
            // Add more cards here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.green),
              const SizedBox(height: 12),
              Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
