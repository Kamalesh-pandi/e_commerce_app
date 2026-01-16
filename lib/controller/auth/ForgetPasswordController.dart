import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> forgetPassword([String? email]) async {
    try {
      final emailToSend = (email ?? emailController.text).trim();
      print("Debugging Resend OTP: Sending to '$emailToSend'");
      isLoading.value = true;
      if (emailToSend.isEmpty) {
        Get.snackbar("Error", "Email is required",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await AuthService().forgetPassword(emailToSend);

      if (response.containsKey("error")) {
        Get.snackbar(
            "Error", _getReadableError(response["body"] ?? response["error"]),
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (response["token"] != null || response["success"] == true) {
        Get.snackbar("Success", "OTP sent successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            forwardAnimationCurve: Curves.easeInOut);
        if (Get.currentRoute != AppRoutes.otpVerifyPage) {
          Get.toNamed(AppRoutes.otpVerifyPage,
              arguments: {"email": emailToSend});
        }
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
