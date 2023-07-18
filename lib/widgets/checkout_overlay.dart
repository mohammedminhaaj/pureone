import 'package:flutter/material.dart';

class CheckoutOverlay extends StatelessWidget {
  const CheckoutOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Colors.white
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: const Text("Hello world"),
    );
  }
}
