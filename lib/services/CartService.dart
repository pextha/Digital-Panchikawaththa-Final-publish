import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(CartItem item) async {
    await _firestore.collection('cart').add(item.toMap());
  }

  Future<List<CartItem>> getUserCartItems(String userId) async {
    final snapshot = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => CartItem.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> updateCartItemQuantity(String id, int quantity) async {
    await _firestore.collection('cart').doc(id).update({'quantity': quantity});
  }

  Future<void> removeCartItem(String id) async {
    await _firestore.collection('cart').doc(id).delete();
  }
}
