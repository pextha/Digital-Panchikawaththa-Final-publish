import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AddNewCardPage());
}

class AddNewCardPage extends StatelessWidget {
  const AddNewCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AddCardScreen(),
    );
  }
}

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expirationController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Add New Card",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit Card Preview
            Center(
              child: Container(
                width: 310,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFF4C4E6E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Card background elements
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card dots
                          Row(
                            children: List.generate(
                              4,
                              (index) => Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Card chip
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB236),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  padding: const EdgeInsets.all(4),
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  children: List.generate(
                                    6,
                                    (index) => Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFCC80),
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Contactless icon
                              Icon(
                                Icons.wifi,
                                color: Colors.white.withOpacity(0.7),
                                size: 28,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Card number
                          const Text(
                            "0000 0000 0000 0000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Card holder and expiry
                          Row(
                            children: [
                              Container(
                                width: 120,
                                height: 2,
                                color: Colors.white,
                              ),
                              const Spacer(),
                              Container(
                                width: 20,
                                height: 2,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 20,
                                height: 2,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Card Number Field
            const Text(
              "Card Number",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                hintText: "XXXX XXXX XXXX XXXX",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  letterSpacing: 1,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberFormatter(),
              ],
            ),

            const SizedBox(height: 20),

            // Card Name Field
            const Text(
              "Card Name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cardNameController,
              decoration: InputDecoration(
                hintText: "Name on Card", // <-- Added placeholder
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 20),

            // Expiration Date and CVV Fields
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expiration Date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _expirationController,
                        decoration: InputDecoration(
                          hintText: "MM/YY", // <-- Added placeholder
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _ExpirationDateFormatter(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CVV",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cvvController,
                        decoration: InputDecoration(
                          hintText: "CVV", // <-- Added placeholder
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[300],
            ),

            const SizedBox(height: 30),

            // Add Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Show success popup
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Success!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          "Your card has been added successfully.",
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text("OK"),
                            ),
                          ),
                        ],
                        actionsPadding: EdgeInsets.all(16),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom text input formatter for credit card number
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String text = newValue.text.replaceAll(' ', '');
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Custom text input formatter for expiration date
class _ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String text = newValue.text.replaceAll('/', '');
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 2 && text.length > 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
