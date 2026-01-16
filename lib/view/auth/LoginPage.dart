import 'package:animate_do/animate_do.dart';
import 'package:e_commerce_app/controller/auth/LoginController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                delay: const Duration(milliseconds: 500),
                child: Container(
                  height: size.height * 0.2,
                  child: Center(
                      child: Lottie.asset(
                    "assets/animations/login_logo.json",
                    height: size.height * 0.24,
                    fit: BoxFit.contain,
                  )),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                child: Container(
                  width: size.width * 0.9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Login",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: theme.colorScheme.onSurface,
                      fontSize: 26,
                    ),
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                child: Container(
                  width: size.width * 0.9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Login to continue using the app",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      controller: loginController.emailController,
                      label: "Email",
                      icon: Icons.email,
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      size: size,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
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
                      controller: loginController.passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      hintText: "Enter your password",
                      keyboardType: TextInputType.visiblePassword,
                      size: size,
                    ),
                    Container(
                      width: size.width * 0.9,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontSize: 16,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        loginController.login();
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
                          child: loginController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : Center(
                                  child: Text(
                                  "Login",
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
              SizedBox(height: size.height * 0.03),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.signupPage);
                      },
                      child: Container(
                        child: Text(
                          "Register",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
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
          obscureText: loginController.isObscure.value,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(
                loginController.isObscure.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                loginController.isObscure.value =
                    !loginController.isObscure.value;
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
