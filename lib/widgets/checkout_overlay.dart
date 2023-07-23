import 'package:flutter/material.dart';

class CheckoutOverlay extends StatelessWidget {
  const CheckoutOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Colors.white
                ],
                tileMode: TileMode.mirror,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_drop_up_rounded,
                      size: 30,
                    ),
                    label: const Column(children: [
                      Text(
                        "Pay using",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Cash",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart_checkout_rounded),
                        label: const Text("Place Order")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
