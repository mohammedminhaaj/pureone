import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/home_screen_builder.dart';

class HomeScreenBuilderNotifier extends StateNotifier<HomeScreenBuilder> {
  HomeScreenBuilderNotifier() : super(HomeScreenBuilder());

  void setHomeScreenUpdated(bool homeScreenUpdated) {
    state = state.copyWith(homeScreenUpdated: homeScreenUpdated);
  }

  void updateHomeScreen(bool homeScreenUpdated, List<String> carouselImages,
      List<dynamic> allProducts) {
    state = state.copyWith(
      homeScreenUpdated: homeScreenUpdated,
      carouselImages: carouselImages,
      allProducts: allProducts,
    );
  }
}

final homeScreenBuilderProvider =
    StateNotifierProvider<HomeScreenBuilderNotifier, HomeScreenBuilder>(
        (ref) => HomeScreenBuilderNotifier());
