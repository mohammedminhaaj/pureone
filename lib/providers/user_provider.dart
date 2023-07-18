import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pureone/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  void updateUsernameOrEmail({String? username, String? email}) {
    state = state.copyWith(username: username, email: email);
  }

  void updateUserObject(Map<dynamic, dynamic> json) {
    state = state.copyWith(
        email: json["email"] ?? "",
        mobile: json["mobile_number"] as String,
        username: json["username"] ?? "");
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
