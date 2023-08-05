import 'package:flutter/material.dart';

class BillSummary extends StatelessWidget {
  const BillSummary(
      {super.key,
      required this.totalPrice,
      required this.deliveryCharge,
      required this.subTotal});

  final double totalPrice;
  final double deliveryCharge;
  final double subTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sub-Total",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "\u{20B9} $totalPrice",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Delivery",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "\u{20B9} $deliveryCharge",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "\u{20B9} $subTotal",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
