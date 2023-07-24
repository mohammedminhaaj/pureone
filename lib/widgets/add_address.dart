import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pureone/models/user.dart';
import 'package:pureone/providers/user_location_provider.dart';
import 'package:pureone/utils/location_services.dart';
import 'package:pureone/widgets/add_address_modal.dart';

class AddAddress extends ConsumerStatefulWidget {
  const AddAddress({super.key});

  @override
  ConsumerState<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends ConsumerState<AddAddress> {
  double? _lt;
  double? _ln;
  String? _longAddress;
  String? _shortAddress;

  void _onClickAdd() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return AddAddressModal(
            lt: _lt!,
            ln: _ln!,
            longAddress: _longAddress!,
            shortAddress: _shortAddress!,
          );
        });
  }

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
        title: const Text("Add Address"),
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
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    shape: const ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white),
                                onPressed:
                                    _longAddress != null ? _onClickAdd : null,
                                label: const Text("Enter Address"),
                                icon: const Icon(Icons.add_location_rounded),
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
