import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/analytics_summary.dart';
import '../models/consignment.dart';
import '../models/message.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';

class ApiService {
  /// Use the configurable base URL from [ApiConfig].
  /// Override at app startup: ApiConfig.init(customUrl: 'https://...');
  static String get baseUrl => ApiConfig.baseUrl;

  /// Headers for authenticated endpoints, using the stored JWT.
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Never _throwApiError(http.Response response, String fallback) {
    try {
      final body = json.decode(response.body);
      throw Exception(body['error'] ?? '$fallback: ${response.statusCode}');
    } on FormatException {
      throw Exception('$fallback: ${response.statusCode}');
    }
  }

  // ---- Orders API ----

  /// Places an order; [items] is a list of {'productId': x, 'quantity': y}.
  Future<Order> placeOrder(List<Map<String, dynamic>> items) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: await _authHeaders(),
      body: json.encode({'items': items}),
    );
    if (response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    }
    _throwApiError(response, 'Failed to place order');
  }

  Future<List<Order>> getMyOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/mine'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((o) => Order.fromJson(o))
          .toList();
    }
    _throwApiError(response, 'Failed to load orders');
  }

  // ---- Consignments (logistics) API ----

  Future<List<Consignment>> getMyConsignments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/consignments/mine'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((c) => Consignment.fromJson(c))
          .toList();
    }
    _throwApiError(response, 'Failed to load consignments');
  }

  Future<Consignment> advanceConsignmentStatus(
    int consignmentId,
    String status, {
    String? note,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/consignments/$consignmentId/status'),
      headers: await _authHeaders(),
      body: json.encode({'status': status, 'note': note}),
    );
    if (response.statusCode == 200) {
      return Consignment.fromJson(json.decode(response.body));
    }
    _throwApiError(response, 'Failed to update consignment');
  }

  // ---- Messaging API (REST; live delivery via ChatService) ----

  Future<List<Message>> getConversations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/conversations'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((m) => Message.fromJson(m))
          .toList();
    }
    _throwApiError(response, 'Failed to load conversations');
  }

  Future<List<Message>> getConversation(int otherUserId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/conversation/$otherUserId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((m) => Message.fromJson(m))
          .toList();
    }
    _throwApiError(response, 'Failed to load conversation');
  }

  Future<Message> sendMessage(int recipientId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: await _authHeaders(),
      body: json.encode({'recipientId': recipientId, 'content': content}),
    );
    if (response.statusCode == 201) {
      return Message.fromJson(json.decode(response.body));
    }
    _throwApiError(response, 'Failed to send message');
  }

  // ---- Analytics API ----

  Future<AnalyticsSummary> getAnalyticsSummary() async {
    final response = await http.get(
      Uri.parse('$baseUrl/analytics/summary'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      return AnalyticsSummary.fromJson(json.decode(response.body));
    }
    _throwApiError(response, 'Failed to load analytics');
  }

  // Products API
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Users API
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Authentication API
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? bio,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'bio': bio ?? '',
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Token verification failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // OAuth2 Google Login (will redirect to web)
  String getGoogleOAuthUrl() {
    // Derive the backend OAuth2 URL from the API base URL
    // Remove the trailing /api suffix to get the backend root URL
    final backendUrl = baseUrl.endsWith('/api')
        ? baseUrl.substring(0, baseUrl.length - 4)
        : baseUrl;
    return '$backendUrl/oauth2/authorization/google';
  }
}
