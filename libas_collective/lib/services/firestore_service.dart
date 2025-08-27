import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/models/cart_item.dart';
import 'package:store_app/models/product_model.dart';
import 'package:store_app/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Products collection
  CollectionReference get products => _firestore.collection('products');
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get orders => _firestore.collection('orders');

  // Get all products
  Stream<List<Product>> getProducts() {
    return products.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    });
  }

  // Get product by ID
  Future<Product> getProduct(String id) async {
    final doc = await products.doc(id).get();
    return Product.fromJson({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    });
  }

  // Save user data
  Future<void> saveUser(UserModel user) async {
    await users.doc(user.uid).set(user.toJson());
  }

  // Save user orders
  Future<void> saveUserOrders(
      String uid, List<CartItem> cartItems, int totalAmount) async {
    await orders.doc(uid).set({
      'userId': uid,
      'items': cartItems
          .map((item) => {
                'productId': item.product.id,
                'name': item.product.name,
                'quantity': item.quantity,
              })
          .toList(),
      'totalAmount': totalAmount,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'confirmed',
    });
  }

  // Get user data
  Future<UserModel> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    return UserModel.fromJson({
      'uid': doc.id,
      ...doc.data() as Map<String, dynamic>,
    });
  }

  // Update user data
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await users.doc(uid).update(data);
  }
}
