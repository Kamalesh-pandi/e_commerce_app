import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isObscure = true.obs;
  var isLoading = false.obs;

  Future<void> login() async {
    try {
      isLoading.value = true;
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar("Error", "All fields are required",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await AuthService().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.containsKey("error")) {
        // ERROR: Previously accessing 'body', which might be null.
        // The 'error' key is consistently populated by AuthService in all error cases.
        Get.snackbar(
            "Error", _getReadableError(response["error"] ?? "Unknown Error"),
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (response["token"] != null) {
        Get.snackbar("Success", "Login successful",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offNamed(AppRoutes.homePage);
      } else {
        Get.snackbar("Error", "Unknown error occurred",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", _getReadableError(e.toString()),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }

  String _getReadableError(String error) {
    if (error.contains("SocketException") ||
        error.contains("Network is unreachable")) {
      return "No internet connection. Please check your network.";
    }
    if (error.contains("Connection refused") ||
        error.contains("Connection timed out")) {
      return "Server is currently unavailable. Please try again later.";
    }
    if (error.contains("ClientException")) {
      return "Problem connecting to the server.";
    }
    return error;
  }
}
