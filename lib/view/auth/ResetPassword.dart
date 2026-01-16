import 'package:animate_do/animate_do.dart';
import 'package:e_commerce_app/controller/auth/ResetPasswordController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  final String otp;
  const ResetPassword({super.key, required this.otp});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ResetPasswordController resetPasswordController =
      Get.put(ResetPasswordController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create new password",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: theme.colorScheme.onSurface,
                        fontSize: 26,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "Your new password must be unique from those previously used.",
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
                        "Password",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    _buildPasswordTextField(
                      theme: theme,
                      controller: resetPasswordController.passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      size: size,
                      hintText: "Enter your password",
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      width: size.width * 0.9,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        "Confirm Password",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    _buildPasswordTextField(
                      theme: theme,
                      controller:
                          resetPasswordController.confirmPasswordController,
                      label: "Confirm Password",
                      icon: Icons.lock,
                      size: size,
                      hintText: "Enter your confirm password",
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        resetPasswordController.resetPassword();
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
                          child: resetPasswordController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: Text(
                                  "Reset Password",
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

  Widget _buildPasswordTextField(
      {required ThemeData theme,
      required TextEditingController controller,
      required String label,
      required IconData icon,
      required Size size,
      String? hintText,
      TextInputType? keyboardType}) {
    return Obx(
      () => Container(
        width: size.width * 0.9,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: resetPasswordController.isObscure.value,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(
                resetPasswordController.isObscure.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                resetPasswordController.isObscure.value =
                    !resetPasswordController.isObscure.value;
              },
            ),
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
      ),
    );
  }
}
