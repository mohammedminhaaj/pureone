import 'package:flutter/material.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/user_location_provider.dart';
import 'package:pureone/screens/cart_screen.dart';
import 'package:pureone/screens/home_screen.dart';
import 'package:pureone/screens/profile_screen.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pureone/widgets/select_address_modal.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.redirectTo = "Home"});

  final String redirectTo;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget renderScreen(String screenName) {
    Map<String, Widget> screenMap = {
      "Home": const HomeScreen(),
      "Cart": const CartScreen(),
      "Profile": const ProfileScreen(),
    };

    return screenMap[screenName]!;
  }

  late String currentScreen;

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
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 65,
        leadingWidth: MediaQuery.of(context).size.width * 0.75,
        leading: Consumer(
          builder: (context, ref, child) {
            final UserLocation userLocation = ref.watch(userLocationProvider);
            return Container(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                  onPressed: userLocation.currentLocation != null
                      ? _onClickLocation
                      : () {},
                  icon: const Icon(Icons.gps_fixed_rounded),
                  label: userLocation.currentLocation != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userLocation.selectedLocation != null
                                  ? userLocation
                                      .selectedLocation!.lastAddressComponent
                                  : userLocation
                                      .currentLocation!.lastAddressComponent,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 18),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                            if (userLocation.selectedLocation != null &&
                                userLocation.selectedLocation!
                                        .secondLastAddressComponent !=
                                    "")
                              Text(
                                userLocation.selectedLocation!
                                    .secondLastAddressComponent,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              )
                            else if (userLocation.currentLocation != null &&
                                userLocation.currentLocation!
                                        .secondLastAddressComponent !=
                                    "")
                              Text(
                                userLocation.currentLocation!
                                    .secondLastAddressComponent,
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
            );
          },
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
      body: renderScreen(currentScreen),
      bottomNavigationBar: CustomeBottomNavigationBar(
        onMenuSelected: changeCurrentScreen,
        currentScreenName: currentScreen,
      ),
    );
  }
}
