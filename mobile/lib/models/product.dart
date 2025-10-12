class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final int supplierId;
  final String? description;
  final int? stockLevel;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.supplierId,
    this.description,
    this.stockLevel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      supplierId: json['supplierId'] ?? 0,
      description: json['description'],
      stockLevel: json['stockLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'supplierId': supplierId,
      'description': description,
      'stockLevel': stockLevel,
    };
  }
}
