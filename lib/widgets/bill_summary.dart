import 'package:flutter/material.dart';

class BillSummary extends StatelessWidget {
  const BillSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sub-Total",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "\u{20B9} 200",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delivery",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "\u{20B9} 10",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Discount",
              style: TextStyle(fontSize: 14),
            ),
            Text(
              "- \u{20B9} 20",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "\u{20B9} 190",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
