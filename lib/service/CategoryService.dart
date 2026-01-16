import 'dart:convert';

import 'package:e_commerce_app/model/category_model.dart';
import 'package:e_commerce_app/model/subcategory_model.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = AuthService.baseUrl;
  final box = GetStorage();

  String? get _token => box.read('token');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
  };

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Category.fromJson(e))
            .toList();
      } else {
        print('Failed to load categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  Future<List<SubCategory>> getSubCategories(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories/$id/subcategories'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => SubCategory.fromJson(e))
            .toList();
      } else {
        print('Failed to load subcategories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading subcategories: $e');
      return [];
    }
  }  
}
