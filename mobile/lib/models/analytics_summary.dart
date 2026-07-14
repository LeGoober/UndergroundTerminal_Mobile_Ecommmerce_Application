class DayOrders {
  final String date;
  final int orders;

  DayOrders({required this.date, required this.orders});

  factory DayOrders.fromJson(Map<String, dynamic> json) {
    return DayOrders(
      date: json['date'] ?? '',
      orders: json['orders'] ?? 0,
    );
  }
}

class StockEntry {
  final String name;
  final int stockLevel;

  StockEntry({required this.name, required this.stockLevel});

  factory StockEntry.fromJson(Map<String, dynamic> json) {
    return StockEntry(
      name: json['name'] ?? '',
      stockLevel: json['stockLevel'] ?? 0,
    );
  }
}

class AnalyticsSummary {
  final int totalProducts;
  final int totalStockUnits;
  final int lowStockCount;
  final int totalOrders;
  final double totalRevenue;
  final int activeConsignments;
  final List<DayOrders> ordersByDay;
  final List<StockEntry> topStock;

  AnalyticsSummary({
    required this.totalProducts,
    required this.totalStockUnits,
    required this.lowStockCount,
    required this.totalOrders,
    required this.totalRevenue,
    required this.activeConsignments,
    required this.ordersByDay,
    required this.topStock,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      totalProducts: json['totalProducts'] ?? 0,
      totalStockUnits: json['totalStockUnits'] ?? 0,
      lowStockCount: json['lowStockCount'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      activeConsignments: json['activeConsignments'] ?? 0,
      ordersByDay: (json['ordersByDay'] as List<dynamic>? ?? [])
          .map((d) => DayOrders.fromJson(d))
          .toList(),
      topStock: (json['topStock'] as List<dynamic>? ?? [])
          .map((s) => StockEntry.fromJson(s))
          .toList(),
    );
  }
}
