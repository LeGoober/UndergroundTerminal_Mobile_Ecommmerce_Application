import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_GOOGLE_CLIENT_ID', // Replace with actual client ID
  );

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) return false;

    try {
      final result = await _apiService.verifyToken(token);
      return result['valid'] == true;
    } catch (e) {
      // Token is invalid, clear storage
      await logout();
      return false;
    }
  }

  // Get stored user data
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData == null) return null;

    try {
      final Map<String, dynamic> userJson = json.decode(userData);
      return User.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Login with email and password
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.loginUser(email, password);

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      // Store token and user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userKey, json.encode(userData));

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register new user
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? bio,
  }) async {
    try {
      final response = await _apiService.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
        bio: bio,
      );

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;
      final user = User.fromJson(userData);

      // Store token and user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userKey, json.encode(userData));

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // In production, send googleUser.authentication to backend
      // For now, create a mock user from Google profile data
      final user = User(
        id: 999,
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        role: UserRole.buyer,
        imageUrl: googleUser.photoUrl,
        bio: 'User registered via Google Sign-In',
      );

      // Store user data (in real implementation, you'd get token from backend)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));

      return user;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Google sign out error, continue with local logout
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Get authentication headers for API calls
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token == null) throw Exception('No authentication token');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Save/update the current user locally (SharedPreferences)
  Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }
}
