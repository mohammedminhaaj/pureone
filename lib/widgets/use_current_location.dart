import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/home_screen_builder_provider.dart';
import 'package:pureone/providers/user_location_provider.dart';
import 'package:pureone/screens/landing_page.dart';
import 'package:pureone/utils/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UseCurrentLocation extends ConsumerStatefulWidget {
  const UseCurrentLocation({super.key});

  @override
  ConsumerState<UseCurrentLocation> createState() => _UseCurrentLocationState();
}

class _UseCurrentLocationState extends ConsumerState<UseCurrentLocation> {
  double? _lt;
  double? _ln;
  String? _longAddress;
  String? _shortAddress;

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((value) {
      setState(() {
        if (value["serviceEnabled"] &&
            value["permissionGranted"] == PermissionStatus.granted) {
          _lt = value["location"].latitude;
          _ln = value["location"].longitude;
        } else {
          final UserAddress? currentLocation = ref.read(
              userLocationProvider.select((value) => value.currentLocation));
          _lt = currentLocation != null && currentLocation.latitude != null
              ? currentLocation.latitude
              : 12.9716;
          _ln = currentLocation != null && currentLocation.longitude != null
              ? currentLocation.longitude
              : 77.5946;
        }
        getAddress(_lt!, _ln!).then((value) {
          setState(() {
            _longAddress = value["longAddress"];
            _shortAddress = value["shortAddress"];
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Use current location"),
      ),
      body: SafeArea(
        child: _lt != null && _ln != null
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                      onTap: (location) {
                        setState(() {
                          _lt = location.latitude;
                          _ln = location.longitude;
                          _longAddress = null;
                          _shortAddress = null;
                          getAddress(_lt!, _ln!).then((value) {
                            setState(() {
                              _longAddress = value["longAddress"];
                              _shortAddress = value["shortAddress"];
                            });
                          });
                        });
                      },
                      markers: {
                        Marker(
                            markerId: const MarkerId('currentPosition'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure),
                            position: LatLng(_lt!, _ln!))
                      },
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      myLocationEnabled: true,
                      buildingsEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(_lt!, _ln!), zoom: 17)),
                  Container(
                    margin: const EdgeInsets.all(25),
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _longAddress != null
                            ? Text(
                                "$_longAddress",
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        shape: const ContinuousRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25))),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Colors.white),
                                    onPressed: _longAddress != null
                                        ? () {
                                            ref
                                                .read(userLocationProvider
                                                    .notifier)
                                                .addUserCurrentLocation(
                                                  lt: _lt,
                                                  ln: _ln,
                                                  shortAddress: _shortAddress,
                                                  longAddress: _longAddress,
                                                );
                                            ref
                                                .read(homeScreenBuilderProvider
                                                    .notifier)
                                                .setHomeScreenUpdated(false);

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .popUntil((route) {
                                              return route.isFirst;
                                            });
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const LandingPage()));
                                          }
                                        : null,
                                    label: const Text("Confirm Location"),
                                    icon: const Icon(Icons.check_rounded),
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
