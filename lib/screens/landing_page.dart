import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/providers/initial_state_provider.dart';
import 'package:pureone/providers/user_provider.dart';
import 'package:pureone/screens/cart_screen.dart';
import 'package:pureone/screens/home_screen.dart';
import 'package:pureone/screens/profile_screen.dart';
import 'package:pureone/settings.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  final Map<String, Widget> currentScreenMap = {
    "Home": const HomeScreen(),
    "Cart": const CartScreen(),
    "Profile": const ProfileScreen(),
  };

  final box = Hive.box("store");
  String currentScreen = "Home";
  bool isLoading = false;

  void changeCurrentScreen(String screenName) {
    setState(() {
      currentScreen = screenName;
    });
  }

  List<String> decodeCarouselData(List<dynamic> json) {
    return json.map((value) => value["banner"] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool appLoaded =
        ref.watch(initialStateProvider.select((value) => value.appLoaded!));
    final String token = box.get("authToken", defaultValue: "");
    if (!appLoaded && token != "") {
      setState(() {
        isLoading = true;
      });

      final url = Uri.http(baseUrl, "/api/common/get-initial-state/");
      http.get(url, headers: {
        ...requestHeader,
        "Authorization": "Token $token"
      }).then((response) {
        if (response.statusCode > 400) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong!")));
        } else {
          final data = json.decode(response.body);
          ref.read(initialStateProvider.notifier).updateInitialState(
              true, decodeCarouselData(data["banner_images"]));
          ref.read(userProvider.notifier).updateUserObject(data["user"]);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
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
        actions: currentScreen != "Profile"
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
          : currentScreenMap[currentScreen],
      bottomNavigationBar: CustomeBottomNavigationBar(
        onMenuSelected: changeCurrentScreen,
        currentScreenName: currentScreen,
      ),
    );
  }
}
