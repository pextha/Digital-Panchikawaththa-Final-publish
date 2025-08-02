import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/Product_Model.dart';

class OrderConfirmationPage extends StatefulWidget {
  final Product product;

  const OrderConfirmationPage({Key? key, required this.product})
      : super(key: key);

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  int quantity = 1;

  double get total => (widget.product.price ?? 0.0) * quantity;

  Uint8List _decodeImage(List<String>? imageList) {
    if (imageList == null || imageList.isEmpty) return Uint8List(0);
    final imageStr = imageList.first;
    try {
      if (imageStr.startsWith('data:image')) {
        return Uri.parse(imageStr).data!.contentAsBytes();
      } else {
        return base64Decode(imageStr);
      }
    } catch (e) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProductCard(product),
            SizedBox(height: 16),
            _buildAddressSection(),
            SizedBox(height: 16),
            _buildPaymentSection(),
            SizedBox(height: 16),
            _buildSummarySection(product),
            SizedBox(height: 16),
            _buildTotalSection(),
            SizedBox(height: 20),
            _buildPayNowButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.sellerId ?? 'Unknown Seller',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(
                    _decodeImage(product.imageBase64),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? 'Unnamed Product',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            _buildCounterButton(Icons.remove, () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            }),
                            SizedBox(width: 5),
                            Text(quantity.toString()),
                            SizedBox(width: 5),
                            _buildCounterButton(Icons.add, () {
                              setState(() {
                                quantity++;
                              });
                            }),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Free Shipping',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Delivery : Oct 28 - 30',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.edit, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildAddressSection() {
    return _buildInfoCard(
      title: 'Address',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('janith chamuditha +94 0769767966'),
          Text('No 34, Dematagoda , Maradana'),
          Text('Colombo, Western, Sri Lanka ,10300'),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return _buildInfoCard(
      title: 'Payment method',
      content: Row(
        children: const [
          Icon(Icons.credit_card, size: 24),
          SizedBox(width: 10),
          Text('4216 67** **** 3456',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSummarySection(Product product) {
    final subtotal = (product.price ?? 0.0) * quantity;

    return _buildInfoCard(
      title: 'Summary',
      content: Column(
        children: [
          _buildRowText('Subtotal', 'LKR ${subtotal.toStringAsFixed(2)}'),
          Divider(),
          _buildRowText('Promo codes', 'Enter', isLink: true),
          Divider(),
          _buildRowText('Shipping fee', 'Free'),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total :',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(
          'LKR ${total.toStringAsFixed(2)}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red[900]),
        ),
      ],
    );
  }

  Widget _buildPayNowButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle payment logic here
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Payment processing...'),
          ));
        },
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: Color(0xFF01B919),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          child: Text(
            'Pay now',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget content}) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildRowText(String left, String right, {bool isLink = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: TextStyle(color: Colors.black54)),
        Text(
          right,
          style: TextStyle(
            color: isLink ? Colors.blue : Colors.black,
            fontWeight: isLink ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
