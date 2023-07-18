import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/initial_state.dart';

class InitialStateNotifier extends StateNotifier<InitialState> {
  InitialStateNotifier() : super(InitialState());

  void updateAppLoaded(bool appLoaded) {
    state = state.copyWith(appLoaded: appLoaded);
  }

  void updateInitialState(
      bool appLoaded, List<String> carouselImages, List<dynamic> allProducts) {
    state = state.copyWith(
        appLoaded: appLoaded,
        carouselImages: carouselImages,
        allProducts: allProducts);
  }
}

final initialStateProvider =
    StateNotifierProvider<InitialStateNotifier, InitialState>(
        (ref) => InitialStateNotifier());
