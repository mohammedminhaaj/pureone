import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/user_provider.dart';
import 'package:pureone/widgets/add_address.dart';
import 'package:pureone/widgets/use_current_location.dart';

class SelectAddressModal extends StatelessWidget {
  const SelectAddressModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30,
                  )),
              const Text(
                "Select Location",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const UseCurrentLocation()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pin_drop_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Use my current location",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final UserLocation userAddress = ref.read(
                                userProvider
                                    .select((value) => value.currentLocation));
                            return Text(
                              userAddress.shortAddress != null
                                  ? userAddress.shortAddress!
                                  : "Location was not detected",
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                )
              ],
            ),
          ),
          const Divider(
            height: 20,
          ),
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddAddress()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Add Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Saved Addresses",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            child: Column(children: [
              Image.asset(
                "assets/images/empty.png",
                colorBlendMode: BlendMode.multiply,
                height: 250,
                width: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Nothing to show here.")
            ]),
          ),
        ],
      ),
    );
  }
}
