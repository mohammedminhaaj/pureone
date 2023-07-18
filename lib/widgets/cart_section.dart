import 'package:flutter/material.dart';

class CartSection extends StatelessWidget {
  const CartSection({super.key, required this.header, required this.child});

  final String header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Material(
            elevation: 5,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: child,
            ),
          )
        ],
      ),
    );
  }
}
