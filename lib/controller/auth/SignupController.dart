import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  RxBool isObscure = true.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> signup() async {
    try {
      isLoading.value = true;
      if (nameController.text.isEmpty ||
          phoneController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        Get.snackbar("Error", "All fields are required",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar("Error", "Passwords do not match",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await AuthService().signup(
        nameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        confirmPasswordController.text.trim(),
      );

      if (response.containsKey("error")) {
        Get.snackbar(
            "Error", _getReadableError(response["error"] ?? "Unknown Error"),
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (response["token"] != null) {
        Get.snackbar("Success", "Signup successful",
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
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
    return error; // Return original message if it's likely a backend validation message
  }
}
