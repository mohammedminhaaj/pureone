import 'package:flutter/material.dart';
import 'package:pureone/data/menu.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar_item.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  String selectedMenu = "Home";

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
              isSelected: selectedMenu == bottomNavBarMenuList[index].label,
              onTap: () {
                setState(() {
                  selectedMenu = bottomNavBarMenuList[index].label;
                });
              },
            );
          })),
    );
  }
}
