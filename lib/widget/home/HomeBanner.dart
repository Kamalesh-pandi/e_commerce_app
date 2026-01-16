import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  HomeBanner({super.key});

  final List<String> _banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      height: size.height * 0.22,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          height: size.height * 0.20,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ),
        items: List.generate(
          _banners.length,
          (index) => _buildBannerItem(_banners[index]),
        ),
      ),
    );
  }

  Widget _buildBannerItem(String banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(banner),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
