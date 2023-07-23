import 'package:flutter/material.dart';

class QuantityChip extends StatelessWidget {
  const QuantityChip(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTap});

  final String label;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
            maxHeight: 45, maxWidth: 80, minHeight: 45, minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
            Visibility(
                visible: isSelected,
                child: const SizedBox(
                  width: 5,
                )),
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
