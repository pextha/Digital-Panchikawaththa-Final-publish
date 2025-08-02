class CartItem {
  final String id;
  final String userId;
  final String productId;
  final String name;
  final double price;
  final String imageBase64;
  final int quantity;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageBase64,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'name': name,
      'price': price,
      'imageBase64': imageBase64,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(String id, Map<String, dynamic> map) {
    return CartItem(
      id: id,
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageBase64: map['imageBase64'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }
}
