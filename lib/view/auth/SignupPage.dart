import 'package:animate_do/animate_do.dart';
import 'package:e_commerce_app/controller/auth/SignupController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupController signupController = Get.put(SignupController());
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
              delay: const Duration(milliseconds: 500),
              child: SizedBox(
                height: size.height * 0.19,
                child: Center(
                    child: Lottie.asset(
                  "assets/animations/login_logo.json",
                  height: size.height * 0.24,
                  fit: BoxFit.contain,
                )),
              ),
            ),
            FadeInDown(
              delay: const Duration(milliseconds: 500),
              child: Container(
                width: size.width * 0.9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Register",
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
                  "Register to continue using the app",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.9,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Name",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  _buildTextField(
                    theme: theme,
                    controller: signupController.nameController,
                    label: "Name",
                    icon: Icons.person,
                    hintText: "Enter your name",
                    keyboardType: TextInputType.name,
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: size.width * 0.9,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Phone",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  _buildTextField(
                    theme: theme,
                    controller: signupController.phoneController,
                    label: "Phone",
                    icon: Icons.phone,
                    hintText: "Enter your phone number",
                    keyboardType: TextInputType.phone,
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    width: size.width * 0.9,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Email",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  _buildTextField(
                    theme: theme,
                    controller: signupController.emailController,
                    label: "Email",
                    icon: Icons.email,
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    size: size,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    width: size.width * 0.9,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Password",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  _buildPasswordTextField(
                    theme: theme,
                    controller: signupController.passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    hintText: "Enter your password",
                    keyboardType: TextInputType.visiblePassword,
                    size: size,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    width: size.width * 0.9,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Confirm Password",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  _buildPasswordTextField(
                    theme: theme,
                    controller: signupController.confirmPasswordController,
                    label: "Confirm Password",
                    icon: Icons.lock,
                    hintText: "Enter your confirm password",
                    keyboardType: TextInputType.visiblePassword,
                    size: size,
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
                      signupController.signup();
                    },
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.primary),
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: size.height * 0.065,
                        width: size.width * 0.9,
                        child: signupController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : Center(
                                child: Text(
                                "Register",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.surface,
                                  fontSize: 16,
                                ),
                              )),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
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
          obscureText: signupController.isObscure.value,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(
                signupController.isObscure.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                signupController.isObscure.value =
                    !signupController.isObscure.value;
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
