import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/user.dart';

class UserLocationNotifier extends StateNotifier<UserLocation> {
  UserLocationNotifier() : super(const UserLocation());

  void addUserCurrentLocation(
      {double? lt, double? ln, String? shortAddress, String? longAddress}) {
    state = state.copyWith(
        currentLocation: UserAddress(
            latitude: lt,
            longitude: ln,
            shortAddress: shortAddress,
            longAddress: longAddress));
  }

  void addUserSelectedLocation(
      {double? lt, double? ln, String? shortAddress, String? longAddress}) {
    state = state.copyWith(
        selectedLocation: UserAddress(
            latitude: lt,
            longitude: ln,
            shortAddress: shortAddress,
            longAddress: longAddress));
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, UserLocation>(
        (ref) => UserLocationNotifier());
