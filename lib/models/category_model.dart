class Category {
  final String id;
  final String name;
  final String imageBase64;

  Category({
    required this.id,
    required this.name,
    required this.imageBase64,
  });

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId,
      name: data['name'] ?? '',
      imageBase64: data['imageBase64'] ?? '',
    );
  }
}
