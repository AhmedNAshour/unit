import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/components/offers-carousel.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/added.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/database.dart';
import 'dart:io';
import 'package:unit/constants.dart';
import 'package:unit/translations/locale_keys.g.dart';
import 'package:smart_select/smart_select.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:easy_localization/easy_localization.dart';

class AddResale extends StatefulWidget {
  static const id = 'AddResale';
  @override
  _AddResaleState createState() => _AddResaleState();
}

class _AddResaleState extends State<AddResale> {
  // AuthService _auth = AuthService();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;

  // text field state
  int numberBathrooms;
  int numberBedrooms;
  String error = '';
  int price;
  String type = '';
  String description = '';
  String additionalInfo = '';
  int listingType = 1;
  int rentType = 0;
  int unitSize;
  bool loading = false;
  double latitude;
  int level = 0;
  double longitude;
  List<File> images = <File>[];
  List<String> imagesURLs = <String>[];
  bool added = false;
  String finishingType = 'Finished';

  Future getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      setState(() {
        images = result.paths.map((path) => File(path)).toList();
      });
    } else {
      // User canceled the picker
    }
  }

  Map locationData = {};

  final _formKey = GlobalKey<FormState>();

  String value = 'Apartment';
  List<S2Choice<String>> unitTypesAr = [
    S2Choice<String>(value: 'Apartment', title: 'شقة'),
    S2Choice<String>(value: 'Villa', title: 'فيلا'),
    S2Choice<String>(
        value: 'Commercial/Administrative/Medical',
        title: 'تجاري / إداري / طبي'),
    S2Choice<String>(value: 'Vacation', title: 'مصايف'),
  ];

  List<S2Choice<String>> unitTypes = [
    S2Choice<String>(value: 'Apartment', title: 'Apartment'),
    S2Choice<String>(value: 'Villa', title: 'Villa'),
    S2Choice<String>(
        value: 'Commercial/Administrative/Medical',
        title: 'Commercial / Administrative / Medical'),
    S2Choice<String>(value: 'Vacation', title: 'Vacation'),
  ];

  List<String> amenitiesValue = ['Kitchen Appliances'];
  List<S2Choice<String>> amenities = [
    S2Choice<String>(value: 'Kitchen Appliances', title: 'Kitchen Appliances'),
    S2Choice<String>(value: 'Private Garden', title: 'Private Garden'),
    S2Choice<String>(value: 'Central A/C', title: 'Central A/C'),
    S2Choice<String>(value: 'Security', title: 'Security'),
    S2Choice<String>(value: 'Parking', title: 'Parking'),
    S2Choice<String>(value: 'Maids Room', title: 'Maids Room'),
    S2Choice<String>(value: 'Pets Allowed', title: 'Pets Allowed'),
    S2Choice<String>(value: 'Private Pool', title: 'Private Pool'),
    S2Choice<String>(value: 'Elevator', title: 'Elevator'),
    S2Choice<String>(value: 'Furnished', title: 'Furnished'),
    S2Choice<String>(value: 'Private Entrance', title: 'Private Entrance'),
  ];

  List<S2Choice<String>> amenitiesAr = [
    S2Choice<String>(value: 'Kitchen Appliances', title: 'مطبخ'),
    S2Choice<String>(value: 'Private Garden', title: 'حديقة خاصة'),
    S2Choice<String>(value: 'Central A/C', title: 'تكييف مركزي'),
    S2Choice<String>(value: 'Security', title: 'امن'),
    S2Choice<String>(value: 'Parking', title: 'جراج'),
    S2Choice<String>(value: 'Maids Room', title: 'غرفة للمساعدة'),
    S2Choice<String>(value: 'Pets Allowed', title: 'يسمح بالحيوانات الاليفة'),
    S2Choice<String>(value: 'Private Pool', title: 'حمام سباحة خاص'),
    S2Choice<String>(value: 'Elevator', title: 'مصعد'),
    S2Choice<String>(value: 'Furnished', title: 'مفروش'),
    S2Choice<String>(value: 'Private Entrance', title: 'مدخل خاص'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    locationData = ModalRoute.of(context).settings.arguments;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(locationData['latitude'], locationData['longitude']),
      zoom: 14.4746,
    );
    return added
        ? Added('Property')
        : loading
            ? Loading()
            : StreamBuilder<UserData>(
                stream: DatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    return SafeArea(
                      child: Scaffold(
                        backgroundColor: kPrimaryLightColor,
                        body: Stack(
                          children: [
                            OffersCarousel(
                              images: images,
                            ),
                            Positioned(
                              top: height * 0.02,
                              left: width * 0.05,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3000),
                                child: Container(
                                  color: kPrimaryLightColor,
                                  height: height * 0.05,
                                  width: height * 0.05,
                                  child: BackButton(
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: height * 0.02,
                              right: width * 0.05,
                              child: GestureDetector(
                                onTap: () async {
                                  await getImage();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3000),
                                  child: Container(
                                    color: kPrimaryLightColor,
                                    height: height * 0.05,
                                    width: height * 0.05,
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 30),
                                width: double.infinity,
                                height: size.height * 0.6,
                                decoration: BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(53),
                                      topRight: Radius.circular(53)),
                                ),
                                child: Container(
                                  // height: size.height * 0.5,
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.2,
                                            child: GoogleMap(
                                              mapType: MapType.terrain,
                                              myLocationEnabled: true,
                                              zoomGesturesEnabled: true,
                                              zoomControlsEnabled: true,
                                              initialCameraPosition:
                                                  selectedPosition,
                                              markers: Set<Marker>.of(
                                                  markers.values),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      listingType = 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    // width: size.width * 0.35,
                                                    // height: size.height * 0.07,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: listingType == 1
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: listingType == 1
                                                            ? Colors.transparent
                                                            : kPrimaryLightColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr(LocaleKeys.for_sale),
                                                        style: TextStyle(
                                                          color: listingType ==
                                                                  1
                                                              ? Colors.white
                                                              : kPrimaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      listingType = 0;
                                                    });
                                                  },
                                                  child: Container(
                                                    // width: size.width * 0.35,
                                                    // height: size.height * 0.07,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: listingType == 0
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: listingType == 0
                                                            ? Colors.transparent
                                                            : kPrimaryLightColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr(LocaleKeys.for_rent),
                                                        style: TextStyle(
                                                          color: listingType ==
                                                                  0
                                                              ? Colors.white
                                                              : kPrimaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.02),
                                          listingType == 0
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            rentType = 1;
                                                          });
                                                        },
                                                        child: Container(
                                                          // width: size.width * 0.35,
                                                          // height: size.height * 0.07,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical:
                                                                size.height *
                                                                    0.02,
                                                            horizontal:
                                                                size.width *
                                                                    0.04,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: rentType == 1
                                                                ? kPrimaryColor
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color: rentType ==
                                                                      1
                                                                  ? Colors
                                                                      .transparent
                                                                  : kPrimaryLightColor,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              tr(LocaleKeys
                                                                  .rent_month),
                                                              style: TextStyle(
                                                                color: rentType ==
                                                                        1
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryTextColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            rentType = 2;
                                                          });
                                                        },
                                                        child: Container(
                                                          // width: size.width * 0.35,
                                                          // height: size.height * 0.07,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical:
                                                                size.height *
                                                                    0.02,
                                                            horizontal:
                                                                size.width *
                                                                    0.04,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: rentType == 2
                                                                ? kPrimaryColor
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color: rentType ==
                                                                      2
                                                                  ? Colors
                                                                      .transparent
                                                                  : kPrimaryLightColor,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              tr(LocaleKeys
                                                                  .rent_day),
                                                              style: TextStyle(
                                                                color: rentType ==
                                                                        2
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryTextColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          listingType == 0
                                              ? SizedBox(height: height * 0.02)
                                              : Container(),

                                          SmartSelect<String>.single(
                                            title: tr(LocaleKeys.unit_type),
                                            value: value,
                                            choiceItems:
                                                context.locale == Locale('en')
                                                    ? unitTypes
                                                    : unitTypesAr,
                                            onChange: (state) => setState(() {
                                              value = state.value;
                                            }),
                                            modalType: S2ModalType.popupDialog,
                                            choiceType: S2ChoiceType.chips,
                                          ),
                                          SizedBox(height: height * 0.02),
                                          SmartSelect<String>.multiple(
                                            title: tr(LocaleKeys.amenities),
                                            value: amenitiesValue,
                                            choiceItems:
                                                context.locale == Locale('en')
                                                    ? amenities
                                                    : amenitiesAr,
                                            onChange: (state) => setState(() {
                                              amenitiesValue = state.value;
                                            }),
                                            modalType: S2ModalType.popupDialog,
                                            choiceType: S2ChoiceType.chips,
                                          ),
                                          SizedBox(height: height * 0.02),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: RoundedInputField(
                                                  textInputType:
                                                      TextInputType.number,
                                                  obsecureText: false,
                                                  icon: FontAwesomeIcons
                                                      .moneyBill,
                                                  hintText: listingType == 1
                                                      ? tr(LocaleKeys.price)
                                                      : rentType == 1
                                                          ? tr(LocaleKeys
                                                              .price_month)
                                                          : tr(LocaleKeys
                                                              .egp_day),
                                                  onChanged: (val) {
                                                    setState(() =>
                                                        price = int.parse(val));
                                                  },
                                                  validator: (val) => val
                                                              .isEmpty ||
                                                          int.tryParse(val) ==
                                                              null
                                                      //Translate this
                                                      ? 'Enter a valid price'
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Expanded(
                                                child: RoundedInputField(
                                                  textInputType:
                                                      TextInputType.number,
                                                  obsecureText: false,
                                                  icon: FontAwesomeIcons
                                                      .rulerCombined,
                                                  hintText: tr(LocaleKeys.sqm),
                                                  onChanged: (val) {
                                                    setState(() => unitSize =
                                                        int.parse(val));
                                                  },
                                                  validator: (val) => val
                                                              .isEmpty ||
                                                          int.tryParse(val) ==
                                                              null
                                                      ? 'Enter a valid number'
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // RoundedInputField(
                                          //   textInputType: TextInputType.number,
                                          //   obsecureText: false,
                                          //   icon: FontAwesomeIcons.building,
                                          //   hintText: 'Level',
                                          //   onChanged: (val) {
                                          //     setState(
                                          //         () => level = int.parse(val));
                                          //   },
                                          //   validator: (val) => val.isEmpty ||
                                          //           int.tryParse(val) == null
                                          //       ? 'Enter a valid number'
                                          //       : null,
                                          // ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RoundedInputField(
                                                  textInputType:
                                                      TextInputType.number,
                                                  obsecureText: false,
                                                  icon: FontAwesomeIcons.bed,
                                                  hintText:
                                                      tr(LocaleKeys.bedrooms),
                                                  onChanged: (val) {
                                                    setState(() =>
                                                        numberBedrooms =
                                                            int.parse(val));
                                                  },
                                                  validator: (val) => val
                                                              .isEmpty ||
                                                          int.tryParse(val) ==
                                                              null
                                                      ? 'Enter a valid number'
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Expanded(
                                                child: RoundedInputField(
                                                  textInputType:
                                                      TextInputType.number,
                                                  obsecureText: false,
                                                  icon: FontAwesomeIcons.bath,
                                                  hintText:
                                                      tr(LocaleKeys.bathrooms),
                                                  onChanged: (val) {
                                                    setState(() =>
                                                        numberBathrooms =
                                                            int.parse(val));
                                                  },
                                                  validator: (val) => val
                                                              .isEmpty ||
                                                          int.tryParse(val) ==
                                                              null
                                                      ? 'Enter a valid number'
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      finishingType =
                                                          'Finished';
                                                    });
                                                  },
                                                  child: Container(
                                                    // width: size.width * 0.35,
                                                    // height: size.height * 0.07,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: finishingType ==
                                                              'Finished'
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: finishingType ==
                                                                'Finished'
                                                            ? Colors.transparent
                                                            : kPrimaryLightColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr(LocaleKeys.finished),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: finishingType ==
                                                                  'Finished'
                                                              ? Colors.white
                                                              : kPrimaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      finishingType =
                                                          'Semi-Finished';
                                                    });
                                                  },
                                                  child: Container(
                                                    // width: size.width * 0.35,
                                                    // height: size.height * 0.07,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: finishingType ==
                                                              'Semi-Finished'
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: finishingType ==
                                                                'Semi-Finished'
                                                            ? Colors.transparent
                                                            : kPrimaryLightColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr(LocaleKeys
                                                            .semi_finished),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: finishingType ==
                                                                  'Semi-Finished'
                                                              ? Colors.white
                                                              : kPrimaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      finishingType =
                                                          'Core & Shell';
                                                    });
                                                  },
                                                  child: Container(
                                                    // width: size.width * 0.35,
                                                    // height: size.height * 0.07,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          size.height * 0.02,
                                                      horizontal:
                                                          size.width * 0.04,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: finishingType ==
                                                              'Core & Shell'
                                                          ? kPrimaryColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: finishingType ==
                                                                'Core & Shell'
                                                            ? Colors.transparent
                                                            : kPrimaryLightColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        tr(LocaleKeys
                                                            .core_shell),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: finishingType ==
                                                                  'Core & Shell'
                                                              ? Colors.white
                                                              : kPrimaryTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                          userData.role == 'admin' ||
                                                  userData.role == 'salesman'
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      labelText:
                                                          'Additional Info',
                                                      labelStyle: TextStyle(
                                                        color:
                                                            kPrimaryLightTextColor,
                                                      ),
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .infoCircle,
                                                        color:
                                                            kPrimaryLightTextColor,
                                                      ),
                                                      hintText:
                                                          'Additional Info',
                                                      focusColor: kPrimaryColor,
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          additionalInfo = val);
                                                    },
                                                    validator: (val) => val
                                                            .isEmpty
                                                        ? 'Enter additional info'
                                                        : null,
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(height: size.height * 0.02),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: 'Description',
                                                labelStyle: TextStyle(
                                                  color: kPrimaryLightTextColor,
                                                ),
                                                icon: Icon(
                                                  FontAwesomeIcons.infoCircle,
                                                  color: kPrimaryLightTextColor,
                                                ),
                                                hintText: 'Description',
                                                focusColor: kPrimaryColor,
                                              ),
                                              onChanged: (val) {
                                                setState(
                                                    () => description = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter Description'
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                          RoundedButton(
                                            text: tr(LocaleKeys.add_property),
                                            press: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                if (images.length == 0) {
                                                  setState(() {
                                                    error = 'Please add images';
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  dynamic result;
                                                  String id = FirebaseFirestore
                                                      .instance
                                                      .collection('resale')
                                                      .doc()
                                                      .id;
                                                  imagesURLs =
                                                      await DatabaseService()
                                                          .getDownloadURLs(
                                                              images, id);
                                                  await DatabaseService()
                                                      .updatePropertyData(
                                                    description: description,
                                                    additionalInfo:
                                                        additionalInfo,
                                                    amenities: amenitiesValue,
                                                    imagesURLs: imagesURLs,
                                                    numberBathrooms:
                                                        numberBathrooms,
                                                    numberBedrooms:
                                                        numberBedrooms,
                                                    price: price,
                                                    type: value,
                                                    finishingType:
                                                        finishingType,
                                                    // level: level,
                                                    latitude: locationData[
                                                        'latitude'],
                                                    longitude: locationData[
                                                        'longitude'],
                                                    governate:
                                                        locationData['govName'],
                                                    district: locationData[
                                                        'districtName'],
                                                    area: locationData[
                                                        'areaName'],
                                                    governateAr: locationData[
                                                        'govNameAr'],
                                                    districtAr: locationData[
                                                        'districtNameAr'],
                                                    areaAr: locationData[
                                                        'areaNameAr'],
                                                    size: unitSize,
                                                    listingType: listingType,
                                                    rentType: rentType,
                                                    userId: user.uid,
                                                    userName: userData.name,
                                                    userNumber:
                                                        userData.phoneNumber,
                                                    userPic: userData.picURL,
                                                    userRole: userData.role,
                                                    userEmail: userData.email,
                                                    userGender: userData.gender,
                                                    status:
                                                        userData.role == 'admin'
                                                            ? 'active'
                                                            : 'pending',
                                                  );
                                                  setState(() {
                                                    added = true;
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            error,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Loading();
                  }
                });
  }
}
