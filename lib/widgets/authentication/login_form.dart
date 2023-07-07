import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/screens/forgot_password.dart';
import 'package:pureone/screens/landing_page.dart';
import 'package:pureone/screens/sign_up.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/authentication/form_error.dart';
import 'package:pureone/widgets/authentication/mobile_or_email_field.dart';
import 'package:pureone/utils/input_decoration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _emailNumber = "";
  String _password = "";
  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  final box = Hive.box("store");

  final _formKey = GlobalKey<FormState>();

  void _setEmailNumber(String emailNumber) {
    _emailNumber = emailNumber;
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = Uri.http(baseUrl, "/api/auth/login/credential/");
      http
          .post(url,
              headers: requestHeader,
              body: json.encode({
                "email_number": _emailNumber,
                "password": _password,
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
        if (response.statusCode >= 400 && data.containsKey("errors")) {
          setState(() {
            _errorDict = data["errors"];
          });
        } else {
          box.put("authToken", data["auth_token"]);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const LandingPage()));
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              MobileOrEmailField(
                  setEmailNumber: _setEmailNumber,
                  hasError: _errorDict.containsKey("email_number")),
              if (_errorDict.containsKey("email_number"))
                FormError(errors: _errorDict["email_number"]),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 6 ||
                      value.trim().length > 128) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                decoration: setInputDecoration(
                    context: context,
                    label: const Text("Password"),
                    prefixIcon: const Icon(Icons.lock_rounded),
                    hasError: _errorDict.containsKey("password")),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              if (_errorDict.containsKey("password"))
                FormError(errors: _errorDict["password"]),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const SignUpScreen()));
                      },
                      child: const Text("Don't have an account?")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const ForgotPasswordScreen()));
                      },
                      child: const Text("Forgot password?")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          isLoading
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(400, 60))),
                  onPressed: isLoading ? null : _submitForm,
                  icon: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login_rounded),
                  label: const Text('Continue')),
            ],
          )),
    );
  }
}
