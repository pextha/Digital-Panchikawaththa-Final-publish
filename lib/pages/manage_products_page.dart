import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _base64Images = [];
  List<String> _categories = [];
  bool _isCategoryLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      final categoryList = snapshot.docs
          .map((doc) => doc['name'].toString())
          .where((name) => name.isNotEmpty)
          .toList();
      setState(() {
        _categories = categoryList;
        _isCategoryLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() => _isCategoryLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final doc = products[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: data['imageBase64'] != null &&
                        (data['imageBase64'] as List).isNotEmpty
                    ? Image.memory(
                        base64Decode((data['imageBase64'] as List).first),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      )
                    : const Icon(Icons.image),
                title: Text(data['name'] ?? 'No name'),
                subtitle: Text(
                    "LKR ${data['price']?.toString() ?? '0.00'} | Stock: ${data['stock']?.toString() ?? '0'}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          _showProductDialog(context, doc.id, data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(doc.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context, null, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }

  void _showProductDialog(
      BuildContext context, String? id, Map<String, dynamic>? data) {
    final _formKey = GlobalKey<FormState>();
    String name = data?['name'] ?? '';
    String category = data?['category'] ?? '';
    String description = data?['description'] ?? '';
    String price = data?['price']?.toString() ?? '';
    String stock = data?['stock']?.toString() ?? '';
    _base64Images = data != null && data['imageBase64'] != null
        ? List<String>.from(data['imageBase64'])
        : [];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              padding: const EdgeInsets.all(20),
              width: 300,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text('Add Product',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: name,
                        decoration:
                            const InputDecoration(labelText: 'Product Name'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter name'
                            : null,
                        onSaved: (value) => name = value!.trim(),
                      ),
                      TextFormField(
                        initialValue: description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        onSaved: (value) => description = value?.trim() ?? '',
                      ),
                      TextFormField(
                        initialValue: price,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || double.tryParse(value) == null
                                ? 'Enter valid price'
                                : null,
                        onSaved: (value) => price = value!.trim(),
                      ),
                      TextFormField(
                        initialValue: stock,
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || int.tryParse(value) == null
                                ? 'Enter valid stock'
                                : null,
                        onSaved: (value) => stock = value!.trim(),
                      ),
                      const SizedBox(height: 10),
                      const Text('Category', style: TextStyle(fontSize: 12)),
                      _isCategoryLoading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButtonFormField<String>(
                              value: _categories.contains(category)
                                  ? category
                                  : null,
                              decoration:
                                  const InputDecoration(labelText: 'Category'),
                              items: _categories
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ))
                                  .toList(),
                              onChanged: (value) => category = value ?? '',
                              onSaved: (value) => category = value ?? '',
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please select a category'
                                      : null,
                            ),
                      const SizedBox(height: 10),
                      const Text('Images (up to 3)',
                          style: TextStyle(fontSize: 12)),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ..._base64Images.asMap().entries.map((entry) {
                              int index = entry.key;
                              String base64 = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Stack(
                                  children: [
                                    Image.memory(
                                      base64Decode(base64),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _base64Images.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close,
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            if (_base64Images.length < 3)
                              GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 70);
                                  if (pickedFile != null) {
                                    final bytes =
                                        await pickedFile.readAsBytes();
                                    setState(() {
                                      _base64Images.add(base64Encode(bytes));
                                    });
                                  }
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.add_a_photo),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                final userId =
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        '';

                                final product = {
                                  'name': name,
                                  'description': description,
                                  'price': double.parse(price),
                                  'stock': int.parse(stock),
                                  'category': category,
                                  'imageBase64': _base64Images,
                                  'sellerId': userId,
                                };

                                try {
                                  if (id == null) {
                                    final docRef = await _firestore
                                        .collection('products')
                                        .add(product);
                                    await docRef.update({'id': docRef.id});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Product added')));
                                  } else {
                                    await _firestore
                                        .collection('products')
                                        .doc(id)
                                        .update(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Product updated')));
                                  }
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to save product: $e')));
                                }
                              }
                            },
                            child: Text(id == null ? 'Add' : 'Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
        _base64Images = [];
      });
    });
  }
}
