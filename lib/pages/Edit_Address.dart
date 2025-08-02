import 'package:flutter/material.dart';

class AddEditAddressDialog extends StatefulWidget {
  final Map<String, String>? address;

  const AddEditAddressDialog({super.key, this.address});

  @override
  State<AddEditAddressDialog> createState() => _AddEditAddressDialogState();
}

class _AddEditAddressDialogState extends State<AddEditAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _nameController.text = widget.address!['name']!;
      _detailsController.text = widget.address!['details']!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': _nameController.text,
        'details': _detailsController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;
    return AlertDialog(
      title: Text(isEditing ? "Edit Address" : "Add Address"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Label (e.g. Home)"),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a label' : null,
            ),
            TextFormField(
              controller: _detailsController,
              decoration:
                  const InputDecoration(labelText: "Full Address Details"),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter the address' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: _submit, child: Text(isEditing ? "Update" : "Add")),
      ],
    );
  }
}
