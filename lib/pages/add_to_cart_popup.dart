import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/Product_Model.dart';

class CartPopupContent extends StatefulWidget {
  final Product? product;

  const CartPopupContent({super.key, required this.product});

  @override
  State<CartPopupContent> createState() => _CartPopupContentState();
}

class _CartPopupContentState extends State<CartPopupContent> {
  int quantity = 1;
  bool isLoading = false;

  void addToCart() async {
    if (widget.product == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance.collection('cart').add({
        'userId': user.uid,
        'productId': widget.product!.id,
        'name': widget.product!.name,
        'price': widget.product!.price,
        'imageBase64': widget.product!.imageBase64.first,
        'quantity': quantity,
        'dateAdded': Timestamp.now(),
      });

      if (mounted) {
        Navigator.pop(context); // Close popup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added to cart")),
        );
      }
    } catch (e) {
      print("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add to cart: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    if (product == null) {
      return const Center(child: Text("Product not available."));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Add to Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: product.imageBase64.isNotEmpty
              ? Image.memory(
                  base64Decode(product.imageBase64.first),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image),
          title: Text(product.name),
          subtitle: Text('LKR ${product.price.toStringAsFixed(2)}'),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
            IconButton(
              onPressed: () => setState(() => quantity++),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text("Confirm Add to Cart",
                    style: TextStyle(color: Colors.white)),
              ),
        const SizedBox(height: 16),
      ],
    );
  }
}
