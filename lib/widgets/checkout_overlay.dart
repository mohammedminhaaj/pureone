import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/data/payment_mode.dart';
import 'package:pureone/models/store.dart';
import 'package:pureone/widgets/payment_options.dart';

class CheckoutOverlay extends StatefulWidget {
  const CheckoutOverlay({super.key, required this.subTotal});

  final double subTotal;

  @override
  State<CheckoutOverlay> createState() => _CheckoutOverlayState();
}

class _CheckoutOverlayState extends State<CheckoutOverlay> {
  @override
  Widget build(BuildContext context) {
    final Box<Store> box = Hive.box<Store>("store");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final PaymentMode preferredPaymentMode =
        PaymentMode.values[store.preferredPaymentMode];
    final String paymentMode = paymentModeString[preferredPaymentMode]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: Material(
        elevation: 10,
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
                        label: Column(
                          children: [
                            const Text("Place Order"),
                            Text(
                              "\u{20B9} ${widget.subTotal}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
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
