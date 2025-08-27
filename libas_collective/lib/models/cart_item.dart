import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  double get totalPrice => product.discountedPrice * quantity;

  void increaseQuantity() => quantity++;
  void decreaseQuantity() {
    if (quantity > 1) quantity--;
  }
}
