import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 0)
class Store {
  //user's authorization token which is used as a header while making requests
  @HiveField(0, defaultValue: "")
  String authToken;

  //determines if the onboarding screen should be displayed or not
  @HiveField(1, defaultValue: false)
  bool onboardingCompleted;

  //determines if the update profile modal should be displayed or not
  @HiveField(2, defaultValue: false)
  bool showUpdateProfilePopup;

  @HiveField(3, defaultValue: "")
  String username;

  @HiveField(4, defaultValue: [])
  List<dynamic> savedAddresses;

  @HiveField(5, defaultValue: "")
  String userEmail;

  Store(
      {this.authToken = "",
      this.onboardingCompleted = false,
      this.showUpdateProfilePopup = false,
      this.username = "",
      this.savedAddresses = const [],
      this.userEmail = ""});
}
