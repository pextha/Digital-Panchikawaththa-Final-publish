import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProductsPage extends StatelessWidget {
  const UserProductsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchUserProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUserProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products'));
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products added yet.'));
          }

          return ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final product = products[index];
              final List images = product['imageBase64'] ?? [];
              Uint8List? imageBytes;
              if (images.isNotEmpty) {
                try {
                  imageBytes = base64Decode(images.first);
                } catch (_) {}
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: imageBytes != null
                      ? Image.memory(imageBytes, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 50),
                  title: Text(product['name'] ?? 'No Name'),
                  subtitle: Text(product['description'] ?? ''),
                  trailing: Text('Rs. ${product['price'] ?? '0.00'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
