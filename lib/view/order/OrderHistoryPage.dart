import 'package:e_commerce_app/controller/OrderController.dart';
import 'package:e_commerce_app/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final OrderController orderController = Get.find<OrderController>();

    // Ensure we fetch orders when opening the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.fetchUserOrders();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface, // Flipkart-like background
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: theme.colorScheme.primary, // Flipkart blue
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            // Search Bar & Filters Area
            Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                children: [
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                          children: [
                            _buildFilterChip(
                                theme,
                                'All',
                                orderController.selectedStatusFilter.value ==
                                    'All',
                                () =>
                                    orderController.updateStatusFilter('All')),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                                theme,
                                'Delivered',
                                orderController.selectedStatusFilter.value ==
                                    'Delivered',
                                () => orderController
                                    .updateStatusFilter('Delivered')),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                                theme,
                                'Cancelled',
                                orderController.selectedStatusFilter.value ==
                                    'Cancelled',
                                () => orderController
                                    .updateStatusFilter('Cancelled')),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                                theme,
                                'Processing',
                                orderController.selectedStatusFilter.value ==
                                    'Processing',
                                () => orderController
                                    .updateStatusFilter('Processing')),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6), // Separator

            // Order List
            Expanded(
              child: Obx(() {
                if (orderController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Use filteredOrders instead of userOrders directly
                final orders = orderController.filteredOrders;

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt,
                            size: 80, color: theme.colorScheme.onSurface),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => Get.offAllNamed(AppRoutes.homePage),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text('Start Shopping',
                              style:
                                  TextStyle(color: theme.colorScheme.surface)),
                        )
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    if (order.items == null || order.items!.isEmpty)
                      return const SizedBox();

                    return Column(
                      children: order.items!
                          .map((item) =>
                              _buildOrderCard(theme, context, order, item))
                          .toList(),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      ThemeData theme, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          border: Border.all(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      ThemeData theme, BuildContext context, OrderModel order, OrderItem item) {
    String statusText = order.status;

    String dateText = '';
    if (order.estimatedDeliveryDate != null) {
      try {
        final date = DateTime.parse(order.estimatedDeliveryDate!);
        if (order.status.toUpperCase() == 'DELIVERED') {
          dateText = "Delivered on ${DateFormat('MMM dd').format(date)}";
        } else {
          dateText = "Delivery by ${DateFormat('MMM dd').format(date)}";
        }
      } catch (e) {
        dateText = "";
      }
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.orderDetailsPage,
          arguments: {'order': order, 'item': item},
        );
      },
      child: Container(
        color: theme.colorScheme.surface,
        margin: const EdgeInsets.only(bottom: 2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(4),
                child: item.productImageUrl != null &&
                        item.productImageUrl!.isNotEmpty
                    ? Image.network(
                        item.productImageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, _, __) => Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: theme.colorScheme.onSurface),
                      )
                    : Icon(Icons.image_not_supported,
                        size: 30, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText.capitalizeFirst ?? statusText,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(statusText, theme),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.productName ?? 'Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Rating placeholders if delivered
                    if (order.status.toUpperCase() == 'DELIVERED')
                      Row(
                        children: [
                          _buildStar(theme.colorScheme.onSurface),
                          const SizedBox(width: 4),
                          _buildStar(theme.colorScheme.onSurface),
                          const SizedBox(width: 4),
                          _buildStar(theme.colorScheme.onSurface),
                          const SizedBox(width: 4),
                          _buildStar(theme.colorScheme.onSurface),
                          const SizedBox(width: 4),
                          _buildStar(theme.colorScheme.onSurface),
                          const SizedBox(width: 8),
                          Text(
                            "Rate Review Product",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface,
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),

              // Chevron
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toUpperCase()) {
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return theme.colorScheme.error;
      case 'SHIPPED':
        return theme.colorScheme.primary;
      case 'PLACED':
      case 'PENDING':
      case 'PROCESSING':
        return Colors.orange;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  Widget _buildStar(Color color) {
    return Icon(Icons.star, size: 20, color: color);
  }
}
