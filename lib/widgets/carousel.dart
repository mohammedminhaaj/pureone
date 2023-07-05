import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pureone/data/carousel.dart';
import 'package:pureone/widgets/carousel_indicator.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int carouselIndex = 0;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.999);

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (carouselIndex == carouselImages.length) {
        carouselIndex = 0;
      }
      pageController.animateToPage(carouselIndex,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
      carouselIndex++;
    });
  }

  Timer? carouselTimer;

  @override
  void initState() {
    carouselTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    carouselTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            allowImplicitScrolling: true,
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: carouselImages.length,
            itemBuilder: (context, index) {
              return _buildPageItem(index);
            },
            onPageChanged: (index) {
              setState(() {
                carouselIndex = index;
              });
            },
          ),
        ),
        CarouselIndicator(carouselIndex)
      ],
    );
  }

  Widget _buildPageItem(int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTapDown: (_) {
        carouselTimer?.cancel();
        carouselTimer = null;
      },
      onTapCancel: () {
        carouselTimer = getTimer();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/${carouselImages[index]}"))),
      ),
    );
  }
}
