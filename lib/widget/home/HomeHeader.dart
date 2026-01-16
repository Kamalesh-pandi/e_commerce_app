import 'package:e_commerce_app/controller/CartController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/widget/home/CategoryList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final name = box.read("name");
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: size.height * 0.35,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: GoogleFonts.poppins(
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        name ?? 'Unknown User',
                        style: GoogleFonts.poppins(
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.cartPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Obx(() {
                        final cartController = Get.put(CartController());
                        return Badge(
                          label: Text('${cartController.totalItems}'),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'Popular Categories',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.015),
              const CategoryList(),
            ],
          ),
        ),
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.allProductListPage);
              },
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Search Products',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
