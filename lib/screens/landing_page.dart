import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/cart_provider.dart';
import 'package:pureone/providers/initial_state_provider.dart';
import 'package:pureone/providers/user_provider.dart';
import 'package:pureone/screens/cart_screen.dart';
import 'package:pureone/screens/home_screen.dart';
import 'package:pureone/screens/profile_screen.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/utils/location_services.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pureone/widgets/no_location.dart';
import 'dart:convert';

import 'package:pureone/widgets/select_address_modal.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key, this.redirectTo = "Home"});

  final String redirectTo;

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  Widget renderScreen(String screenName) {
    Map<String, Widget> screenMap = {
      "Home": HomeScreen(),
      "Cart": const CartScreen(),
      "Profile": const ProfileScreen(),
    };

    return screenMap[screenName]!;
  }

  final box = Hive.box("store");
  late String currentScreen;
  bool isLoading = false;
  bool locationAvailable = false;

  @override
  void initState() {
    super.initState();
    currentScreen = widget.redirectTo;
  }

  void changeCurrentScreen(String screenName) {
    setState(() {
      currentScreen = screenName;
    });
  }

  List<String> _decodeCarouselData(List<dynamic> json) {
    return json.map((value) => value["banner"] as String).toList();
  }

  void _onClickLocation() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return const SelectAddressModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    final bool appLoaded =
        ref.watch(initialStateProvider.select((value) => value.appLoaded!));
    final UserLocation currentLocation =
        ref.watch(userProvider.select((value) => value.currentLocation));
    final String token = box.get("authToken", defaultValue: "");

    if (!appLoaded && token != "") {
      setState(() {
        isLoading = true;
      });
      final url = Uri.http(baseUrl, "/api/common/get-initial-state/");
      if (currentLocation.latitude == null ||
          currentLocation.longitude == null) {
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
                final showUpdateProfilePopup =
                    box.get("showUpdateProfilePopup", defaultValue: false);
                ref.read(initialStateProvider.notifier).updateInitialState(
                    true,
                    _decodeCarouselData(data["banner_images"]),
                    data["all_products"]);
                ref.read(userProvider.notifier).updateUserObject(data["user"]);
                ref.read(cartProvider.notifier).generateCartList(data["cart"]);

                getAddress(
                        value["location"].latitude, value["location"].longitude)
                    .then((response) {
                  ref.read(userProvider.notifier).addUserCurrentLocation(
                        lt: value["location"].latitude,
                        ln: value["location"].longitude,
                        shortAddress: response["shortAddress"],
                      );
                });

                if (data["show_popup"] != showUpdateProfilePopup) {
                  box.put("showUpdateProfilePopup", data["show_popup"]);
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
            final showUpdateProfilePopup =
                box.get("showUpdateProfilePopup", defaultValue: false);
            ref.read(initialStateProvider.notifier).updateInitialState(
                true,
                _decodeCarouselData(data["banner_images"]),
                data["all_products"]);
            ref.read(userProvider.notifier).updateUserObject(data["user"]);
            ref.read(cartProvider.notifier).generateCartList(data["cart"]);

            if (data["show_popup"] != showUpdateProfilePopup) {
              box.put("showUpdateProfilePopup", data["show_popup"]);
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

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 65,
        leadingWidth: MediaQuery.of(context).size.width * 0.75,
        leading: Container(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
              onPressed: _onClickLocation,
              icon: const Icon(Icons.gps_fixed_rounded),
              label: currentLocation.shortAddress != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: currentLocation.shortAddress != null
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          currentLocation.lastAddressComponent,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        if (currentLocation.secondLastAddressComponent != "")
                          Text(
                            currentLocation.secondLastAddressComponent,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          )
                      ],
                    )
                  : const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator())),
        ),
        actions: currentScreen == "Home"
            ? [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search_rounded,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ]
            : null,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Future(() {
                  ref
                      .read(initialStateProvider.notifier)
                      .updateAppLoaded(false);
                });
              },
              child: renderScreen(currentScreen)),
      bottomNavigationBar: CustomeBottomNavigationBar(
        onMenuSelected: changeCurrentScreen,
        currentScreenName: currentScreen,
      ),
    );
  }
}
