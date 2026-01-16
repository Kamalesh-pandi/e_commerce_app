import 'package:e_commerce_app/model/product_model.dart';

class CartItemModel {
  final int? id;
  final Product product;
  int quantity;
  bool isSelected;

  CartItemModel({
    this.id,
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      isSelected: json['isSelected'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }
}
