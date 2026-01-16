import 'package:e_commerce_app/controller/auth/ForgetPasswordController.dart';
import 'package:e_commerce_app/controller/auth/LoginController.dart';
import 'package:e_commerce_app/controller/auth/OtpVerifyController.dart';
import 'package:e_commerce_app/controller/auth/ResetPasswordController.dart';
import 'package:e_commerce_app/controller/auth/SignupController.dart';
import 'package:e_commerce_app/controller/category/CategoryController.dart';
import 'package:e_commerce_app/controller/product/ProductController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/view/auth/ForgotPassword.dart';
import 'package:e_commerce_app/view/auth/LoginPage.dart';
import 'package:e_commerce_app/view/auth/OtpVerifyPage.dart';
import 'package:e_commerce_app/view/auth/ResetPassword.dart';
import 'package:e_commerce_app/view/auth/SignupPage.dart';
import 'package:e_commerce_app/view/category/CategoryPage.dart';
import 'package:e_commerce_app/view/main/MainPage.dart';
import 'package:e_commerce_app/view/onboarding/LoginOrSignupPage.dart';
import 'package:e_commerce_app/view/onboarding/OnboardingPage.dart';
import 'package:e_commerce_app/view/product/AllProductListPage.dart';
import 'package:e_commerce_app/view/product/ProductDetailPage.dart';
import 'package:e_commerce_app/view/product/ProductListPage.dart';
import 'package:e_commerce_app/view/cart/CartPage.dart';
import 'package:e_commerce_app/view/splash/SplashScreen.dart';
import 'package:e_commerce_app/view/wishlist/WishlistPage.dart';
import 'package:e_commerce_app/view/order/OrderHistoryPage.dart';
import 'package:e_commerce_app/view/order/OrderDetailsPage.dart';
import 'package:e_commerce_app/controller/OrderController.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.loginOrSignupPage,
      page: () => const LoginOrSignupPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.loginPage,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder.put(() => LoginController()),
    ),
    GetPage(
        name: AppRoutes.signupPage,
        page: () => const SignupPage(),
        transition: Transition.rightToLeft,
        binding: BindingsBuilder.put(() => SignupController())),
    GetPage(
        name: AppRoutes.forgotPassword,
        page: () => const ForgotPassword(),
        transition: Transition.rightToLeft,
        binding: BindingsBuilder.put(() => ForgetPasswordController())),
    GetPage(
        name: AppRoutes.otpVerifyPage,
        page: () => OtpVerifyPage(email: Get.arguments?["email"] ?? ""),
        transition: Transition.rightToLeft,
        binding: BindingsBuilder.put(() => OtpVerifyController())),
    GetPage(
        name: AppRoutes.resetPassword,
        page: () => ResetPassword(otp: Get.arguments?["otp"] ?? ""),
        transition: Transition.rightToLeft,
        binding: BindingsBuilder.put(() => ResetPasswordController())),
    GetPage(
      name: AppRoutes.homePage,
      page: () => const MainPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.categoryPage,
      page: () => const CategoryPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder.put(() => CategoryController()),
    ),
    GetPage(
      name: AppRoutes.productListPage,
      page: () => const ProductListPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder.put(() => ProductController()),
    ),
    GetPage(
      name: AppRoutes.productDetailPage,
      page: () => const ProductDetailPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder.put(() => ProductController()),
    ),
    GetPage(
      name: AppRoutes.allProductListPage,
      page: () => const AllProductListPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder.put(() => ProductController()),
    ),
    GetPage(
      name: AppRoutes.wishlistPage,
      page: () => const WishlistPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.cartPage,
      page: () => const CartPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderHistoryPage,
      page: () => const OrderHistoryPage(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder.put(() => OrderController()),
    ),
    GetPage(
      name: AppRoutes.orderDetailsPage,
      page: () => const OrderDetailsPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
