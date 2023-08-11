import 'package:flutter/material.dart';
import 'package:pureone/models/vendor.dart';
import 'package:pureone/widgets/pending_order_section.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingOrderVendorDetails extends StatelessWidget {
  const PendingOrderVendorDetails({super.key, required this.vendorList});

  final List<Vendor> vendorList;

  @override
  Widget build(BuildContext context) {
    return PendingOrderSection(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.all(10),
          tilePadding: const EdgeInsets.all(0),
          leading: Icon(
            Icons.person_pin,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text(
            "Vendor Details",
            style: TextStyle(fontSize: 17),
          ),
          children: vendorList
              .map<Widget>((element) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  element.displayName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  element.address,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () async {
                                final url =
                                    Uri(scheme: 'tel', path: element.contact);
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url);
                                }
                              },
                              icon: Icon(
                                Icons.phone_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ))
                        ],
                      ),
                      Visibility(
                        visible: vendorList.indexOf(element) !=
                            vendorList.length - 1,
                        child: const Divider(
                          height: 20,
                        ),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
