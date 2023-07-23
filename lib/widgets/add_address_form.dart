import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pureone/utils/input_decoration.dart';
import 'package:pureone/widgets/authentication/form_error.dart';

class AddAddressForm extends StatefulWidget {
  const AddAddressForm(
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
  State<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<AddAddressForm> {
  String _building = "";
  String _locality = "";
  String? _landmark;
  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final box = Hive.box("store");

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = Uri.http(baseUrl, "/api/user/add-user-location/");
      final authToken = box.get("authToken");
      http
          .post(url,
              headers: {...requestHeader, "Authorization": "Token $authToken"},
              body: json.encode({
                "latitude": widget.lt,
                "longitude": widget.ln,
                "short_address": widget.shortAddress,
                "long_address": widget.longAddress,
                "building": _building,
                "locality": _locality,
                "landmark": _landmark,
              }))
          .then((response) {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("details")) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data["details"])));
        }
        if (response.statusCode >= 400) {
          if (data.containsKey("errors")) {
            setState(() {
              _errorDict = data["errors"];
            });
          }
        } else {
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (ctx) => PasswordSent(
          //           email: _email,
          //         )));
        }
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong!")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
              "Add Address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length > 50) {
                      return "Please enter a valid value";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _building = value!;
                  },
                  decoration: setInputDecoration(
                      context: context,
                      label: const Text("Flat / House no / Floor / Building"),
                      prefixIcon: const Icon(Icons.house_rounded),
                      hasError: _errorDict.containsKey("building")),
                ),
                if (_errorDict.containsKey("building"))
                  FormError(errors: _errorDict["building"]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length > 50) {
                      return "Please enter a valid value";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _locality = value!;
                  },
                  decoration: setInputDecoration(
                      context: context,
                      label: const Text("Area / Sector / Locality"),
                      prefixIcon: const Icon(Icons.landscape_rounded),
                      hasError: _errorDict.containsKey("locality")),
                ),
                if (_errorDict.containsKey("locality"))
                  FormError(errors: _errorDict["locality"]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.trim().length > 50) {
                      return "Please enter a valid value";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _landmark = value!;
                  },
                  decoration: setInputDecoration(
                      context: context,
                      label: const Text("Landmark (Optional)"),
                      prefixIcon: const Icon(Icons.push_pin_rounded),
                      hasError: _errorDict.containsKey("landmark")),
                ),
                if (_errorDict.containsKey("landmark"))
                  FormError(errors: _errorDict["landmark"]),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isLoading
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(400, 60)),
                    onPressed: isLoading ? null : _submitForm,
                    icon: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded),
                    label: const Text('Save Address')),
              ],
            ))
      ],
    );
  }
}
