import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/providers/initial_state_provider.dart';
import 'package:pureone/screens/login.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/profile_option.dart';
import 'package:pureone/widgets/profile_option_container.dart';
import 'package:http/http.dart' as http;

class ProfileOptions extends ConsumerWidget {
  const ProfileOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box("store");
    final authToken = box.get("authToken", defaultValue: "");

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
                            ref
                                .read(initialStateProvider.notifier)
                                .updateAppLoaded(false);
                            box.delete("authToken");
                            ref.read(cartProvider.notifier).clearCart();
                            Navigator.of(context, rootNavigator: true).pop();
                            final url = Uri.http(baseUrl, "/api/auth/logout/");
                            http.post(
                              url,
                              headers: {
                                ...requestHeader,
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
          ProfileOption(
            label: "Edit Profile",
            icon: Icons.edit_square,
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
            label: "Support",
            icon: Icons.support_agent_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "About Us",
            icon: Icons.stars_rounded,
            onTap: () {},
          ),
          ProfileOption(
            label: "Logout",
            icon: Icons.logout_rounded,
            onTap: onClickLogout,
            iconColor: Colors.red[400],
          ),
        ]),
      ],
    );
  }
}
