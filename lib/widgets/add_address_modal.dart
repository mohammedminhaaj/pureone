import 'package:flutter/material.dart';
import 'package:pureone/widgets/add_address_form.dart';

class AddAddressModal extends StatelessWidget {
  const AddAddressModal(
      {super.key,
      required this.lt,
      required this.ln,
      required this.shortAddress,
      required this.longAddress});

  final double lt;
  final double ln;
  final String longAddress;
  final String shortAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: AddAddressForm(
        lt: lt,
        ln: ln,
        shortAddress: shortAddress,
        longAddress: longAddress,
      ),
    );
  }
}
