import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final String baseUrl = AuthService.baseUrl;
  final box = GetStorage();

  String? get _token => box.read('token');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  Future<List<Product>> getProducts() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/products'), headers: _headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> getProductsByBestSeller() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/products/bestsellers'),
          headers: _headers);
      print(response.body);
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products by best seller');
      }
    } catch (e) {
      throw Exception('Failed to load products by best seller: $e');
    }
  }

  Future<List<Product>> getProductsBySubCategory(int subCategoryId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/products/subcategory/$subCategoryId'),
          headers: _headers);
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products by sub category');
      }
    } catch (e) {
      throw Exception('Failed to load products by sub category: $e');
    }
  }

  Future<List<Product>> getProductsByQuery(String query) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/products/search?query=$query'),
          headers: _headers);

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        // Fallback: If backend doesn't support search endpoint yet, fetch all and filter locally
        // This is a robust fallback for development
        final allProducts = await getProducts();
        return allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Fallback on error too
      try {
        final allProducts = await getProducts();
        return allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } catch (innerE) {
        throw Exception('Failed to search products: $e');
      }
    }
  }
}
