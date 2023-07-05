import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pureone/widgets/carousel.dart';
import 'package:pureone/widgets/categories.dart';
import 'package:pureone/widgets/sort_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [Carousel(), SortMenu(), Categories()],
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .moveY(duration: 700.ms, begin: -20, end: 0);
  }
}
