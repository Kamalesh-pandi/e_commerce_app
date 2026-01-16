import 'dart:convert';
import 'dart:async';

import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://10.16.216.4:8080";
  final box = GetStorage();

  Future<Map<String, dynamic>> signup(String name, String phone, String email,
      String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/signup"),
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print(data);
          if (data["token"] != null) {
            box.write("name", data["name"]);
            box.write("token", data["token"]);
          }
          return data;
        } catch (e) {
          print("Error decoding JSON: ${e.toString()}");
          print("Raw response body: ${response.body}");
          return {"error": "Invalid server response format: ${response.body}"};
        }
      } else {
        print("Raw error response body: ${response.body}");
        return {
          "error": "Failed with status: ${response.statusCode}",
          "body": response.body
        };
      }
    } on TimeoutException {
      return {
        "error":
            "Connection timed out. Please check your internet connection or try again later."
      };
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/login"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print(data);
          if (data["token"] != null) {
            box.write("name", data["name"]);
            box.write("token", data["token"]);
          }
          return data;
        } catch (e) {
          print("Error decoding JSON: ${e.toString()}");
          print("Raw response body: ${response.body}");
          return {"error": "Invalid server response format: ${response.body}"};
        }
      } else {
        print("Raw error response body: ${response.body}");
        return {
          "error": "Failed with status: ${response.statusCode}",
          "body": response.body
        };
      }
    } on TimeoutException {
      return {
        "error":
            "Connection timed out. Please check your internet connection or try again later."
      };
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> forgetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/forgot-password"),
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.body.contains("Reset token generated") ||
            response.body.contains("OTP has been sent to your email")) {
          return {"success": true, "message": response.body};
        }
        try {
          final data = jsonDecode(response.body);
          print(data);
          return data;
        } catch (e) {
          print("Error decoding JSON: ${e.toString()}");
          print("Raw response body: ${response.body}");
          return {"error": "Invalid server response format: ${response.body}"};
        }
      } else {
        print("Raw error response body: ${response.body}");
        return {
          "error": "Failed with status: ${response.statusCode}",
          "body": response.body
        };
      }
    } on TimeoutException {
      return {
        "error":
            "Connection timed out. Please check your internet connection or try again later."
      };
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/verify-otp"),
        body: jsonEncode({"email": email, "otp": otp}),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.body.contains("OTP verified successfully") ||
            response.body.contains("verified")) {
          return {"success": true, "message": response.body};
        }
        try {
          final data = jsonDecode(response.body);
          print(data);
          return data;
        } catch (e) {
          print("Error decoding JSON: ${e.toString()}");
          print("Raw response body: ${response.body}");
          return {"error": "Invalid server response format: ${response.body}"};
        }
      } else {
        print("Raw error response body: ${response.body}");
        return {
          "error": "Failed with status: ${response.statusCode}",
          "body": response.body
        };
      }
    } on TimeoutException {
      return {
        "error":
            "Connection timed out. Please check your internet connection or try again later."
      };
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String otp, String password, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/reset-password"),
        body: jsonEncode({
          "token": otp,
          "newPassword": password,
          "confirmPassword": confirmPassword
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.body.contains("Password has been reset successfully") ||
            response.body.contains("Password reset successfully")) {
          return {"success": true, "message": response.body};
        }
        try {
          final data = jsonDecode(response.body);
          print(data);
          return data;
        } catch (e) {
          print("Error decoding JSON: ${e.toString()}");
          print("Raw response body: ${response.body}");
          return {"error": "Invalid server response format: ${response.body}"};
        }
      } else {
        print("Raw error response body: ${response.body}");
        return {
          "error": "Failed with status: ${response.statusCode}",
          "body": response.body
        };
      }
    } on TimeoutException {
      return {
        "error":
            "Connection timed out. Please check your internet connection or try again later."
      };
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  void logout() {
    box.remove("token");
    Get.offNamed(AppRoutes.loginPage);
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return true;
      }

      var payload = parts[1];
      switch (payload.length % 4) {
        case 0:
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
        default:
          return true;
      }

      final payloadMap = json.decode(utf8.decode(base64Url.decode(payload)));
      if (payloadMap is! Map<String, dynamic>) {
        return true;
      }

      if (!payloadMap.containsKey('exp')) {
        return false;
      }

      final exp = payloadMap['exp'];
      if (exp == null) return false;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      print("Error checking token expiry: $e");
      return true;
    }
  }

  void isLoggedIn() {
    String? token = box.read("token");
    if (token != null) {
      if (isTokenExpired(token)) {
        print("Token expired, logging out...");
        logout();
      } else {
        Get.offNamed(AppRoutes.homePage);
      }
    }
  }

  Map<String, String> getHeaders() {
    final token = box.read("token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token"
    };
  }
}
