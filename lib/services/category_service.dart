import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();

      return snapshot.docs.map((doc) {
        return Category.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
