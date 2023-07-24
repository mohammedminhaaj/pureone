import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:pureone/models/store.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/providers/home_screen_builder_provider.dart';
import 'package:pureone/providers/user_location_provider.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/utils/location_services.dart';
import 'package:pureone/widgets/carousel.dart';
import 'package:pureone/widgets/home_screen_section.dart';
import 'package:pureone/widgets/no_location.dart';
import 'package:pureone/widgets/product_card.dart';
import 'package:pureone/widgets/sort_menu.dart';
import 'package:pureone/widgets/update_profile_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Box<Store> box = Hive.box<Store>("store");
  bool isLoading = false;

  List<String> _decodeCarouselData(List<dynamic> json) {
    return json.map((value) => value["banner"] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool homeScreenUpdated = ref.watch(
        homeScreenBuilderProvider.select((value) => value.homeScreenUpdated));
    final List<dynamic> allProducts = ref
        .read(homeScreenBuilderProvider.select((value) => value.allProducts));
    final UserLocation userLocation = ref.watch(userLocationProvider);
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final String token = store.authToken;
    final bool showUpdateProfilePopup = store.showUpdateProfilePopup;

    if (!homeScreenUpdated && token != "") {
      setState(() {
        isLoading = true;
      });
      final url = Uri.http(baseUrl, "/api/common/get-home-screen/");
      if (userLocation.currentLocation == null) {
        getCurrentLocation().then((value) {
          if (!value["serviceEnabled"]) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) => const NoLocation(
                    errorText:
                        "Looks like location service isn't available on your device.")));
          } else if (value["permissionGranted"] != PermissionStatus.granted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) => const NoLocation(
                    errorText:
                        "Please provide location permission on this device")));
          } else {
            http.get(url, headers: {
              ...requestHeader,
              "Authorization": "Token $token"
            }).then((response) {
              if (response.statusCode >= 400) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Something went wrong!")));
              } else {
                final data = json.decode(response.body);

                ref.read(homeScreenBuilderProvider.notifier).updateHomeScreen(
                      true,
                      _decodeCarouselData(data["banner_images"]),
                      data["all_products"],
                    );
                ref.read(cartProvider.notifier).generateCartList(data["cart"]);

                getAddress(
                        value["location"].latitude, value["location"].longitude)
                    .then((response) {
                  ref
                      .read(userLocationProvider.notifier)
                      .addUserCurrentLocation(
                        lt: value["location"].latitude,
                        ln: value["location"].longitude,
                        shortAddress: response["shortAddress"],
                        longAddress: response["longAddress"],
                      );
                });

                if (data["show_popup"] != showUpdateProfilePopup) {
                  store.showUpdateProfilePopup = data["show_popup"];
                  box.put("storeObj", store);
                }
                setState(() {
                  isLoading = false;
                });
              }
            }).onError((error, stackTrace) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Something went wrong!")));
            });
          }
        });
      } else {
        http.get(url, headers: {
          ...requestHeader,
          "Authorization": "Token $token"
        }).then((response) {
          if (response.statusCode >= 400) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Something went wrong!")));
          } else {
            final data = json.decode(response.body);
            ref.read(homeScreenBuilderProvider.notifier).updateHomeScreen(
                  true,
                  _decodeCarouselData(data["banner_images"]),
                  data["all_products"],
                );
            ref.read(cartProvider.notifier).generateCartList(data["cart"]);

            if (data["show_popup"] != showUpdateProfilePopup) {
              store.showUpdateProfilePopup = data["show_popup"];
              box.put("storeObj", store);
            }
            setState(() {
              isLoading = false;
            });
          }
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        });
      }
    }

    if (showUpdateProfilePopup) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (context) {
              return const UpdateProfileModal();
            });
        store.showUpdateProfilePopup = false;
        box.put("storeObj", store);
      });
    }
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          ref
              .read(homeScreenBuilderProvider.notifier)
              .setHomeScreenUpdated(false);
        });
      },
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                                price: currentProduct["product_quantity"]
                                    ["price"],
                                originalPrice:
                                    currentProduct["product_quantity"]
                                        ["original_price"]);
                          }),
                    ),
                  ),
                ],
              ),
            )
              .animate()
              .fadeIn(duration: 700.ms)
              .moveY(duration: 700.ms, begin: -20, end: 0),
    );
  }
}
