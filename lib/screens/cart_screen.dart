import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/cart.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/widgets/bill_summary.dart';
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
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const CartSection(
                            header: "Delivery",
                            child: Text("Delivery details go here")),
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
                            )),
                        const CartSection(
                            header: "Offers",
                            child: Text("Offer details go here")),
                        const CartSection(
                            header: "Bill Summary", child: BillSummary()),
                        const CartSection(
                            header: "Cancellation Policy",
                            child: Text(
                                "Orders once placed cannot be cancelled and are non-refundable")),
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
