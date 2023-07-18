import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/cart.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/screens/product_details.dart';
import 'package:pureone/settings.dart';

class CartItem extends ConsumerWidget {
  const CartItem({super.key, required this.cart, this.includeDivider = false});

  final Cart cart;
  final bool includeDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = Uri.http(baseUrl, cart.product!.image!).toString();
    return Column(
      children: [
        Dismissible(
            onDismissed: (DismissDirection direction) {
              ref.read(cartProvider.notifier).deleteCart(
                  product: cart.product!,
                  selectedQuantity: cart.selectedQuantity!);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Item removed from your cart!"),
              ));
            },
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.keyboard_double_arrow_left_rounded,
                        color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Swipe to delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.delete_forever_rounded, color: Colors.white)
                  ],
                ),
              ),
            ),
            key: UniqueKey(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  onTap: () {
                    final url =
                        Uri.http(baseUrl, cart.product!.image!).toString();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ProductDetail(
                            name: cart.product!.name, productImage: url)));
                  },
                  child: Row(
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    imageUrl,
                                  ))),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * .45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.product!.displayName,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                                Text(
                                  cart.product!.vendor,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.line_weight_rounded,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  cart.selectedQuantity!.quantity,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "\u{20B9}${cart.selectedQuantity!.price}",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_double_arrow_left_rounded,
                        color: Colors.red[100],
                      ),
                      Icon(
                        Icons.delete_rounded,
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Visibility(
            visible: includeDivider,
            child: const Divider(
              height: 20,
            ))
      ],
    );
  }
}
