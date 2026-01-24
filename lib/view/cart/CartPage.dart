import 'package:e_commerce_app/controller/CartController.dart';
import 'package:e_commerce_app/controller/OrderController.dart';
import 'package:e_commerce_app/controller/UserController.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:e_commerce_app/view/profile/AddressPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final cartController = Get.put(CartController());
    final orderController = Get.put(OrderController());
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            'My Cart',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          elevation: 1,
          backgroundColor: theme.colorScheme.primary,
        ),
        body: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your cart is empty!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explore products and add them to your cart.',
                    style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.homePage),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Shop Now',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  children: [
                    _buildAddressStrip(theme),
                    ...cartController.cartItems.map((item) {
                      return _buildCartItem(
                          size, context, item, cartController, theme);
                    }).toList(),
                    _buildPriceDetails(cartController, theme),
                    _buildSafePayments(theme),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(orderController, cartController, theme),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAddressStrip(ThemeData theme) {
    final userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.user.value;
      if (user == null || user.addresses == null || user.addresses!.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'No address selected',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Get.to(() => const AddressPage());
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  side: BorderSide(color: theme.colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add Address',
                  style: GoogleFonts.roboto(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Find default address or take the first one
      final address = user.addresses!.firstWhere(
        (element) => element.isDefault == true,
        orElse: () => user.addresses!.first,
      );

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: theme.colorScheme.surface,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deliver to: ${address.name ?? user.name}, ${address.phoneNumber}',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${address.street}, ${address.city}, ${address.state} - ${address.pinCode}',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                Get.to(() => const AddressPage());
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                side: BorderSide(color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Change',
                style: GoogleFonts.roboto(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCartItem(Size size, BuildContext context, var item,
      CartController controller, ThemeData theme) {
    final product = item.product;
    final double sellingPrice =
        product.mrp - (product.mrp * (product.discountPercentage / 100));

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: size.width * 0.25,
                height: size.width * 0.25,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Seller: RetailNet',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${sellingPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '₹${product.mrp.toStringAsFixed(0)}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${product.discountPercentage.toInt()}% Off',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF388E3C),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Actions
          Row(
            children: [
              // Quantity Control
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.updateQuantity(product, item.quantity - 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.remove, size: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: theme.colorScheme.surface,
                      child: Text(
                        '${item.quantity}',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.updateQuantity(product, item.quantity + 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.add, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Save for later',
                  style: GoogleFonts.roboto(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.removeFromCart(product);
                },
                child: Text(
                  'Remove',
                  style: GoogleFonts.roboto(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(CartController controller, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price (${controller.totalItems} items)',
                  style: GoogleFonts.roboto(fontSize: 16)),
              Text('₹${controller.totalMRP.toStringAsFixed(0)}',
                  style: GoogleFonts.roboto(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount', style: GoogleFonts.roboto(fontSize: 16)),
              Text('- ₹${controller.totalDiscount.toStringAsFixed(0)}',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Charges', style: GoogleFonts.roboto(fontSize: 16)),
              Row(
                children: [
                  Text('₹40',
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey)),
                  const SizedBox(width: 8),
                  Text('Free',
                      style: GoogleFonts.roboto(
                          fontSize: 16, color: Colors.green)),
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount',
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text('₹${controller.totalSellingPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'You will save ₹${controller.totalDiscount.toStringAsFixed(0)} on this order',
            style: GoogleFonts.roboto(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(OrderController orderController,
      CartController controller, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹${controller.totalSellingPrice.toStringAsFixed(0)}',
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View Price Details',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final userController = Get.find<UserController>();
              final user = userController.user.value;

              if (user == null ||
                  user.addresses == null ||
                  user.addresses!.isEmpty) {
                Get.snackbar(
                    "Address Required", "Please select a delivery address");
                return;
              }

              final address = user.addresses!.firstWhere(
                (element) => element.isDefault == true,
                orElse: () => user.addresses!.first,
              );

              if (orderController.isLoading.value) return;

              if (address.id == null || address.id == 0) {
                Get.snackbar("Address Required",
                    "Please select a valid delivery address or add a new one.");
                return;
              }

              orderController.initiateCheckout(
                  address.id!.toString(), controller.totalSellingPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: orderController.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: theme.colorScheme.onPrimary, strokeWidth: 2))
                : Text(
                    'Place Order',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildSafePayments(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: Colors.grey, size: 22),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Safe and Secure Payments. 100% Authentic Products.',
              style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
