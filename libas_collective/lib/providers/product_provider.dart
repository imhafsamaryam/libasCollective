import 'package:flutter/foundation.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/services/firestore_service.dart';

class ProductProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _firestoreService.getProducts().listen((products) {
        _products = products;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _error = 'Failed to load products';
      _isLoading = false;
      notifyListeners();
    }
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
