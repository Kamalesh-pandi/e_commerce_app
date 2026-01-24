import 'package:e_commerce_app/controller/CartController.dart';

import 'package:e_commerce_app/service/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/routes/AppRoutes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:e_commerce_app/model/order_model.dart';

import 'package:e_commerce_app/controller/UserController.dart';
import 'package:e_commerce_app/model/user_model.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final CartController _cartController = Get.find<CartController>();
  final UserController _userController = Get.find<UserController>();
  late Razorpay _razorpay;

  var isLoading = false.obs;

  String? _pendingAddressId;
  String? _pendingRazorpayOrderId;

  var userOrders = <OrderModel>[].obs;

  // Search and Filter State
  var searchQuery = ''.obs;
  var selectedStatusFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchUserOrders();
  }

  void fetchUserOrders() async {
    isLoading.value = true;
    try {
      final orders = await _orderService.getUserOrders();
      userOrders.assignAll(orders);
    } catch (e) {
      Get.snackbar("Error", "Failed to load orders: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  // Filter Logic
  List<OrderModel> get filteredOrders {
    var orders = List<OrderModel>.from(userOrders);

    // Filter by Status
    if (selectedStatusFilter.value != 'All') {
      orders = orders
          .where((order) =>
              order.status.toUpperCase() ==
              selectedStatusFilter.value.toUpperCase())
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      orders = orders.where((order) {
        final idMatch = order.id.toString().contains(query);
        final productMatch = order.items?.any((item) =>
                (item.productName ?? '').toLowerCase().contains(query)) ??
            false;
        return idMatch || productMatch;
      }).toList();
    }

    // Sort descending by ID
    orders.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

    return orders;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateStatusFilter(String status) {
    selectedStatusFilter.value = status;
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  Future<void> initiateCheckout(String addressId, double amount) async {
    isLoading.value = true;
    _pendingAddressId = addressId;

    try {
      final razorpayOrderId = await _orderService.createRazorpayOrder(amount);

      if (razorpayOrderId != null) {
        _pendingRazorpayOrderId = razorpayOrderId;
        openRazorpay(amount, razorpayOrderId);
      } else {
        Get.snackbar("Error", "Failed to initiate payment",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
      isLoading.value = false;
    }
  }

  void openRazorpay(double amount, String orderId) {
    String contact = _userController.user.value?.phoneNumber ?? '';
    String email = _userController.user.value?.email ?? '';

    if (_pendingAddressId != null &&
        _userController.user.value?.addresses != null) {
      try {
        final address = _userController.user.value!.addresses!.firstWhere(
            (a) => a.id.toString() == _pendingAddressId,
            orElse: () => Address());
        if (address.phoneNumber != null && address.phoneNumber!.isNotEmpty) {
          contact = address.phoneNumber!;
        }
      } catch (e) {
      }
    }

    var options = {
      'key': 'rzp_test_RyuVrPFZgGCZrX',
      'amount': (amount * 100).toInt(),
      'name': 'E-Commerce App',
      'description': 'Order Payment',
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      isLoading.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      if (_pendingAddressId != null && _pendingRazorpayOrderId != null) {
        final order = await _orderService.createOrder(
            addressId: _pendingAddressId!,
            razorpayOrderId: response.orderId ?? _pendingRazorpayOrderId!,
            razorpayPaymentId: response.paymentId!,
            razorpaySignature: response.signature!);

        if (order != null) {
          Get.snackbar("Success", "Order Placed Successfully!",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2));
          _cartController.clearCart();
          Get.offAllNamed(AppRoutes.homePage);
        }
      }
    } catch (e) {
      String message = e.toString();
      if (message.startsWith("Exception: ")) {
        message = message.substring(11);
      }
      Get.snackbar("Error", message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
      _pendingAddressId = null;
      _pendingRazorpayOrderId = null;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isLoading.value = false;
    Get.snackbar(
        "Error", "Payment Failed: ${response.code} - ${response.message}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    isLoading.value = false;
    Get.snackbar("External Wallet", "Wallet: ${response.walletName}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }

  Future<void> cancelOrder(int orderId) async {
    isLoading.value = true;
    final success = await _orderService.cancelOrder(orderId);
    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Order cancelled successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
      fetchUserOrders(); // Refresh status
    } else {
      Get.snackbar("Error", "Failed to cancel order",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2));
    }
  }
}
