class UserLocation {
  const UserLocation({
    this.latitude,
    this.longitude,
    this.shortAddress,
  });
  final double? latitude;
  final double? longitude;
  final String? shortAddress;

  UserLocation copyWith({double? lt, double? ln, String? shortAddress}) {
    return UserLocation(
      latitude: lt ?? latitude,
      longitude: ln ?? longitude,
      shortAddress: shortAddress ?? this.shortAddress,
    );
  }

  List<String> get _addressComponents {
    return shortAddress != null ? shortAddress!.split(", ") : [];
  }

  String get lastAddressComponent {
    final List<String> addrList = _addressComponents;
    try {
      return addrList[addrList.length - 1];
    } on RangeError {
      return "";
    }
  }

  String get secondLastAddressComponent {
    final List<String> addrList = _addressComponents;
    try {
      return addrList[addrList.length - 2];
    } on RangeError {
      return "";
    }
  }
}

class User {
  User(
      {this.username = "",
      this.mobileNumber = "",
      this.emailAddress = "",
      this.currentLocation = const UserLocation()});

  final String username;
  final String mobileNumber;
  final String emailAddress;
  UserLocation currentLocation;

  User copyWith(
      {String? email,
      String? mobile,
      String? username,
      UserLocation? currentLocation}) {
    return User(
        emailAddress: email ?? emailAddress,
        mobileNumber: mobile ?? mobileNumber,
        username: username ?? this.username,
        currentLocation: currentLocation ?? this.currentLocation);
  }
}
