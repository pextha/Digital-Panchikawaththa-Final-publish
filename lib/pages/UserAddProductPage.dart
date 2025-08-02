import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawaththa/main.dart';

class UserAddProductPage extends StatefulWidget {
  const UserAddProductPage({super.key});

  @override
  State<UserAddProductPage> createState() => _UserAddProductPageState();
}

class _UserAddProductPageState extends State<UserAddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String _name = '';
  String _description = '';
  String _price = '';
  String _stock = '';
  String _category = '';
  List<String> _base64Images = [];

  List<String> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      final fetched =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _categories = fetched;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading categories: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    if (_base64Images.length >= 3) return;
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _base64Images.add(base64Encode(bytes));
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final userId = _auth.currentUser?.uid ?? '';
    final product = {
      'name': _name,
      'description': _description,
      'price': double.parse(_price),
      'stock': int.parse(_stock),
      'category': _category,
      'imageBase64': _base64Images,
      'sellerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      final doc = await _firestore.collection('products').add(product);
      await doc.update({'id': doc.id});

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Product added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthWrapper(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Product',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF02B91A),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Product Name"),
                    _buildTextField("Enter product name",
                        onSave: (val) => _name = val!),
                    _space(),
                    _buildLabel("Description"),
                    _buildTextField("Enter description",
                        maxLines: 3, onSave: (val) => _description = val ?? ''),
                    _space(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Price (LKR)"),
                              _buildTextField(
                                "0.00",
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    double.tryParse(val!) == null
                                        ? "Invalid"
                                        : null,
                                onSave: (val) => _price = val!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Stock"),
                              _buildTextField(
                                "0",
                                keyboardType: TextInputType.number,
                                validator: (val) => int.tryParse(val!) == null
                                    ? "Invalid"
                                    : null,
                                onSave: (val) => _stock = val!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _space(),
                    _buildLabel("Category"),
                    DropdownButtonFormField<String>(
                      value: _categories.contains(_category) ? _category : null,
                      items: _categories
                          .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty
                          ? "Select a category"
                          : null,
                      onChanged: (val) => setState(() => _category = val ?? ''),
                      onSaved: (val) => _category = val ?? '',
                    ),
                    _space(),
                    _buildLabel("Images (up to 3)"),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ..._base64Images.asMap().entries.map(
                              (entry) => Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: MemoryImage(
                                            base64Decode(entry.value)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _base64Images.removeAt(entry.key)),
                                      child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.close,
                                            size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        if (_base64Images.length < 3)
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Icon(Icons.add_a_photo,
                                  color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        label: const Text(
                          "Submit Product",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02B91A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget _buildTextField(String hint,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator,
      void Function(String?)? onSave}) {
    return TextFormField(
      decoration:
          InputDecoration(hintText: hint, border: const OutlineInputBorder()),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator ?? (val) => val!.isEmpty ? "Required" : null,
      onSaved: onSave,
    );
  }

  SizedBox _space() => const SizedBox(height: 15);
}
