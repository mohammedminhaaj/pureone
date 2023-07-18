import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/cart.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/widgets/cart_item.dart';
import 'package:pureone/widgets/cart_section.dart';
import 'package:pureone/widgets/checkout_overlay.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Cart> cartItems = ref.watch(cartProvider).reversed.toList();
    return cartItems.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/no-data.png"),
              const Text(
                "Nothing to show here.",
                style: TextStyle(fontSize: 20),
              )
            ],
          )
            .animate()
            .fadeIn(duration: 700.ms)
            .moveY(duration: 700.ms, begin: -20, end: 0)
        : Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 150),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CartSection(
                            header: "My Items",
                            child: Column(
                              children:
                                  List.generate(cartItems.length, (index) {
                                final includeDivider =
                                    index != cartItems.length - 1;
                                return CartItem(
                                  cart: cartItems[index],
                                  includeDivider: includeDivider,
                                );
                              }),
                            ))
                      ],
                    ),
                  )),
              const CheckoutOverlay()
            ],
          )
            .animate()
            .fadeIn(duration: 700.ms)
            .moveY(duration: 700.ms, begin: -20, end: 0);
  }
}
