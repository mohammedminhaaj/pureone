import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pureone/models/store.dart';
import 'package:pureone/screens/landing_page.dart';
import 'package:pureone/screens/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pureone/screens/onboarding_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    Hive.initFlutter().then((fn) {
      Hive.registerAdapter(StoreAdapter());
      Hive.openBox<Store>("store").then((fn) {
        runApp(const ProviderScope(child: App()));
      });
    });
  });
}

class App extends StatelessWidget {
  const App({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Box<Store> box = Hive.box<Store>("store");
    final Store store = box.get("storeObj", defaultValue: Store())!;
    final bool onboardingCompleted = store.onboardingCompleted;
    final String userLoggedIn = store.authToken;

    return MaterialApp(
      title: 'PureOne',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 90, 125)),
          bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white), //#005a7d
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: !onboardingCompleted
          ? const OnboardingScreen()
          : userLoggedIn == ""
              ? const LoginScreen()
              : const LandingPage(),
    );
  }
}
