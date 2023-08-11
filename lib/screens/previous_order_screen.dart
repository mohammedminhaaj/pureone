import 'package:flutter/material.dart';
import 'package:pureone/models/order.dart';
import 'package:pureone/widgets/order_card.dart';

class PreviousOrderScreen extends StatelessWidget {
  const PreviousOrderScreen(
      {super.key, required this.orders, this.usePadding = false});

  final List<Order> orders;
  final bool usePadding;

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/no-data.png"),
              const Text(
                "Nothing to show here",
                style: TextStyle(fontSize: 20),
              )
            ],
          )
        : Padding(
            padding: EdgeInsets.only(
                top: usePadding ? 100 : 10, left: 10, right: 10, bottom: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) => OrderCard(order: orders[index]),
            ),
          );
  }
}
