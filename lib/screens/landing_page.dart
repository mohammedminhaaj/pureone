import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/models/store.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/user_location_provider.dart';
import 'package:pureone/screens/cart_screen.dart';
import 'package:pureone/screens/home_screen.dart';
import 'package:pureone/screens/order_screen.dart';
import 'package:pureone/screens/profile_screen.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pureone/widgets/select_address_modal.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.redirectTo = "Home"});

  final String redirectTo;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    final NotificationSettings settings = await fcm.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await fcm.requestPermission();
    }
    final Box<Store> box = Hive.box<Store>("store");
    final Store store = box.get("storeObj", defaultValue: Store())!;

    if (settings.authorizationStatus == AuthorizationStatus.authorized &&
        !store.fcmTokenStored) {
      final Uri url = Uri.http(baseUrl, "/api/common/add-fcm-token/");
      final String authToken = store.authToken;
      http
          .post(url,
              body: json.encode({
                "registration_id": await fcm.getToken(),
                "platform": Platform.isAndroid
                    ? "android"
                    : Platform.isIOS
                        ? "ios"
                        : "web"
              }),
              headers: getAuthorizationHeaders(authToken))
          .then((response) {
        if (response.statusCode < 400) {
          store.fcmTokenStored = true;
          box.put("storeObj", store);
        } else {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
                const SnackBar(content: Text("Something went wrong")));
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text("Something went wrong")));
      });
    }
  }

  Widget renderScreen(String screenName) {
    Map<String, Widget> screenMap = {
      "Home": const HomeScreen(),
      "Cart": const CartScreen(),
      "Orders": const OrderScreen(),
      "Profile": const ProfileScreen(),
    };

    return screenMap[screenName]!;
  }

  late String currentScreen;

  @override
  void initState() {
    super.initState();
    setupPushNotification();
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
                            if (userLocation.selectedLocation != null)
                              if (userLocation.selectedLocation!
                                  .secondLastAddressComponent.isNotEmpty)
                                Text(
                                  userLocation.selectedLocation!
                                      .secondLastAddressComponent,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                )
                              else
                                const SizedBox.shrink()
                            else if (userLocation.currentLocation != null)
                              if (userLocation.currentLocation!
                                  .secondLastAddressComponent.isNotEmpty)
                                Text(
                                  userLocation.currentLocation!
                                      .secondLastAddressComponent,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                )
                              else
                                const SizedBox.shrink()
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
