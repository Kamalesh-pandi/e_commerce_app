import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/controller/CartController.dart';
import 'package:e_commerce_app/controller/WishlistController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  int _selectedColor = 0;
  int _selectedSize = 1;
  late Product product;

  final List<Color> _colors = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
  ];

  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    product = Get.arguments as Product;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final double sellingPrice =
        product.mrp - (product.mrp * (product.discountPercentage / 100));

    final List<String> displayImages =
        product.imageUrls.isNotEmpty ? product.imageUrls : [product.imageUrl];

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            'Product Detail',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          centerTitle: true,
          backgroundColor: theme.colorScheme.primary,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.cartPage);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Obx(() {
                  final cartController = Get.put(CartController());
                  return Badge(
                    label: Text('${cartController.totalItems}'),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: size.height * 0.45,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                          ),
                          items: displayImages.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                            child: Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey)),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        if (displayImages.length > 1)
                          Positioned(
                            bottom: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  displayImages.asMap().entries.map((entry) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(
                                            _currentImageIndex == entry.key
                                                ? 0.9
                                                : 0.2),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Obx(() {
                            final wishlistController =
                                Get.put(WishlistController());
                            final isInWishlist =
                                wishlistController.isInWishlist(product);
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                    isInWishlist
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isInWishlist
                                        ? Colors.red
                                        : const Color(0xFFC2C2C2),
                                    size: 24),
                                onPressed: () {
                                  wishlistController.toggleWishlist(product);
                                },
                              ),
                            );
                          }),
                        )
                      ],
                    ),

                    // Product Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand Name
                          Text(
                            product.brand,
                            style: GoogleFonts.roboto(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Product Name
                          Text(
                            product.name,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurface,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Rating Pill and Review Count
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.star,
                                        size: 12, color: Colors.white),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ratings & ${product.reviewCount} Reviews',
                                style: GoogleFonts.roboto(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${sellingPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (product.discountPercentage > 0) ...[
                                Text(
                                  '₹${product.mrp.toStringAsFixed(0)}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${product.discountPercentage.toInt()}% off',
                                  style: GoogleFonts.roboto(
                                    color: const Color(0xFF388E3C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Available Offers (Mock Data)
                          Text(
                            'Available offers',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              _buildOfferItem(theme,
                                  "Bank Offer 5% Unlimited Cashback on Flipkart Axis Bank Credit Card"),
                              _buildOfferItem(theme,
                                  "Special Price Get extra 10% off (price inclusive of cashback/coupon)"),
                              _buildOfferItem(theme,
                                  "Partner Offer Sign up for Flipkart Pay Later and get Flipkart Gift Card worth up to ₹1000*"),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Size Selection
                          if (['fashion', 'clothing', 'shoe', 'wear'].any(
                              (keyword) => product.categoryName
                                  .toLowerCase()
                                  .contains(keyword))) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Size',
                                  style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Size Chart',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(_sizes.length, (index) {
                                  final isSelected = _selectedSize == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedSize = index;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                                .withOpacity(0.1)
                                            : theme.colorScheme.surface,
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : Colors.grey.shade400,
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _sizes[index],
                                        style: GoogleFonts.roboto(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Color Selection
                            Text(
                              'Select Color',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(_colors.length, (index) {
                                final isSelected = _selectedColor == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _colors[index],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ] else if (product.specifications.isNotEmpty) ...[
                            Text(
                              'Specifications',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children:
                                    product.specifications.entries.map((entry) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            entry.key,
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            entry.value,
                                            style: GoogleFonts.roboto(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),

                          // About item
                          Text(
                            'Product Description',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            style: GoogleFonts.roboto(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.8),
                              height: 1.5,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Ratings & Reviews
                          Text(
                            'Ratings & Reviews',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      '${product.rating}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < product.rating.round()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${product.reviewCount} reviews',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 80,
                                color: Colors.grey.shade300,
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    children: [
                                      _buildRatingBar(5, 0.7, Colors.green),
                                      _buildRatingBar(4, 0.4, Colors.green),
                                      _buildRatingBar(3, 0.2, Colors.amber),
                                      _buildRatingBar(2, 0.1, Colors.orange),
                                      _buildRatingBar(1, 0.05, Colors.red),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 100), // Space for bottom bar
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          height: size.height * 0.09,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    final cartController = Get.put(CartController());
                    cartController.addToCart(product);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: theme.colorScheme.onSurface.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Add to Cart',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        final cartController = Get.put(CartController());
                        cartController.addToCart(product);
                        Get.toNamed(AppRoutes.cartPage);
                      },
                      child: Text(
                        'Buy Now',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildOfferItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_offer, color: const Color(0xFF388E3C), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$star',
              style: GoogleFonts.roboto(
                  fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 10, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
