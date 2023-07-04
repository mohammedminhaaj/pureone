import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  const CustomBottomNavigationBarItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.isSelected,
      required this.onTap});

  final IconData icon;
  final String label;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25))
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).colorScheme.primary,
            )
                .animate(target: isSelected ? 1 : 0)
                .scaleXY(end: 0.8)
                .tint(color: Colors.white),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              )
          ],
        ),
      ),
    );
  }
}
