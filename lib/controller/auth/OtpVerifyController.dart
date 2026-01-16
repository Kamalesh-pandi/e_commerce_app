import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/service/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerifyController extends GetxController {
  final List<TextEditingController> controllers =
      List.generate(5, (_) => TextEditingController());
  var isLoading = false.obs;

  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  Future<void> verifyOtp(String email) async {
    try {
      isLoading.value = true;
      final response = await AuthService().verifyOtp(email, getOtp());
      if (response.containsKey("error")) {
        Get.snackbar(
            "Error", _getReadableError(response["body"] ?? response["error"]),
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (response["token"] != null || response["success"] == true) {
        Get.snackbar("Success", "OTP verified successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            forwardAnimationCurve: Curves.easeInOut);
        if (Get.currentRoute != AppRoutes.resetPassword) {
          Get.toNamed(AppRoutes.resetPassword, arguments: {"otp": getOtp()});
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
