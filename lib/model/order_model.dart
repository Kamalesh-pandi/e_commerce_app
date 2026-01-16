import 'package:e_commerce_app/model/user_model.dart';

class OrderModel {
  final int? id; // Changed to int to match backend Long
  final List<OrderItem>? items;
  final double totalAmount;
  final String status;
  final String? paymentId;
  final String? razorpayOrderId;
  final String? orderDate;
  final String? estimatedDeliveryDate;
  final Address? address;

  OrderModel({
    this.id,
    this.items,
    required this.totalAmount,
    required this.status,
    this.paymentId,
    this.razorpayOrderId,
    this.orderDate,
    this.estimatedDeliveryDate,
    this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] ?? 'PENDING',
      paymentId: json['razorpayPaymentId'],
      razorpayOrderId: json['razorpayOrderId'],
      orderDate: json['orderDate'],
      estimatedDeliveryDate: json['estimatedDeliveryDate'],
      address: json['shippingAddress'] != null
          ? Address.fromJson(json['shippingAddress'])
          : (json['address'] != null
              ? Address.fromJson(json['address'])
              : null),
      items: (json['orderItems'] as List<dynamic>?)
          ?.map((i) => OrderItem.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'status': status,
      'razorpayOrderId': razorpayOrderId,
      'orderDate': orderDate,
      'estimatedDeliveryDate': estimatedDeliveryDate,
      'address': address?.toJson(),
      'orderItems': items?.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int? id;
  final int productId;
  final String? productName;
  final String? productImageUrl; // For display
  final int quantity;
  final double price;

  OrderItem(
      {this.id,
      required this.productId,
      this.productName,
      this.productImageUrl,
      required this.quantity,
      required this.price});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handling nested product object from backend
    final product = json['product'];
    return OrderItem(
      id: json['id'],
      productId: product != null ? product['id'] : 0,
      productName: product != null ? product['name'] : 'Unknown Product',
      productImageUrl: product != null ? product['imageUrl'] : null,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId, // Simplified for now
      'quantity': quantity,
      'price': price,
    };
  }
}
