class UserAddress {
  const UserAddress(
      {this.latitude,
      this.longitude,
      this.shortAddress,
      this.longAddress,
      this.building,
      this.locality,
      this.landmark});
  final double? latitude;
  final double? longitude;
  final String? shortAddress;
  final String? longAddress;
  final String? building;
  final String? locality;
  final String? landmark;

  UserAddress copyWith(
      {double? lt,
      double? ln,
      String? shortAddress,
      String? longAddress,
      String? building,
      String? locality,
      String? landmark}) {
    return UserAddress(
        latitude: lt ?? latitude,
        longitude: ln ?? longitude,
        shortAddress: shortAddress ?? this.shortAddress,
        longAddress: longAddress ?? this.longAddress,
        building: building ?? this.building,
        locality: locality ?? this.locality,
        landmark: landmark ?? this.landmark);
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

class UserLocation {
  const UserLocation({this.currentLocation, this.selectedLocation});

  final UserAddress? currentLocation;
  final UserAddress? selectedLocation;

  UserLocation copyWith(
      {UserAddress? currentLocation, UserAddress? selectedLocation}) {
    return UserLocation(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}
