import 'package:pureone/models/cart.dart';
import 'package:pureone/models/product.dart';
import 'package:pureone/utils/datetime.dart';

class Order {
  final String orderId;
  String orderStatus;
  final String paymentMode;
  final String amount;
  final String address;
  final String createdAt;
  final List<Cart> cart;
  final String? deliveryInstructions;
  final String latitude;
  final String longitude;

  Order(
      {required this.orderId,
      required this.orderStatus,
      required this.paymentMode,
      required this.amount,
      required this.address,
      this.deliveryInstructions,
      required this.cart,
      required this.createdAt,
      required this.latitude,
      required this.longitude});

  String get getLocalCreatedAt {
    final DateTime parsedDateTime = DateTime.parse(createdAt);

    final DateTime localDateTime = parsedDateTime.toLocal();

    return formatDate(localDateTime);
  }
}

class AllOrders {
  const AllOrders(
      {this.pendingOrders = const [], this.previousOrders = const []});

  final List<Order> pendingOrders;
  final List<Order> previousOrders;

  factory AllOrders.fromJson(Map<dynamic, dynamic> json) {
    final List<Order> pendingOrders = json["pending"]
        .map<Order>((element) => Order(
            orderId: element["order_id"],
            orderStatus: element["order_status"],
            paymentMode: element["payment_mode"],
            amount: element["amount"],
            address: element["address"],
            createdAt: element["created_at"],
            latitude: element["latitude"],
            deliveryInstructions: element["delivery_instructions"],
            longitude: element["longitude"],
            cart: element["cart"]
                .map<Cart>((cartItem) => Cart(
                    product: Product.fromJson(cartItem["product"]),
                    selectedQuantity:
                        ProductQuantity.fromJson(cartItem["product_quantity"]),
                    quantityCount: cartItem["quantity_count"]))
                .toList()))
        .toList();
    final List<Order> previousOrders = json["previous"]
        .map<Order>((element) => Order(
            orderId: element["order_id"],
            orderStatus: element["order_status"],
            paymentMode: element["payment_mode"],
            amount: element["amount"],
            address: element["address"],
            deliveryInstructions: element["delivery_instructions"],
            createdAt: element["created_at"],
            latitude: element["latitude"],
            longitude: element["longitude"],
            cart: element["cart"]
                .map<Cart>((cartItem) => Cart(
                    product: Product.fromJson(cartItem["product"]),
                    selectedQuantity:
                        ProductQuantity.fromJson(cartItem["product_quantity"]),
                    quantityCount: cartItem["quantity_count"]))
                .toList()))
        .toList();
    return AllOrders(
        pendingOrders: pendingOrders, previousOrders: previousOrders);
  }

  AllOrders copyWith(
      {List<Order>? previousOrders, List<Order>? pendingOrders}) {
    return AllOrders(
      previousOrders: previousOrders ?? this.previousOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
    );
  }
}
