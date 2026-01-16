import 'package:animate_do/animate_do.dart';
import 'package:e_commerce_app/controller/auth/ForgetPasswordController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgetPasswordController>();
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: isDarkMode
                    ? Image.asset(
                        "assets/images/forgot_password_dark.png",
                        height: size.height * 0.3,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/images/forgot_password_light.png",
                        height: size.height * 0.3,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: theme.colorScheme.onSurface,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "Don't worry! It occurs. Please enter the email address linked with your account.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      width: size.width * 0.9,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        "Email",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    _buildTextField(
                      theme: theme,
                      controller: controller.emailController,
                      label: "Email",
                      icon: Icons.email,
                      size: size,
                      hintText: "Enter your email address",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        controller.forgetPassword();
                      },
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.primary),
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: size.height * 0.065,
                          width: size.width * 0.9,
                          child: controller.isLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: theme.colorScheme.surface,
                                ))
                              : Center(
                                  child: Text(
                                  "Send OTP",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.surface,
                                    fontSize: 16,
                                  ),
                                )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required ThemeData theme,
      required TextEditingController controller,
      required String label,
      required IconData icon,
      required Size size,
      String? hintText,
      TextInputType? keyboardType}) {
    return Container(
      width: size.width * 0.9,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.colorScheme.surface,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:
                BorderSide(color: theme.colorScheme.onSurface, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }
}
