import 'package:e_commerce_app/controller/product/ProductController.dart';
import 'package:e_commerce_app/widget/home/ProductCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class PopularProductGrid extends StatelessWidget {
  const PopularProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Products',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'View all',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.035,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.018),
        Obx(() {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (productController.bestSellerProductList.isEmpty) {
            return const Center(child: Text("No popular products found"));
          }
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.57, // Adjusted to fix 8.7px bottom overflow
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: productController.bestSellerProductList.length,
            itemBuilder: (context, index) {
              return ProductCard(
                  product: productController.bestSellerProductList[index]);
            },
          );
        }),
      ],
    );
  }
}
