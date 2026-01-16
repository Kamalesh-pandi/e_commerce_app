import 'package:e_commerce_app/view/category/CategoryPage.dart';
import 'package:e_commerce_app/view/main/HomePage.dart';
import 'package:e_commerce_app/view/profile/ProfilePage.dart';
import 'package:e_commerce_app/view/wishlist/WishlistPage.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 0.obs;
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final List<Widget> pages = [
      HomePage(),
      CategoryPage(),
      WishlistPage(),
      ProfilePage()
    ];
    return Obx(
      () => SafeArea(
        child: Scaffold(
          extendBody: true, // Allows body to go behind the nav bar
          body: pages[selectedIndex.value],
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: theme.colorScheme.primary,
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            child: NavigationBar(
              height: size.height * 0.08,
              elevation: 0,
              backgroundColor: theme.colorScheme.surface,
              selectedIndex: selectedIndex.value,
              onDestinationSelected: changeIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(CupertinoIcons.house),
                  selectedIcon: Icon(CupertinoIcons.house_fill),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(CupertinoIcons.square_grid_2x2),
                  selectedIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
                  label: 'Category',
                ),
                NavigationDestination(
                  icon: Icon(CupertinoIcons.heart),
                  selectedIcon: Icon(CupertinoIcons.heart_fill),
                  label: 'Wishlist',
                ),
                NavigationDestination(
                  icon: Icon(CupertinoIcons.person),
                  selectedIcon: Icon(CupertinoIcons.person_fill),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
