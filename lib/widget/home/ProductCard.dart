import 'package:e_commerce_app/controller/WishlistController.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final double sellingPrice =
        product.mrp - (product.mrp * (product.discountPercentage / 100));

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetailPage, arguments: product);
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: theme.colorScheme.surface,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      width: double.infinity,
                      color: theme.colorScheme.surface,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(() {
                      final wishlistController = Get.put(WishlistController());
                      final isInWishlist =
                          wishlistController.isInWishlist(product);
                      return GestureDetector(
                        onTap: () {
                          wishlistController.toggleWishlist(product);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                )
                              ]),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist
                                ? Colors.red
                                : theme.colorScheme.onSurface,
                            size: 18,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.brand.toUpperCase(),
                          style: GoogleFonts.roboto(
                            color: theme.colorScheme.onSurface,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                              height: 1.2),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF388E3C),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product.rating.toString(),
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(Icons.star,
                                      size: 10, color: Colors.white),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "(${product.reviewCount})",
                              style: GoogleFonts.roboto(
                                color: theme.colorScheme.onSurface,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 6,
                          children: [
                            Text(
                              '₹${sellingPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '₹${product.mrp.toStringAsFixed(0)}',
                              style: GoogleFonts.roboto(
                                fontSize: 11, // Smaller for strikethrough
                                color: theme.colorScheme.onSurface,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${product.discountPercentage.toInt()}% off',
                              style: GoogleFonts.roboto(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF388E3C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
