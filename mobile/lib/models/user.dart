enum UserRole { supplier, buyer, designer }

class User {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String? imageUrl;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: _parseUserRole(json['role'] ?? 'buyer'),
      imageUrl: json['imageUrl'],
      bio: json['bio'],
    );
  }

  static UserRole _parseUserRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'supplier':
        return UserRole.supplier;
      case 'designer':
        return UserRole.designer;
      case 'buyer':
      default:
        return UserRole.buyer;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'imageUrl': imageUrl,
      'bio': bio,
    };
  }

  bool get isSupplier => role == UserRole.supplier;
  bool get isBuyer => role == UserRole.buyer;
  bool get isDesigner => role == UserRole.designer;
}
