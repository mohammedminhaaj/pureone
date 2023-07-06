import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/screens/login.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/profile_option.dart';
import 'package:pureone/widgets/profile_option_container.dart';
import 'package:http/http.dart' as http;

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("store");
    final authToken = box.get("token");

    void onClickLogout() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Icon(Icons.question_mark_rounded),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          icon: const Icon(Icons.close_rounded),
                          label: const Text("No")),
                      ElevatedButton.icon(
                          onPressed: () {
                            box.delete("token");
                            Navigator.of(context, rootNavigator: true).pop();
                            final url = Uri.http(
                                settings["baseUrl"]!, "/api/auth/logout/");
                            http.post(
                              url,
                              headers: {
                                ...settings["requestHeader"],
                                "Authorization": "Token $authToken"
                              },
                            );
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const LoginScreen()));
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text("Yes")),
                    ],
                  )
                ],
              ));
    }

    return Column(
      children: [
        ProfileOptionContainer(header: "Account", children: [
          ProfileOption(
            label: "My Orders",
            icon: Icons.restaurant_menu_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "My Reviews",
            icon: Icons.reviews_rounded,
            onTap: () {},
          ),
        ]),
        ProfileOptionContainer(header: "More", children: [
          ProfileOption(
            label: "App Settings",
            icon: Icons.settings_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "Logout",
            icon: Icons.logout_rounded,
            onTap: onClickLogout,
          ),
        ]),
      ],
    );
  }
}
