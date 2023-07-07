import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pureone/providers/initial_state_provider.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/carousel_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Carousel extends ConsumerStatefulWidget {
  const Carousel({super.key});

  @override
  ConsumerState<Carousel> createState() => _CarouselState();
}

class _CarouselState extends ConsumerState<Carousel> {
  int carouselIndex = 0;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.999);

  Timer getTimer() {
    final List<String> carouselImageList =
        ref.read(initialStateProvider.select((value) => value.carouselImages));
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (carouselIndex == carouselImageList.length) {
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
    final List<String> carouselImageList =
        ref.read(initialStateProvider.select((value) => value.carouselImages));
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            allowImplicitScrolling: true,
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: carouselImageList.length,
            itemBuilder: (context, index) {
              return _buildPageItem(index, carouselImageList[index]);
            },
            onPageChanged: (index) {
              setState(() {
                carouselIndex = index;
              });
            },
          ),
        ),
        CarouselIndicator(carouselIndex, carouselImageList.length)
      ],
    );
  }

  Widget _buildPageItem(int index, String carouselImageUrl) {
    final imageUrl = Uri.http(baseUrl, carouselImageUrl).toString();
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
                image: CachedNetworkImageProvider(imageUrl))),
      ),
    );
  }
}
