import 'package:e_commerce_app/model/cart_item_model.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/service/CartService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  var cartItems = <CartItemModel>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    cartItems.value = await CartService().getCart();
  }

  Future<void> addToCart(Product product) async {
    final success = await CartService().addToCart(product.id!, 1);
    if (success) {
      Get.snackbar('Added to Cart', '${product.name} added to cart',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
      loadCart();
    } else {
      Get.snackbar('Error', 'Failed to add to cart',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
  }

  Future<void> removeFromCart(Product product) async {
    final item = cartItems.firstWhereOrNull((e) => e.product.id == product.id);
    if (item?.id != null) {
      final success = await CartService().removeFromCart(item!.id!);
      if (success) {
        Get.snackbar('Removed from Cart', '${product.name} removed from cart',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
        loadCart();
      } else {
        Get.snackbar('Error', 'Failed to remove from cart',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    }
  }

  Future<void> updateQuantity(Product product, int quantity) async {
    if (quantity <= 0) {
      removeFromCart(product);
      return;
    }

    final item = cartItems.firstWhereOrNull((e) => e.product.id == product.id);
    if (item?.id != null) {
      final success = await CartService().updateQuantity(item!.id!, quantity);
      if (success) {
        Get.snackbar(
            'Updated Quantity', '${product.name} quantity updated to $quantity',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
        loadCart();
      } else {
        Get.snackbar('Error', 'Failed to update quantity',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
      }
    }
  }

  Future<void> clearCart() async {
    final success = await CartService().clearCart();
    if (success) {
      loadCart();
    } else {
      Get.snackbar('Error', 'Failed to clear cart',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
  }

  double get totalMRP {
    return cartItems.fold(
        0, (sum, item) => sum + (item.product.mrp * item.quantity));
  }

  double get totalSellingPrice {
    return cartItems.fold(0, (sum, item) {
      double sellingPrice = item.product.mrp -
          (item.product.mrp * (item.product.discountPercentage / 100));
      return sum + (sellingPrice * item.quantity);
    });
  }

  double get totalDiscount {
    return totalMRP - totalSellingPrice;
  }

  int get totalItems {
    return cartItems.length;
  }
}
