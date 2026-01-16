import 'dart:convert';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../model/order_model.dart';

class OrderService {
  final String baseUrl = AuthService.baseUrl;
  final box = GetStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = box.read('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String?> createRazorpayOrder(double amount) async {
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({
        'amount': amount,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/api/payment/create-order'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to create razorpay order: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating razorpay order: $e');
      return null;
    }
  }

  Future<OrderModel?> createOrder({
    required String addressId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({
        'addressId': addressId,
        'razorpayOrderId': razorpayOrderId,
        'razorpayPaymentId': razorpayPaymentId,
        'razorpaySignature': razorpaySignature,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/api/orders/create'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderModel.fromJson(jsonDecode(response.body));
      } else {
        String errorMessage = 'Failed to create order';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else {
            errorMessage = response.body;
          }
        } catch (_) {
          errorMessage = response.body;
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error creating backend order: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        print('Failed to fetch orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/orders/$orderId/cancel'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to cancel order: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error cancelling order: $e');
      return false;
    }
  }
}
