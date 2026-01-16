import 'dart:convert';

import 'package:e_commerce_app/model/cart_item_model.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CartService extends GetxController {
  final String baseUrl = AuthService.baseUrl;

  final box = GetStorage();

  String? get _token => box.read('token');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  Future<List<CartItemModel>> getCart() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/cart'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List) {
          return body.map((e) => CartItemModel.fromJson(e)).toList();
        } else if (body is Map<String, dynamic>) {
          if (body.containsKey('cart') && body['cart'] is List) {
            return (body['cart'] as List)
                .map((e) => CartItemModel.fromJson(e))
                .toList();
          } else if (body.containsKey('products') && body['products'] is List) {
            // Fallback if API returns list of products instead of cart items
            return (body['products'] as List)
                .map((e) => CartItemModel(product: Product.fromJson(e)))
                .toList();
          } else if (body.containsKey('data') && body['data'] is List) {
            // Try parsing as CartItem first, if fails assume product?
            // Ideally data should be list of CartItem
            return (body['data'] as List)
                .map((e) => CartItemModel.fromJson(e))
                .toList();
          }
        }
        print('Unexpected cart response format: $body');
        return [];
      } else {
        print('Failed to load cart: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading cart: $e');
      return [];
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/cart/add'),
        headers: _headers,
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> removeFromCart(int cartItemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/cart/remove/$cartItemId'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  Future<bool> updateQuantity(int cartItemId, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/cart/update/$cartItemId'),
        headers: _headers,
        body: jsonEncode({'quantity': quantity}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating quantity: $e');
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/cart/clear'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }
}
