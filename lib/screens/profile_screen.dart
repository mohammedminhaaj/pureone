import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/providers/user_provider.dart';
import 'package:pureone/widgets/custom_avatar.dart';
import 'package:pureone/widgets/profile_screen_options.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const CustomAvatar(),
            const SizedBox(
              height: 20,
            ),
            Text(
              user.username,
              style: const TextStyle(fontSize: 35),
              textAlign: TextAlign.center,
            ),
            Text(
              user.mobileNumber,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            Text(
              user.emailAddress,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_rounded),
                label: const Text("Edit Profile")),
            const SizedBox(
              height: 20,
            ),
            const ProfileOptions(),
          ],
        ),
      ),
    );
  }
}
