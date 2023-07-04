import 'package:flutter/material.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:pureone/widgets/carousel.dart';
import 'package:pureone/widgets/categories.dart';
import 'package:pureone/widgets/sort_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leadingWidth: double.infinity,
        leading: Container(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.gps_fixed_rounded),
              label: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bangalore",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.fade,
                        fontSize: 18),
                  ),
                  Text(
                    "Jayanagar, 8th Cross",
                    style: TextStyle(fontSize: 12, overflow: TextOverflow.fade),
                  )
                ],
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [Carousel(), SortMenu(), Categories()],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
