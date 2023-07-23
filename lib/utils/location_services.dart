import 'package:location/location.dart';
import 'package:pureone/settings.dart' as app_settings;
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, String> parseGmapResponse(List<dynamic> addressComponents) {
  final List<String> typesToExtract = [
    "route",
    "neighborhood",
    "sub_locality",
    "locality"
  ];
  return addressComponents.fold<Map<String, String>>({}, (result, element) {
    for (final type in typesToExtract) {
      if (element["types"].contains(type)) result[type] = element["short_name"];
    }
    return result;
  });
}

Future<Map<String, dynamic>> getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return {
        "serviceEnabled": false,
        "permissionGranted": PermissionStatus.denied,
        "location": null,
      };
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return {
        "serviceEnabled": true,
        "permissionGranted": PermissionStatus.denied,
        "location": null,
      };
    }
  }

  locationData = await location.getLocation();
  return {
    "serviceEnabled": serviceEnabled,
    "permissionGranted": permissionGranted,
    "location": locationData
  };
}

Future<Map<String, String>> getAddress(
  double lt,
  double ln,
) async {
  const api = app_settings.gmapApi;
  final Uri url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lt,$ln&key=$api");
  final response = await http.get(url);
  final data = json.decode(response.body);

  final List<dynamic> addressComponents =
      data["results"][0]["address_components"];
  final Map<String, String> parsedGmapResponse =
      parseGmapResponse(addressComponents);

  return {
    "longAddress": data["results"][0]["formatted_address"],
    "shortAddress": parsedGmapResponse.values.join(", ")
  };
}
