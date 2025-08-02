import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches all products from Firestore.
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure the data includes the document ID
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error fetching products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching products: $e');
    }
  }

  /// Fetches products by category.
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(
          'Firebase error fetching products by category: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching products by category: $e');
    }
  }

  /// Adds a new product to Firestore.
  Future<void> addProduct(Product product) async {
    try {
      final docRef =
          await _firestore.collection('products').add(product.toJson());
      // Update the document with its own ID
      await docRef.update({'id': docRef.id});
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding product: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding product: $e');
    }
  }

  /// Updates an existing product in Firestore.
  Future<void> updateProduct(String productId, Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update(product.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating product: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating product: $e');
    }
  }

  /// Deletes a product from Firestore.
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting product: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting product: $e');
    }
  }

  /// Fetches a single product by its ID.
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      return Product.fromJson(data);
    } on FirebaseException catch (e) {
      throw Exception('Firebase error fetching product by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching product by ID: $e');
    }
  }
}
