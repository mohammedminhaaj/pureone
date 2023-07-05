import 'package:flutter/material.dart';
import 'package:pureone/data/menu.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar_item.dart';

class CustomeBottomNavigationBar extends StatelessWidget {
  const CustomeBottomNavigationBar(
      {super.key,
      required this.onMenuSelected,
      required this.currentScreenName});

  final Function(String) onMenuSelected;
  final String currentScreenName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(bottomNavBarMenuList.length, (index) {
            return CustomBottomNavigationBarItem(
              icon: bottomNavBarMenuList[index].icon,
              label: bottomNavBarMenuList[index].label,
              isSelected:
                  currentScreenName == bottomNavBarMenuList[index].label,
              onTap: () {
                onMenuSelected(bottomNavBarMenuList[index].label);
              },
            );
          })),
    );
  }
}
