import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panchikawaththa/models/cart_item_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  List<bool> selectedItems = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: user.uid)
        .get();

    final items = snapshot.docs.map((doc) {
      return CartItem.fromMap(doc.id, doc.data());
    }).toList();

    setState(() {
      cartItems = items;
      selectedItems = List<bool>.filled(items.length, false);
      updateTotal();
    });
  }

  void updateTotal() {
    total = 0;
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) {
        total += cartItems[i].price * cartItems[i].quantity;
      }
    }
    setState(() {});
  }

  Future<void> updateQuantity(CartItem item, int newQty) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(item.id)
        .update({'quantity': newQty});
    fetchCartItems();
  }

  Future<void> deleteSelectedItems() async {
    final itemsToDelete = <String>[];

    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) {
        itemsToDelete.add(cartItems[i].id);
      }
    }

    for (final id in itemsToDelete) {
      await FirebaseFirestore.instance.collection('cart').doc(id).delete();
    }

    await fetchCartItems(); // Refresh after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text('My Cart',
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await deleteSelectedItems();
                  },
                  child: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Checkbox(
                  value: selectedItems.isNotEmpty &&
                      selectedItems.every((item) => item),
                  onChanged: (value) {
                    setState(() {
                      selectedItems =
                          List.filled(selectedItems.length, value ?? false);
                      updateTotal();
                    });
                  },
                ),
                Text("Select all", style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedItems[index],
                          onChanged: (value) {
                            setState(() {
                              selectedItems[index] = value!;
                              updateTotal();
                            });
                          },
                        ),
                        Image.memory(
                          base64Decode(item.imageBase64),
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp)),
                              SizedBox(height: 4.h),
                              Text(
                                  'LKR ${(item.price * item.quantity).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: const Color(0xFF02B91A))),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item.quantity > 1) {
                                  updateQuantity(item, item.quantity - 1);
                                }
                              },
                              child: const Icon(Icons.remove_circle_outline),
                            ),
                            SizedBox(width: 6.w),
                            Text(item.quantity.toString()),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {
                                updateQuantity(item, item.quantity + 1);
                              },
                              child: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment processing...')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF02B91A),
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Pay Now\nLKR ${total.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
