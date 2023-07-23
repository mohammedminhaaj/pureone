import 'package:flutter/material.dart';
import 'package:pureone/widgets/select_address_modal.dart';

class NoLocation extends StatelessWidget {
  const NoLocation({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/no-location.png"),
            const SizedBox(
              height: 20,
            ),
            Text(errorText),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return const SelectAddressModal();
                      });
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Add Address Manually"))
          ],
        ),
      ),
    );
  }
}
