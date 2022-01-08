import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unit/constants.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:unit/screens/admin/addResale_screen.dart';
import 'package:unit/screens/admin/admin_addCompound_screen.dart';
import 'package:unit/translations/locale_keys.g.dart';

class MapSelect extends StatefulWidget {
  static const id = 'MapSelect';
  @override
  _MapSelectState createState() => _MapSelectState();
}

class _MapSelectState extends State<MapSelect> {
  double latitude;
  double longitude;
  String error = '';
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(snippet: 'Address'),
    );
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void locatePosition() async {
    Position p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = p;
    LatLng latlatPosition = LatLng(p.latitude, p.longitude);
    CameraPosition camera =
        new CameraPosition(target: latlatPosition, zoom: 14);
    newGoogleMapContoller.animateCamera(CameraUpdate.newCameraPosition(camera));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    Map locationData = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
                mapType: MapType.terrain,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  newGoogleMapContoller = controller;
                  locatePosition();
                },
                markers: Set<Marker>.of(markers.values),
                onTap: (tapped) async {
                  markers.clear();
                  final coordinated = new geoco.Coordinates(
                    tapped.latitude,
                    tapped.longitude,
                  );
                  var address = await Geocoder.local
                      .findAddressesFromCoordinates(coordinated);
                  var firstAddress = address.first;
                  getMarkers(tapped.latitude, tapped.longitude);
                  latitude = tapped.latitude;
                  longitude = tapped.longitude;
                }),
            Positioned(
              left: size.width * 0.05,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButton(
                          color: kSecondaryColor,
                        ),
                        Text(
                          tr(LocaleKeys.choose_location),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: RawMaterialButton(
          onPressed: () {
            if (latitude != null && longitude != null) {
              if (locationData['addType'] == 'compound') {
                Navigator.pushNamed(context, AdminAddCompound.id, arguments: {
                  'govName': locationData['govName'],
                  'districtName': locationData['districtName'],
                  'govNameAr': locationData['govNameAr'],
                  'districtNameAr': locationData['districtNameAr'],
                  'areaName': locationData['areaName'],
                  'areaNameAr': locationData['areaNameAr'],
                  'latitude': latitude,
                  'longitude': longitude,
                });
              } else {
                Navigator.pushNamed(context, AddResale.id, arguments: {
                  'govName': locationData['govName'],
                  'districtName': locationData['districtName'],
                  'govNameAr': locationData['govNameAr'],
                  'districtNameAr': locationData['districtNameAr'],
                  'areaName': locationData['areaName'],
                  'areaNameAr': locationData['areaNameAr'],
                  'latitude': latitude,
                  'longitude': longitude,
                });
              }
            } else {
              setState(() {
                error = tr(LocaleKeys.please_select_a_location);
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: size.height * 0.06,
              width: size.width * 0.3,
              color: kPrimaryColor,
              child: Center(
                child: Text(
                  tr(LocaleKeys.next_step),
                  style: TextStyle(
                    color: kPrimaryLightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
