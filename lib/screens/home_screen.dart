import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/providers/initial_state_provider.dart';
import 'package:pureone/widgets/carousel.dart';
import 'package:pureone/widgets/home_screen_section.dart';
import 'package:pureone/widgets/product_card.dart';
import 'package:pureone/widgets/sort_menu.dart';
import 'package:pureone/widgets/update_profile_modal.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final box = Hive.box("store");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dynamic> allProducts =
        ref.read(initialStateProvider.select((value) => value.allProducts));

    final showUpdateProfilePopup =
        box.get("showUpdateProfilePopup", defaultValue: false);
    if (showUpdateProfilePopup) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return const UpdateProfileModal();
            });
        box.put("showUpdateProfilePopup", false);
      });
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const Carousel(),
          const SortMenu(),
          HomeScreenSection(
            header: "Categories",
            onPressed: () {},
            child: const Text("Categories"),
          ),
          HomeScreenSection(
            header: "All",
            onPressed: () {},
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                  itemCount: allProducts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final Map<String, dynamic> currentProduct =
                        allProducts[index];
                    return ProductCard(
                        image: currentProduct["image"],
                        name: currentProduct["name"],
                        displayName: currentProduct["display_name"],
                        quantity: currentProduct["product_quantity"]
                            ["quantity"],
                        price: currentProduct["product_quantity"]["price"],
                        originalPrice: currentProduct["product_quantity"]
                            ["original_price"]);
                  }),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .moveY(duration: 700.ms, begin: -20, end: 0);
  }
}
