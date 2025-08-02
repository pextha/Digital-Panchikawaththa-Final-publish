import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panchikawaththa/models/category_model.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  final TextEditingController _categoryController = TextEditingController();
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _addCategory() async {
    String name = _categoryController.text.trim();

    if (name.isEmpty || _base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and select image')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'name': name,
        'imageBase64': _base64Image,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context); // Close loading dialog

      _categoryController.clear();
      setState(() {
        _base64Image = null;
      });
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully')),
      );

      // ✅ Do not navigate or pop the page
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add category: $e')),
      );
    }
  }

  Future<void> _editCategory(
      String id, String currentName, String currentImage) async {
    TextEditingController editNameController =
        TextEditingController(text: currentName);
    String? newBase64Image = currentImage;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          Future<void> _pickImageDialog() async {
            final XFile? pickedFile = await _picker.pickImage(
                source: ImageSource.gallery, imageQuality: 70);
            if (pickedFile != null) {
              final bytes = await pickedFile.readAsBytes();
              setStateDialog(() {
                newBase64Image = base64Encode(bytes);
              });
            }
          }

          return AlertDialog(
            title: const Text('Edit Category'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editNameController,
                    decoration:
                        const InputDecoration(labelText: 'Category Name'),
                  ),
                  const SizedBox(height: 12),
                  newBase64Image!.isNotEmpty
                      ? Image.memory(
                          base64Decode(newBase64Image!),
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : const Text('No image selected'),
                  TextButton.icon(
                    onPressed: _pickImageDialog,
                    icon: const Icon(Icons.image),
                    label: const Text('Change Image'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String newName = editNameController.text.trim();
                  if (newName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name cannot be empty')),
                    );
                    return;
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(id)
                        .update({
                      'name': newName,
                      'imageBase64': newBase64Image,
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category updated')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Update failed: $e')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration:
                        const InputDecoration(labelText: 'New Category'),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _base64Image == null
                        ? const Icon(Icons.image, color: Colors.grey)
                        : Image.memory(
                            base64Decode(_base64Image!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final categories = snapshot.data!.docs
                    .map(
                      (doc) => Category.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id),
                    )
                    .toList();

                if (categories.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      leading: category.imageBase64.isNotEmpty
                          ? Image.memory(
                              base64Decode(category.imageBase64),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.category),
                      title: Text(category.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editCategory(
                              category.id,
                              category.name,
                              category.imageBase64,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
