import 'package:flutter/material.dart';
import 'package:pureone/models/menu_item.dart';

final List<BottomMenuItem> bottomNavBarMenuList = [
  BottomMenuItem(Icons.home_rounded, "Home"),
  BottomMenuItem(Icons.favorite_rounded, "Favorite"),
  BottomMenuItem(Icons.shopping_cart_rounded, "Cart"),
  BottomMenuItem(Icons.person_rounded, "Profile"),
];

final List<String> sortMenuList = [
  "Featured",
  "Price: Low",
  "Price: High",
  "Popularity",
  "Newest",
  "A-Z",
];
