class Vendor {
  const Vendor(
      {required this.displayName,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.status});

  final String displayName;
  final double latitude;
  final double longitude;
  final String address;
  final String status;

  factory Vendor.fromJson(Map<dynamic, dynamic> json) {
    return Vendor(
        displayName: json["display_name"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        address: json["address"],
        status: json["vendor_status"]);
  }

  factory Vendor.empty() {
    return const Vendor(
        displayName: "",
        latitude: 0.0,
        longitude: 0.0,
        address: "",
        status: "");
  }
}
