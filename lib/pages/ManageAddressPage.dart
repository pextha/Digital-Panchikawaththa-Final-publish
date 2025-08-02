import 'package:flutter/material.dart';
import 'package:panchikawaththa/pages/Edit_Address.dart';

class ManageAddressPage extends StatefulWidget {
  const ManageAddressPage({super.key});

  @override
  State<ManageAddressPage> createState() => _ManageAddressPageState();
}

class _ManageAddressPageState extends State<ManageAddressPage> {
  final List<Map<String, String>> _addresses = [
    {
      'name': 'Home',
      'details': '123 Main Street, Springfield, IL',
    },
    {
      'name': 'Work',
      'details': '456 Corporate Blvd, Metropolis, NY',
    },
  ];

  void _addNewAddress() async {
    final newAddress = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddEditAddressDialog(),
    );
    if (newAddress != null) {
      setState(() {
        _addresses.add(newAddress);
      });
    }
  }

  void _editAddress(int index) async {
    final updated = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AddEditAddressDialog(address: _addresses[index]),
    );
    if (updated != null) {
      setState(() {
        _addresses[index] = updated;
      });
    }
  }

  void _deleteAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Address")),
      body: ListView.builder(
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return ListTile(
            title: Text(address['name']!),
            subtitle: Text(address['details']!),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editAddress(index);
                } else if (value == 'delete') {
                  _deleteAddress(index);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAddress,
        backgroundColor: Color(0xFF02B91A),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Address',
      ),
    );
  }
}
