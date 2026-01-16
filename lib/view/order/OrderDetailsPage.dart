import 'package:e_commerce_app/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce_app/controller/OrderController.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final OrderModel initialOrder = args['order'];
    final OrderItem item = args['item'];
    final theme = Theme.of(context);
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Order Details",
          style: GoogleFonts.roboto(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        // Find the reactive order from controller
        final order = orderController.userOrders.firstWhere(
            (o) => o.id == initialOrder.id,
            orElse: () => initialOrder);

        String dateText = '';
        if (order.estimatedDeliveryDate != null) {
          try {
            final date = DateTime.parse(order.estimatedDeliveryDate!);
            dateText = DateFormat('EEE, MMM d').format(date);
          } catch (_) {}
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Order ID - ORD${order.id}",
                  style: GoogleFonts.roboto(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
              const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? "Product Name",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.onSurface),
                          ),
                          child: item.productImageUrl != null
                              ? Image.network(
                                  item.productImageUrl!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Seller: RetailNet",
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "₹${item.price.toStringAsFixed(0) + ".00"}",
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 4, color: Color(0xFFF1F3F6)),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.status.toUpperCase() == 'CANCELLED')
                      Column(
                        children: [
                          _buildTrackerStep(
                            "Ordered",
                            "Your order has been placed",
                            true,
                            isLast: false,
                            isActive: true,
                            theme: theme,
                          ),
                          _buildTrackerStep(
                            "Cancelled",
                            "Your order was cancelled",
                            false,
                            isLast: true,
                            isActive: true,
                            theme: theme,
                            activeColor: theme.colorScheme.error,
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildTrackerStep(
                            "Ordered",
                            "Your order has been placed",
                            true,
                            isLast: false,
                            isActive: true,
                            theme: theme,
                          ),
                          _buildTrackerStep(
                            "Shipped",
                            "Expected by $dateText",
                            false,
                            isLast: false,
                            isActive: order.status.toUpperCase() == 'SHIPPED' ||
                                order.status.toUpperCase() == 'DELIVERED',
                            theme: theme,
                          ),
                          _buildTrackerStep(
                            "Delivered",
                            order.status.toUpperCase() == 'DELIVERED'
                                ? "Your item has been delivered"
                                : "Expected by $dateText",
                            false,
                            isLast: true,
                            isActive: order.status.toUpperCase() == 'DELIVERED',
                            theme: theme,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Divider(thickness: 4, color: Color(0xFFF1F3F6)),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shipping Details",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${order.address?.name ?? "User Name"},",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (order.address != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${order.address!.street ?? ''}, ${order.address!.city ?? ''}",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "${order.address!.state ?? ''} - ${order.address!.pinCode ?? ''}",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Phone: ${order.address!.phoneNumber ?? ''}",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        "Address details not available",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(thickness: 4, color: Color(0xFFF1F3F6)),

              // 5. Price Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price Details",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceRow(theme, "List Price",
                        "₹${item.price.toStringAsFixed(0) + ".00"}"),
                    _buildPriceRow(theme, "Selling Price",
                        "₹${item.price.toStringAsFixed(0) + ".00"}"),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "₹${item.price.toStringAsFixed(0) + ".00"}",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (order.status.toUpperCase() != 'DELIVERED' &&
                  order.status.toUpperCase() != 'CANCELLED')
                Container(
                  color: theme.colorScheme.surface,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Allow user to cancel
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: theme.colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                title: Text(
                                  "Cancel Order?",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface),
                                ),
                                content: Text(
                                  "Are you sure you want to cancel this order? This action cannot be undone.",
                                  style: GoogleFonts.roboto(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.8)),
                                ),
                                actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      if (order.id != null) {
                                        Get.find<OrderController>()
                                            .cancelOrder(order.id!);
                                      }
                                    },
                                    child: Text(
                                      "Cancel Order",
                                      style: GoogleFonts.roboto(
                                          color: theme.colorScheme.error,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Get.back(),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    child: Text(
                                      "Don't Cancel",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Cancel Order",
                            style: GoogleFonts.roboto(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.snackbar(
                                "Help", "Contact Support Feature Coming Soon",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2));
                          },
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: theme.colorScheme.onSurface),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Need Help?",
                            style: GoogleFonts.roboto(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTrackerStep(String title, String subtitle, bool isFirst,
      {required bool isLast,
      required bool isActive,
      required ThemeData theme,
      Color? activeColor}) {
    final color = isActive ? (activeColor ?? Colors.green) : Colors.grey[300];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                height: 40,
                width: 2,
                color: color,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: isActive
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: isActive
                      ? (activeColor ?? theme.colorScheme.onSurface)
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPriceRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
                fontSize: 14, color: theme.colorScheme.onSurface),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
                fontSize: 14, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
