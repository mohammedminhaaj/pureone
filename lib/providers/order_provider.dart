import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/order.dart';

class OrderNotifier extends StateNotifier<AllOrders> {
  OrderNotifier() : super(const AllOrders());

  void setAllOrders(Map<dynamic, dynamic> json) {
    state = AllOrders.fromJson(json);
  }

  void updatePendingOrderStatus(String orderId, String newStatus) {
    final AllOrders allOrders = state;
    try {
      final Order orderToUpdate = allOrders.pendingOrders
          .singleWhere((element) => element.orderId == orderId);
      orderToUpdate.orderStatus = newStatus;
      final bool moveOrder = ["Delivered", "Undelivered", "Rejected"]
          .contains(orderToUpdate.orderStatus);
      if (moveOrder) {
        allOrders.pendingOrders
            .removeWhere((element) => element.orderId == orderToUpdate.orderId);
        allOrders.previousOrders.add(orderToUpdate);
      }
      state = state.copyWith(
          pendingOrders: allOrders.pendingOrders,
          previousOrders: moveOrder ? allOrders.previousOrders : null);
    } on StateError {
      //Ignore StateErrors
    }
  }
}

final orderProvider =
    StateNotifierProvider<OrderNotifier, AllOrders>((ref) => OrderNotifier());
