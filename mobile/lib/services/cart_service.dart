import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Represents a single line item in the shopping cart.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };
}

/// ChangeNotifier-based cart service for state management.
/// Injected via a top-level [CartProvider] widget or accessed directly.
class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Unmodifiable view of cart items.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Number of unique products in the cart.
  int get itemCount => _items.length;

  /// Total quantity of all items in the cart.
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal before any discounts.
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Whether the cart is empty.
  bool get isEmpty => _items.isEmpty;

  /// Add a product to the cart. If it already exists, increment quantity.
  void addProduct(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((i) => i.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  /// Remove a product from the cart entirely.
  void removeProduct(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  /// Update the quantity of a specific item.
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  /// Clear the entire cart.
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
