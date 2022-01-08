import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/info_card.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:geocoder/geocoder.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool loading = false;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;
  Map locationData = {'latitude': 30.003772, 'longitude': 31.446191};
  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId('Office');
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    markers[markerId] = _marker;
  }

  @override
  Widget build(BuildContext context) {
    getMarkers(locationData['latitude'], locationData['longitude']);

    Size size = MediaQuery.of(context).size;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(locationData['latitude'], locationData['longitude']),
      zoom: 14.4746,
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.9,
              height: size.width * 0.6,
              child: SvgPicture.asset(
                'assets/images/unitLogo.svg',
              ),
            ),
            GestureDetector(
              onTap: () {
                launch("tel://${01116233320}");
              },
              child: Card(
                color: kPrimaryColor,
                child: ListTile(
                  title: Text(
                    tr(LocaleKeys.phone_number),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                  subtitle: Text(
                    context.locale == Locale('en')
                        ? '0111 62 333 20'
                        : '۰۱۱۱٦۲۳۳۳۲۰',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      launch("tel://${01116033320}");
                    },
                    icon: Icon(
                      FontAwesomeIcons.phone,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: kPrimaryColor,
              child: ListTile(
                title: Text(
                  tr(LocaleKeys.address),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05,
                  ),
                ),
                subtitle: Text(
                  context.locale == Locale('en')
                      ? 'Narges, Fifth Settlement, New Cairo, Cairo'
                      : 'النرجس، التجمع الخامس، القاهرة الجديدة، القاهرة',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                // trailing: FaIcon(
                //   FontAwesomeIcons.phone,
                //   size: 30,
                //   color: kPrimaryColor,
                // ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              height: size.height * 0.15,
              child: GoogleMap(
                mapType: MapType.terrain,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                initialCameraPosition: selectedPosition,
                markers: Set<Marker>.of(markers.values),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
