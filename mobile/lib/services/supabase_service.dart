import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/user.dart' as app_user;
import '../config/supabase_config.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  
  // Products API
  Future<List<Product>> getProducts() async {
    try {
      final response = await _client
          .from(SupabaseConfig.productsTable)
          .select('*');
      
      return (response as List)
          .map((data) => Product.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _client
          .from(SupabaseConfig.productsTable)
          .select('*')
          .eq('id', id)
          .single();
      
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await _client
          .from(SupabaseConfig.productsTable)
          .insert(product.toJson())
          .select()
          .single();
      
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _client
          .from(SupabaseConfig.productsTable)
          .update(product.toJson())
          .eq('id', id)
          .select()
          .single();
      
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _client
          .from(SupabaseConfig.productsTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Users API
  Future<List<app_user.User>> getUsers() async {
    try {
      final response = await _client
          .from(SupabaseConfig.usersTable)
          .select('*');
      
      return (response as List)
          .map((data) => app_user.User.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<app_user.User?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;
      
      final response = await _client
          .from(SupabaseConfig.usersTable)
          .select('*')
          .eq('email', user.email!)
          .single();
      
      return app_user.User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Authentication
  Future<app_user.User> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign in failed');
      }
      
      final userData = await _client
          .from(SupabaseConfig.usersTable)
          .select('*')
          .eq('email', email)
          .single();
      
      return app_user.User.fromJson(userData);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<app_user.User> signUp(String email, String password, String name, String role) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Sign up failed');
      }
      
      // Create user profile
      final userData = await _client
          .from(SupabaseConfig.usersTable)
          .insert({
            'email': email,
            'name': name,
            'role': role,
          })
          .select()
          .single();
      
      return app_user.User.fromJson(userData);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Real-time subscriptions for B2B features
  Stream<List<Product>> getProductsStream() {
    return _client
        .from(SupabaseConfig.productsTable)
        .stream(primaryKey: ['id'])
        .map((data) => data.map((item) => Product.fromJson(item)).toList());
  }

  Stream<Product> getProductStream(int id) {
    return _client
        .from(SupabaseConfig.productsTable)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) => Product.fromJson(data.first));
  }
}
