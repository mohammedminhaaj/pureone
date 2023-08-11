import 'package:flutter/material.dart';
import 'package:pureone/data/status_color.dart';
import 'package:pureone/models/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderId,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      order.orderStatus,
                      style: const TextStyle(color: Colors.white),
                    ),
                    side: BorderSide.none,
                    backgroundColor: statusColor[order.orderStatus],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              for (final cart in order.cart)
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                          "${cart.quantityCount} x ${cart.product.displayName} (${cart.selectedQuantity.quantity})"),
                    ),
                  ],
                ),
              const Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.getLocalCreatedAt,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "\u{20B9} ${order.amount}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
