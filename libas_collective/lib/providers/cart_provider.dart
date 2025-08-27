import 'package:flutter/foundation.dart';
import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        _cartItems[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  void increaseQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cartItems[index].increaseQuantity();
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity == 1) {
        removeFromCart(productId);
      } else {
        _cartItems[index].decreaseQuantity();
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  int getProductQuantity(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
          product: Product(
              id: '',
              name: '',
              description: '',
              price: 0,
              imageUrl: '',
              stock: 0,
              category: ''),
          quantity: 0),
    );
    return item.quantity;
  }
}
