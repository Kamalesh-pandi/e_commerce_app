import 'package:e_commerce_app/service/AuthService.dart';
import 'package:e_commerce_app/routes/AppPages.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/util/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  final token = box.read("token");
  final authService = AuthService();

  String initialRoute = AppRoutes.splashScreen;

  if (token != null) {
    if (authService.isTokenExpired(token)) {
      print("Auto-login failed: Token expired");
      box.remove("token");
    } else {
      initialRoute = AppRoutes.homePage;
    }
  }

  runApp(MyApp(
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
