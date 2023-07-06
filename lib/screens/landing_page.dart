import 'package:flutter/material.dart';
import 'package:pureone/screens/cart_screen.dart';
import 'package:pureone/screens/home_screen.dart';
import 'package:pureone/screens/profile_screen.dart';
import 'package:pureone/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Map<String, Widget> currentScreenMap = {
    "Home": const HomeScreen(),
    "Cart": const CartScreen(),
    "Profile": const ProfileScreen(),
  };

  String currentScreen = "Home";

  void changeCurrentScreen(String screenName) {
    setState(() {
      currentScreen = screenName;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: currentScreenMap[currentScreen],
      bottomNavigationBar: CustomeBottomNavigationBar(
        onMenuSelected: changeCurrentScreen,
        currentScreenName: currentScreen,
      ),
    );
  }
}
