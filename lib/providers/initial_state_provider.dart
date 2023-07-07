import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/initial_state.dart';

class InitialStateNotifier extends StateNotifier<InitialState> {
  InitialStateNotifier() : super(InitialState());

  void updateAppLoaded(bool appLoaded) {
    state = state.copyWith(appLoaded: appLoaded);
  }

  void updateInitialState(bool appLoaded, List<String> carouselImages) {
    state =
        state.copyWith(appLoaded: appLoaded, carouselImages: carouselImages);
  }
}

final initialStateProvider =
    StateNotifierProvider<InitialStateNotifier, InitialState>(
        (ref) => InitialStateNotifier());
