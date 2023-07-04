import 'package:flutter/material.dart';
import 'package:pureone/data/carousel.dart';
import 'package:pureone/utils/indicators.dart';

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator(this.carouselIndex, {super.key});

  final int carouselIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: IndicatorList(
                length: carouselImages.length,
                objectIndex: carouselIndex,
                indicatorColor: Theme.of(context).colorScheme.primary,
                isHorizontal: true)
            .generate(),
      ),
    );
  }
}
