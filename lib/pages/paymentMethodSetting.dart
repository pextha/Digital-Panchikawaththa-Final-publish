import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  List<Map<String, String>> _cards = [
    {
      'type': 'Visa',
      'number': '**** **** **** 1234',
      'expiry': '04/26',
    },
    {
      'type': 'Mastercard',
      'number': '**** **** **** 5678',
      'expiry': '11/25',
    },
  ];

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  void _showAddCardDialog() {
    _cardNumberController.clear();
    _expiryController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Card"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Card Number",
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _expiryController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: "Expiry Date (MM/YY)",
                prefixIcon: Icon(Icons.date_range),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              if (_cardNumberController.text.isNotEmpty &&
                  _expiryController.text.isNotEmpty) {
                setState(() {
                  _cards.add({
                    'type': 'Custom',
                    'number':
                        '**** **** **** ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}',
                    'expiry': _expiryController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add Card"),
          ),
        ],
      ),
    );
  }

  void _showCardOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Card"),
              onTap: () {
                Navigator.pop(context);
                // You could implement editing logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Remove Card"),
              onTap: () {
                setState(() {
                  _cards.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.green),
              title: Text(card['number'] ?? ''),
              subtitle: Text('Expires ${card['expiry']}'),
              trailing: const Icon(Icons.more_vert),
              onTap: () => _showCardOptions(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _showAddCardDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
