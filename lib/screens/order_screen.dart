import 'package:flutter/material.dart';
import 'package:pureone/screens/pending_order_screen.dart';
import 'package:pureone/screens/previous_order_screen.dart';

final Map<int, Widget> viewSelector = {
  0: const PendingOrderScreen(),
  1: const PreviousOrderScreen(),
};

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentScreen = ValueNotifier(0);
    final PageController controller = PageController();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        PageView.builder(
          controller: controller,
          itemBuilder: (context, index) => viewSelector[index],
          onPageChanged: (value) {
            currentScreen.value = value;
          },
        ),
        ValueListenableBuilder(
          valueListenable: currentScreen,
          builder: (context, currentIndex, child) {
            return Positioned(
              top: 10,
              child: Material(
                elevation: 10,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  width: 200,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        height: 40,
                        left: currentIndex == 0 ? 0 : 93,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(10),
                          width: 85,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (currentIndex != 0) {
                                controller.animateToPage(0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: currentIndex == 0
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (currentIndex != 1) {
                                controller.animateToPage(1,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "Previous",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: currentIndex == 1
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
