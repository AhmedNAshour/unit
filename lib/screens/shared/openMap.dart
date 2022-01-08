import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unit/constants.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:unit/screens/admin/addResale_screen.dart';
import 'package:unit/screens/admin/admin_addCompound_screen.dart';

class MapOpen extends StatefulWidget {
  static const id = 'MapOpen';
  @override
  _MapOpenState createState() => _MapOpenState();
}

class _MapOpenState extends State<MapOpen> {
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

  void locatePosition(double lat, double long) async {
    LatLng latlatPosition = LatLng(lat, long);
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
                locatePosition(locationData['lat'], locationData['long']);
                getMarkers(locationData['lat'], locationData['long']);
              },
              markers: Set<Marker>.of(markers.values),
            ),
            Positioned(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackButton(
                      color: kSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
