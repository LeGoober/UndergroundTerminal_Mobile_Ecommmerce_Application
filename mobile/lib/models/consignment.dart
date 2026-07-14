class ConsignmentEvent {
  final String status;
  final String? note;
  final DateTime timestamp;

  ConsignmentEvent({
    required this.status,
    this.note,
    required this.timestamp,
  });

  factory ConsignmentEvent.fromJson(Map<String, dynamic> json) {
    return ConsignmentEvent(
      status: json['status'] ?? '',
      note: json['note'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

class Consignment {
  static const List<String> statusFlow = [
    'PREPARING',
    'IN_TRANSIT',
    'CUSTOMS',
    'DELIVERED',
  ];

  final int id;
  final String reference;
  final int orderId;
  final String? buyerName;
  final String origin;
  final String destination;
  final String status;
  final DateTime? eta;
  final DateTime createdAt;
  final List<ConsignmentEvent> events;

  Consignment({
    required this.id,
    required this.reference,
    required this.orderId,
    this.buyerName,
    required this.origin,
    required this.destination,
    required this.status,
    this.eta,
    required this.createdAt,
    required this.events,
  });

  factory Consignment.fromJson(Map<String, dynamic> json) {
    return Consignment(
      id: json['id'] ?? 0,
      reference: json['reference'] ?? '',
      orderId: json['orderId'] ?? 0,
      buyerName: json['buyerName'],
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      status: json['status'] ?? 'PREPARING',
      eta: json['eta'] != null ? DateTime.tryParse(json['eta']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      events: (json['events'] as List<dynamic>? ?? [])
          .map((e) => ConsignmentEvent.fromJson(e))
          .toList(),
    );
  }

  bool get isDelivered => status == 'DELIVERED';

  /// The next status in the standard flow, or null if terminal.
  String? get nextStatus {
    final index = statusFlow.indexOf(status);
    if (index < 0 || index >= statusFlow.length - 1) return null;
    return statusFlow[index + 1];
  }
}
