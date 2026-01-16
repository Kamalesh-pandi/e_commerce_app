import 'dart:convert';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../model/user_model.dart';
import 'AuthService.dart';

class UserService {
  final String baseUrl = AuthService.baseUrl;
  final box = GetStorage();

  String? get _token => box.read('token');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  Future<User?> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  Future<User?> updateUserProfile(User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: _headers,
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return null;
    }
  }

  Future<Address?> addAddress(Address address) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/address'),
        headers: _headers,
        body: jsonEncode(address.toJson()),
      );

      if (response.statusCode == 201) {
        return Address.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to add address: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error adding address: $e');
      return null;
    }
  }

  Future<bool> removeAddress(int addressId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/user/address/$addressId'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing address: $e');
      return false;
    }
  }

  Future<Address?> updateAddress(int addressId, Address address) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/address/$addressId'),
        headers: _headers,
        body: jsonEncode(address.toJson()),
      );

      if (response.statusCode == 200) {
        return Address.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to update address: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating address: $e');
      return null;
    }
  }

  Future<Address?> setDefaultAddress(int addressId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/address/$addressId/default'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Address.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to set default address: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error setting default address: $e');
      return null;
    }
  }

  Future<List<Product>> getWishlist() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/wishlist'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List) {
          return body.map((e) => Product.fromJson(e)).toList();
        } else if (body is Map<String, dynamic>) {
          if (body.containsKey('wishlist') && body['wishlist'] is List) {
            return (body['wishlist'] as List)
                .map((e) => Product.fromJson(e))
                .toList();
          } else if (body.containsKey('products') && body['products'] is List) {
            return (body['products'] as List)
                .map((e) => Product.fromJson(e))
                .toList();
          } else if (body.containsKey('data') && body['data'] is List) {
            return (body['data'] as List)
                .map((e) => Product.fromJson(e))
                .toList();
          }
        }
        print('Unexpected wishlist response format: $body');
        return [];
      } else {
        print('Failed to load wishlist: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading wishlist: $e');
      return [];
    }
  }

  Future<bool> addToWishlist(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/wishlist/add/$productId'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  Future<bool> removeFromWishlist(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/wishlist/remove/$productId'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }
}
