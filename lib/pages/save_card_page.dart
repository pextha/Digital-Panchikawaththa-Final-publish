import 'package:flutter/material.dart';
import 'package:panchikawaththa/pages/add_new_card_page.dart';

class SavedCardsPage extends StatelessWidget {
  SavedCardsPage({super.key});

  final List<Map<String, String>> cards = [
    {
      "cardHolder": "Pathum Theekshana",
      "cardNumber": "**** **** **** 1234",
      "expiry": "08/27",
      "brand": "Visa"
    },
    {
      "cardHolder": "Imesh Naveen",
      "cardNumber": "**** **** **** 5678",
      "expiry": "11/26",
      "brand": "MasterCard"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Saved Cards")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.shade700,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(blurRadius: 6, color: Colors.grey.shade400)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(card["brand"]!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    Icon(Icons.more_vert, color: Colors.white.withOpacity(0.7)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(card["cardNumber"]!,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, letterSpacing: 2)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Card Holder",
                        style: TextStyle(color: Colors.white.withOpacity(0.7))),
                    Text("Expires",
                        style: TextStyle(color: Colors.white.withOpacity(0.7))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(card["cardHolder"]!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(card["expiry"]!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 26, 27, 27),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewCardPage()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Card"),
          ),
        ),
      ),
    );
  }
}
