import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Lottie.asset(
                  "assets/animations/onboarding.json",
                  height: size.height * 0.75,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Everything you need is in one place",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: theme.colorScheme.onSurface,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Find your daily necessities at Brand. The world's largest fashion e-commerce has arrived in a mobile shop now!",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.loginPage);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        height: size.height * 0.065,
                        width: size.width * 0.9,
                        child: Center(
                            child: Text(
                          "Login",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.signupPage);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.primary),
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        height: size.height * 0.065,
                        width: size.width * 0.9,
                        child: Center(
                            child: Text(
                          "Register",
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
            )
          ],
        ),
      ),
    );
  }
}
