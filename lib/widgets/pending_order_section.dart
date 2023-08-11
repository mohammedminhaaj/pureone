import 'package:flutter/material.dart';

class PendingOrderSection extends StatelessWidget {
  const PendingOrderSection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: child),
    );
  }
}
