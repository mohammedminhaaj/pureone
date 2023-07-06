import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.all(Radius.circular(77)),
      child: CircleAvatar(
        radius: 78,
        backgroundColor: Colors.grey,
        child: ClipOval(
          child: Image.asset(
            "assets/images/profile-picture.png",
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
