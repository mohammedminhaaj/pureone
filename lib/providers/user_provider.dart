import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateUserObject(Map<dynamic, dynamic> json) {
    state = state.copyWith(
        email: json["email"] as String,
        mobile: json["mobile_number"] as String,
        username: json["username"] as String);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
