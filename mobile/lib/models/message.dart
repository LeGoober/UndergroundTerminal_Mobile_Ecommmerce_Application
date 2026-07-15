class Message {
  final int id;
  final int senderId;
  final String senderName;
  final int recipientId;
  final String recipientName;
  final String content;
  final DateTime sentAt;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.recipientName,
    required this.content,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      senderId: json['senderId'] ?? 0,
      senderName: json['senderName'] ?? '',
      recipientId: json['recipientId'] ?? 0,
      recipientName: json['recipientName'] ?? '',
      content: json['content'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// The other party in this message relative to [userId].
  int partnerId(int userId) => senderId == userId ? recipientId : senderId;

  String partnerName(int userId) => senderId == userId ? recipientName : senderName;
}
