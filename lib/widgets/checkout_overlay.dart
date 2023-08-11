import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/data/payment_mode.dart';
import 'package:pureone/models/store.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/providers/user_location_provider.dart';
import 'package:pureone/screens/order_placed.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/payment_options.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutOverlay extends ConsumerStatefulWidget {
  const CheckoutOverlay(
      {super.key,
      required this.subTotal,
      required this.scrollController,
      required this.hasErrors,
      this.deliveryInstructions});

  final double subTotal;
  final ScrollController scrollController;
  final bool hasErrors;
  final String? deliveryInstructions;

  @override
  ConsumerState<CheckoutOverlay> createState() => _CheckoutOverlayState();
}

class _CheckoutOverlayState extends ConsumerState<CheckoutOverlay> {
  final Box<Store> box = Hive.box<Store>("store");
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void placeOrder(PaymentMode paymentMode, Store store) {
    final String authToken = store.authToken;
    final UserAddress selectedLocation =
        ref.read(userLocationProvider).selectedLocation!;
    switch (paymentMode) {
      case PaymentMode.cash:
        {
          final Uri url = Uri.http(baseUrl, "/api/order/place-order/cash/");
          isLoading.value = true;
          http
              .post(url,
                  headers: getAuthorizationHeaders(authToken),
                  body: json.encode({
                    "latitude": selectedLocation.latitude,
                    "longitude": selectedLocation.longitude,
                    "short_address": selectedLocation.shortAddress,
                    "long_address": selectedLocation.longAddress,
                    "building": selectedLocation.building,
                    "locality": selectedLocation.locality,
                    "landmark": selectedLocation.landmark,
                    "delivery_instructions": widget.deliveryInstructions
                  }))
              .then((response) {
            isLoading.value = false;
            final Map<dynamic, dynamic> data = json.decode(response.body);
            if (response.statusCode >= 400) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(data["details"])));
            } else {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.of(context, rootNavigator: true)
                  .pushReplacement(MaterialPageRoute(
                builder: (context) => const OrderPlaced(),
              ));
            }
          });
        }
        break;
      case PaymentMode.online:
        {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Not yet configured")));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final PaymentMode preferredPaymentMode =
        PaymentMode.values[store.preferredPaymentMode];
    final String paymentMode = paymentModeString[preferredPaymentMode]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
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
                    onPressed: () async {
                      final PaymentMode? selectedPaymentMode =
                          await showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) {
                                return PaymentOptions(
                                  paymentMode: preferredPaymentMode,
                                );
                              });
                      if (selectedPaymentMode != null) {
                        store.preferredPaymentMode = selectedPaymentMode.index;
                        box.put("storeObj", store);
                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_drop_up_rounded,
                      size: 30,
                    ),
                    label: Column(children: [
                      const Text(
                        "Pay using",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        paymentMode,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: isLoading,
                      builder: (context, isLoading, child) {
                        return ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.hasErrors || isLoading
                                  ? Colors.grey[500]
                                  : Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            onPressed: widget.hasErrors
                                ? () {
                                    if (widget.scrollController.hasClients) {
                                      widget.scrollController.animateTo(0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    }
                                  }
                                : () {
                                    placeOrder(preferredPaymentMode, store);
                                  },
                            icon: const Icon(
                                Icons.shopping_cart_checkout_rounded),
                            label: isLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      const Text("Place Order"),
                                      Text(
                                        "\u{20B9} ${widget.subTotal}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ));
                      },
                    ),
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
