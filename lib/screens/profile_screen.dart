import 'package:flutter/material.dart';
import 'package:pureone/widgets/custom_avatar.dart';
import 'package:pureone/widgets/profile_screen_options.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Mohammed Minhaaj",
              style: TextStyle(fontSize: 35),
              textAlign: TextAlign.center,
            ),
            const Text(
              "7760485260",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const Text(
              "mohammedminhaaj97@gmail.com",
              style: TextStyle(fontSize: 15),
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
