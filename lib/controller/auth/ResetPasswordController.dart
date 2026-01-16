import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  RxBool isObscure = true.obs;
  var isLoading = false.obs;

  Future<void> resetPassword() async {
    try {
      isLoading.value = true;
      if (passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        Get.snackbar("Error", "All fields are required",
            backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }
      print("Debug: Password='${passwordController.text}'");
      print("Debug: Confirm='${confirmPasswordController.text}'");

      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar("Error", "Passwords do not match (Client Check)",
            backgroundColor: Colors.red, colorText: Colors.white);
        isLoading.value = false;
        return;
      }

      final response = await AuthService().resetPassword(
          Get.arguments["otp"].toString(),
          passwordController.text.trim(),
          confirmPasswordController.text.trim());
      if (response.containsKey("error")) {
        Get.snackbar(
            "Error", _getReadableError(response["body"] ?? response["error"]),
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (response["token"] != null || response["success"] == true) {
        Get.snackbar("Success", "Password reset successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            forwardAnimationCurve: Curves.easeInOut);
        Get.offNamed(AppRoutes.loginPage);
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

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
