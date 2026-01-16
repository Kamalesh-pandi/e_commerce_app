import 'package:e_commerce_app/widget/home/HomeBanner.dart';
import 'package:e_commerce_app/widget/home/HomeHeader.dart';
import 'package:e_commerce_app/widget/home/PopularProductGrid.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            SizedBox(height: 20),
            HomeBanner(),
            SizedBox(height: 20),
            PopularProductGrid(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
