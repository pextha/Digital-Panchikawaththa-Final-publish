import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecentPurchasesPage extends StatefulWidget {
  const RecentPurchasesPage({Key? key}) : super(key: key);

  @override
  State<RecentPurchasesPage> createState() => _RecentPurchasesPageState();
}

class _RecentPurchasesPageState extends State<RecentPurchasesPage> {
  late final String userId;
  bool isLoading = true;
  List<Map<String, dynamic>> purchases = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    fetchPurchases();
  }

  Future<void> fetchPurchases() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('purchases')
          .orderBy('date',
              descending: true) // assuming you store a timestamp field 'date'
          .get();

      setState(() {
        purchases = snapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load purchases: $e";
        isLoading = false;
      });
    }
  }

  Widget _buildPurchaseItem(Map<String, dynamic> purchase) {
    final String itemName = purchase['itemName'] ?? 'Unnamed Item';
    final int quantity = purchase['quantity'] ?? 1;
    final double price = (purchase['price'] ?? 0).toDouble();
    final double total = (purchase['total'] ?? price * quantity).toDouble();
    final String status = purchase['status'] ?? 'Pending';
    final String imageUrl = purchase['imageUrl'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              )
            : const Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
        title:
            Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text('Quantity: $quantity\nTotal: Rs. ${total.toStringAsFixed(2)}'),
        trailing: Text(
          status,
          style: TextStyle(
            color: status.toLowerCase() == 'delivered'
                ? Colors.green
                : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Purchases'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : purchases.isEmpty
                  ? const Center(child: Text('No recent purchases found.'))
                  : ListView.builder(
                      itemCount: purchases.length,
                      itemBuilder: (context, index) {
                        return _buildPurchaseItem(purchases[index]);
                      },
                    ),
    );
  }
}
