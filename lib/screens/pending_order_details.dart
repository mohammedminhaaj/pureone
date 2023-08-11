import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/order.dart';
import 'package:pureone/models/vendor.dart';
import 'package:pureone/providers/order_provider.dart';
import 'package:pureone/widgets/pending_order_status.dart';
import 'package:pureone/widgets/pending_order_vendor_details.dart';
import 'package:pureone/widgets/pending_order_map.dart';
import 'package:pureone/widgets/pending_order_section.dart';

class PendingOrderDetails extends ConsumerWidget {
  const PendingOrderDetails(
      {super.key, required this.orderId, this.includeAppBar = false});

  final String orderId;
  final bool includeAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AllOrders orders = ref.watch(orderProvider);
    final List<Vendor> vendorList = [];
    final Set<String> vendorNames = {};

    late final Order? order;
    try {
      order = orders.pendingOrders.singleWhere(
        (element) => element.orderId == orderId,
      );
    } on StateError {
      order = null;
    }

    if (order == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context, rootNavigator: true).pop();
      });
    } else {
      for (final cart in order.cart) {
        if (vendorNames.add(cart.product.vendor.displayName)) {
          vendorList.add(cart.product.vendor);
        }
      }
    }

    return order != null
        ? Scaffold(
            appBar: includeAppBar
                ? AppBar(
                    title: Text(order.orderId),
                    forceMaterialTransparency: true,
                  )
                : null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  PendingOrderMap(
                      orderLatitude: order.latitude,
                      orderLongitude: order.longitude,
                      vendorLtLn: vendorList
                          .map<List<double>>((e) => [e.latitude, e.longitude])
                          .toList()),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PendingOrderStatus(
                          order: order,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PendingOrderSection(
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.support_rounded,
                                      size: 30,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.70,
                                      child: const Text(
                                        "Need help with your order?",
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    )
                                  ],
                                ),
                                const Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PendingOrderVendorDetails(vendorList: vendorList),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const Scaffold();
  }
}
