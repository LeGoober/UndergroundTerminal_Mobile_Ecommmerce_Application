class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImageUrl;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      productImageUrl: json['productImageUrl'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
    );
  }
}

class Order {
  final int id;
  final int buyerId;
  final String buyerName;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      buyerId: json['buyerId'] ?? 0,
      buyerName: json['buyerName'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((i) => OrderItem.fromJson(i))
          .toList(),
      total: (json['total'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'PLACED',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
