import 'package:animate_do/animate_do.dart';
import 'package:e_commerce_app/controller/auth/ForgetPasswordController.dart';
import 'package:e_commerce_app/controller/auth/OtpVerifyController.dart';
import 'package:e_commerce_app/widget/OtpInput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key, required this.email});

  final String email;

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final ForgetPasswordController forgetPasswordController =
      Get.find<ForgetPasswordController>();
  final OtpVerifyController otpVerifyController =
      Get.find<OtpVerifyController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
              Container(
                height: size.height * 0.4,
                child: FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: isDarkMode
                        ? Image.asset(
                            "assets/images/otp_verification_dark.png",
                            height: size.height * 0.70,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            "assets/images/otp_verification_light.png",
                            height: size.height * 0.70,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "OTP Verification",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: theme.colorScheme.onSurface,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        "Enter the verification code we just sent on your email address.",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(5, (index) {
                            return OtpInput(
                              controller:
                                  otpVerifyController.controllers[index],
                              focusNode: otpVerifyController.focusNodes[index],
                              nextFocus: index < 4
                                  ? otpVerifyController.focusNodes[index + 1]
                                  : null,
                              prevFocus: index > 0
                                  ? otpVerifyController.focusNodes[index - 1]
                                  : null,
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: GestureDetector(
                        onTap: () {
                          otpVerifyController.verifyOtp(widget.email);
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
                            child: forgetPasswordController.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: theme.colorScheme.surface,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                    "Verify",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.surface,
                                      fontSize: 16,
                                    ),
                                  )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Don't receive code? ",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              print(widget.email);
                              forgetPasswordController
                                  .forgetPassword(widget.email);
                            },
                            child: Container(
                              child: Text(
                                "Resend",
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
            ],
          ),
        ),
      ),
    );
  }
}
